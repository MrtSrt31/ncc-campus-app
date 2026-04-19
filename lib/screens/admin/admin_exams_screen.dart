import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/exam_model.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/exam_parser_service.dart';

class AdminExamsScreen extends StatefulWidget {
  const AdminExamsScreen({super.key});

  @override
  State<AdminExamsScreen> createState() => _AdminExamsScreenState();
}

class _AdminExamsScreenState extends State<AdminExamsScreen> {
  final _firestore = FirestoreService();
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: Text(l.manageExams)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploading ? null : _uploadExamSchedule,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload_file),
        label: Text(l.uploadPdf),
      ),
      body: StreamBuilder<List<ExamScheduleFile>>(
        stream: _firestore.streamExamSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final schedules = snapshot.data ?? [];

          if (schedules.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file,
                        color: AppColors.txtHint(context), size: 64),
                    const SizedBox(height: 16),
                    Text(l.noExamSchedule,
                        style: TextStyle(
                            color: AppColors.txtSec(context), fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(l.uploadExamHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.txtHint(context), fontSize: 13)),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return _ScheduleCard(
                schedule: schedule,
                onDelete: () => _confirmDelete(schedule),
                onViewExams: () => _viewExams(schedule),
              );
            },
          );
        },
      ),
    );
  }

  // ── Upload Flow ────────────────────────────────────────

  Future<void> _uploadExamSchedule() async {
    final l = AppLocalizations.of(context);

    // 1. Pick PDF file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;

    final fileName = result.files.single.name;
    final bytes = result.files.single.bytes!;

    // 2. Parse PDF
    setState(() => _uploading = true);
    List<ParsedExam> parsedExams;
    String rawText = '';
    try {
      rawText = ExamParserService.extractText(bytes);
      parsedExams = ExamParserService.parseText(rawText);
    } catch (e) {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: PDF okunamadı - $e')),
        );
      }
      return;
    }
    setState(() => _uploading = false);

    if (!mounted) return;

    // 3. Show preview dialog
    final confirmed = await _showPreviewDialog(
      fileName: fileName,
      parsedExams: parsedExams,
      rawText: rawText,
    );

    if (confirmed == null || !mounted) return;

    setState(() => _uploading = true);

    try {
      // 4. Check for duplicate filename
      final existing = await _firestore.findScheduleByFileName(fileName);
      if (existing != null) {
        // Delete old schedule, exams, and storage file
        await _firestore.deleteExamSchedule(existing.id);
        try {
          if (Firebase.apps.isNotEmpty) {
            await FirebaseStorage.instance
                .ref('exam_schedules/$fileName')
                .delete();
          }
        } catch (_) {}
      }

      // 5. Upload PDF to Firebase Storage
      String downloadUrl = '';
      if (Firebase.apps.isNotEmpty) {
        try {
          final ref = FirebaseStorage.instance
              .ref()
              .child('exam_schedules/$fileName');
          await ref.putData(
              bytes, SettableMetadata(contentType: 'application/pdf'));
          downloadUrl = await ref.getDownloadURL();
        } catch (e) {
          debugPrint('Storage upload failed: $e');
        }
      }

      // 6. Save schedule to Firestore
      final scheduleId = await _firestore.addExamSchedule(ExamScheduleFile(
        id: '',
        fileName: fileName,
        downloadUrl: downloadUrl,
        semester: confirmed['semester']!,
        examType: confirmed['examType']!,
        uploadedAt: DateTime.now(),
        isActive: true,
        examCount: parsedExams.length,
      ));

      // 7. Save parsed exams to Firestore
      if (parsedExams.isNotEmpty && scheduleId.isNotEmpty) {
        final exams = parsedExams.map((p) {
          final date = ExamParserService.parseDateString(p.date);
          return Exam(
            id: '',
            scheduleId: scheduleId,
            courseCode: p.courseCode,
            examType: confirmed['examType']!,
            date: date ?? DateTime.now(),
            startTime: p.startTime,
            endTime: p.endTime,
            building: p.building,
            room: p.room,
            sections: p.sections.isEmpty ? null : p.sections,
          );
        }).toList();

        await _firestore.addExamsBatch(exams);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${l.success}: ${parsedExams.length} ${l.examsFound}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e')),
        );
      }
    }

    setState(() => _uploading = false);
  }

  // ── Preview Dialog ─────────────────────────────────────

  Future<Map<String, String>?> _showPreviewDialog({
    required String fileName,
    required List<ParsedExam> parsedExams,
    required String rawText,
  }) async {
    final l = AppLocalizations.of(context);
    final semesterController = TextEditingController();
    String selectedExamType = 'MT1';

    // Try to auto-detect from text
    final textLower = rawText.toLowerCase();
    if (textLower.contains('final')) {
      selectedExamType = 'Final';
    } else if (textLower.contains('midterm 2') || textLower.contains('mt2') || textLower.contains('midterm ii')) {
      selectedExamType = 'MT2';
    } else if (textLower.contains('quiz')) {
      selectedExamType = 'Quiz';
    }

    // Auto-detect semester
    final yearPattern = RegExp(r'20\d{2}\s*[-–]\s*20\d{2}');
    final yearMatch = yearPattern.firstMatch(rawText);
    if (yearMatch != null) {
      String semester = yearMatch.group(0)!;
      if (textLower.contains('spring') || textLower.contains('bahar')) {
        semester += ' Spring';
      } else if (textLower.contains('fall') || textLower.contains('güz')) {
        semester += ' Fall';
      } else if (textLower.contains('summer') || textLower.contains('yaz')) {
        semester += ' Summer';
      }
      semesterController.text = semester;
    }

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surf(context),
          title: Text(
            l.examPreview,
            style: TextStyle(color: AppColors.txt(context)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File info
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf,
                            color: AppColors.error, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fileName,
                                  style: TextStyle(
                                      color: AppColors.txt(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                '${parsedExams.length} ${l.examsFound}',
                                style: TextStyle(
                                  color: parsedExams.isEmpty
                                      ? AppColors.warning
                                      : AppColors.success,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Semester input
                  TextField(
                    controller: semesterController,
                    decoration: InputDecoration(
                      labelText: l.semester,
                      hintText: '2025-2026 Spring',
                      labelStyle:
                          TextStyle(color: AppColors.txtSec(context)),
                      hintStyle: TextStyle(color: AppColors.txtHint(context)),
                    ),
                    style: TextStyle(color: AppColors.txt(context)),
                  ),
                  const SizedBox(height: 12),

                  // Exam type selector
                  Text(l.examTypeLabel,
                      style: TextStyle(
                          color: AppColors.txtSec(context), fontSize: 13)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['MT1', 'MT2', 'Final', 'Quiz', 'Make-up']
                        .map((type) => ChoiceChip(
                              label: Text(type),
                              selected: selectedExamType == type,
                              onSelected: (_) => setDialogState(
                                  () => selectedExamType = type),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: selectedExamType == type
                                    ? Colors.white
                                    : AppColors.txt(context),
                              ),
                              backgroundColor: AppColors.cardBg(context),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Parsed exams preview
                  if (parsedExams.isNotEmpty) ...[
                    Text(
                      '${l.parsedExams} (${parsedExams.length}):',
                      style: TextStyle(
                          color: AppColors.txt(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: parsedExams.length,
                        itemBuilder: (_, i) {
                          final e = parsedExams[i];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(e.courseCode,
                                      style: TextStyle(
                                          color: AppColors.txt(context),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(e.date,
                                      style: TextStyle(
                                          color: AppColors.txtSec(context),
                                          fontSize: 12)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${e.startTime}-${e.endTime}',
                                      style: TextStyle(
                                          color: AppColors.txtSec(context),
                                          fontSize: 12)),
                                ),
                                Expanded(
                                  child: Text(
                                      e.building.isNotEmpty
                                          ? '${e.building}-${e.room}'
                                          : '',
                                      style: TextStyle(
                                          color: AppColors.txtHint(context),
                                          fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.noExamsParsed,
                              style: const TextStyle(
                                  color: AppColors.warning, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel,
                  style: TextStyle(color: AppColors.txtSec(context))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, {
                  'semester': semesterController.text,
                  'examType': selectedExamType,
                });
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }

  // ── View Exams ─────────────────────────────────────────

  void _viewExams(ExamScheduleFile schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (_, scrollController) => StreamBuilder<List<Exam>>(
          stream: _firestore.streamExams(),
          builder: (context, snapshot) {
            final allExams = snapshot.data ?? [];
            final scheduleExams = allExams
                .where((e) => e.scheduleId == schedule.id)
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));

            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.txtHint(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${schedule.examType} - ${schedule.semester}',
                    style: TextStyle(
                      color: AppColors.txt(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${scheduleExams.length} sınav',
                    style: TextStyle(
                        color: AppColors.txtHint(context), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: scheduleExams.length,
                      itemBuilder: (_, i) {
                        final exam = scheduleExams[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(exam.courseCode,
                                    style: TextStyle(
                                        color: AppColors.txt(context),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                    DateFormat('d MMM yyyy').format(exam.date),
                                    style: TextStyle(
                                        color: AppColors.txtSec(context),
                                        fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    '${exam.startTime}-${exam.endTime}',
                                    style: TextStyle(
                                        color: AppColors.txtSec(context),
                                        fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(exam.locationString,
                                    style: TextStyle(
                                        color: AppColors.txtHint(context),
                                        fontSize: 13)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Delete ─────────────────────────────────────────────

  Future<void> _confirmDelete(ExamScheduleFile schedule) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surf(context),
        title: Text(l.delete,
            style: TextStyle(color: AppColors.txt(context))),
        content: Text(
          '${schedule.fileName}\n\n${l.deleteScheduleConfirm}',
          style: TextStyle(color: AppColors.txtSec(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel,
                style: TextStyle(color: AppColors.txtSec(context))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _firestore.deleteExamSchedule(schedule.id);
      // Delete from storage
      if (Firebase.apps.isNotEmpty && schedule.downloadUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance
              .ref('exam_schedules/${schedule.fileName}')
              .delete();
        } catch (_) {}
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.success),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e')),
        );
      }
    }
  }
}

// ── Schedule Card ────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final ExamScheduleFile schedule;
  final VoidCallback onDelete;
  final VoidCallback onViewExams;

  const _ScheduleCard({
    required this.schedule,
    required this.onDelete,
    required this.onViewExams,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(schedule.fileName,
                        style: TextStyle(
                            color: AppColors.txt(context),
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      '${schedule.examType} • ${schedule.semester}',
                      style: TextStyle(
                          color: AppColors.txtSec(context), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${schedule.examCount} sınav',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('d MMM yyyy HH:mm').format(schedule.uploadedAt),
                style: TextStyle(
                    color: AppColors.txtHint(context), fontSize: 12),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.visibility_outlined,
                    color: AppColors.accent, size: 20),
                onPressed: onViewExams,
                tooltip: 'Sınavları Gör',
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: onDelete,
                tooltip: 'Sil',
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
