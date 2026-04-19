import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/exam_provider.dart';
import '../../core/models/exam_model.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String? _selectedExamType;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = context.watch<ExamProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        title: Text(l.examsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: l.selectCourses,
            onPressed: () => _showCourseSelection(context, provider),
          ),
          if (provider.selectedExams.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: l.exportCalendar,
              onPressed: () => provider.exportToCalendar(),
            ),
        ],
      ),
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _buildBody(context, provider, l),
    );
  }

  Widget _buildBody(
      BuildContext context, ExamProvider provider, AppLocalizations l) {
    if (provider.allExams.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_busy, color: AppColors.txtHint(context), size: 64),
              const SizedBox(height: 16),
              Text(l.noExamSchedule,
                  style: TextStyle(
                      color: AppColors.txtSec(context), fontSize: 16)),
              const SizedBox(height: 8),
              Text(l.noExamScheduleHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.txtHint(context), fontSize: 13)),
            ],
          ),
        ),
      );
    }

    if (provider.selectedCourseCodes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined,
                  color: AppColors.txtHint(context), size: 64),
              const SizedBox(height: 16),
              Text(l.selectCoursesPrompt,
                  style: TextStyle(
                      color: AppColors.txtSec(context), fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showCourseSelection(context, provider),
                icon: const Icon(Icons.add),
                label: Text(l.selectCourses),
              ),
            ],
          ),
        ),
      );
    }

    final examTypes = provider.availableExamTypes.toList()..sort();
    final filteredExams = _selectedExamType == null
        ? provider.selectedExams
        : provider.selectedExams
            .where((e) => e.examType == _selectedExamType)
            .toList();

    // Build date->exam map for filtered exams
    final filteredByDate = <DateTime, List<Exam>>{};
    for (final exam in filteredExams) {
      final key = DateTime(exam.date.year, exam.date.month, exam.date.day);
      filteredByDate.putIfAbsent(key, () => []).add(exam);
    }

    final dayExams = _selectedDay != null
        ? (filteredByDate[DateTime(
                _selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ??
            [])
        : <Exam>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TableCalendar<Exam>(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return filteredByDate[key] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle:
                    TextStyle(color: AppColors.txt(context)),
                weekendTextStyle:
                    TextStyle(color: AppColors.txtSec(context)),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                markerSize: 6,
                markersMaxCount: 3,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    color: AppColors.txt(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: AppColors.txt(context)),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: AppColors.txt(context)),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: AppColors.txtHint(context), fontWeight: FontWeight.w600),
                weekendStyle: TextStyle(
                    color: AppColors.txtHint(context), fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Exam type filter chips
          if (examTypes.length > 1) ...[
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: l.all,
                    selected: _selectedExamType == null,
                    onTap: () => setState(() => _selectedExamType = null),
                  ),
                  const SizedBox(width: 8),
                  ...examTypes.map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: type,
                          selected: _selectedExamType == type,
                          onTap: () =>
                              setState(() => _selectedExamType = type),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Selected day header
          if (_selectedDay != null) ...[
            Text(
              DateFormat('d MMMM yyyy, EEEE',
                      AppLocalizations.of(context).isTr ? 'tr' : 'en')
                  .format(_selectedDay!),
              style: TextStyle(
                color: AppColors.txt(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Exam cards for selected day
          if (dayExams.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l.noExamsOnDay,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.txtHint(context), fontSize: 14),
              ),
            )
          else
            ...dayExams.map((exam) => _ExamCard(
                  exam: exam,
                  onAddToCalendar: () => provider.exportSingleExam(exam),
                )),

          // Upcoming exams section
          const SizedBox(height: 24),
          Text(
            l.upcomingExams,
            style: TextStyle(
              color: AppColors.txt(context),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (provider.upcomingExams.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l.noUpcomingExams,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: AppColors.txtHint(context), fontSize: 14),
              ),
            )
          else
            ...provider.upcomingExams.map((exam) => _ExamCard(
                  exam: exam,
                  showDate: true,
                  onAddToCalendar: () => provider.exportSingleExam(exam),
                )),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showCourseSelection(BuildContext context, ExamProvider provider) {
    final l = AppLocalizations.of(context);
    final available = provider.availableCourseCodes.toList()..sort();
    final selected = List<String>.from(provider.selectedCourseCodes);
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final filtered = searchQuery.isEmpty
              ? available
              : available
                  .where((c) =>
                      c.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();

          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            builder: (_, scrollController) => Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
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
                    l.selectCourses,
                    style: TextStyle(
                      color: AppColors.txt(context),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search field
                  TextField(
                    decoration: InputDecoration(
                      hintText: l.searchCourse,
                      prefixIcon: Icon(Icons.search,
                          color: AppColors.txtHint(context)),
                      filled: true,
                      fillColor: AppColors.cardBg(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style:
                        TextStyle(color: AppColors.txt(context)),
                    onChanged: (v) =>
                        setSheetState(() => searchQuery = v),
                  ),
                  const SizedBox(height: 8),
                  // Select all / deselect all
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setSheetState(
                            () => selected.addAll(filtered
                                .where((c) => !selected.contains(c)))),
                        child: Text(l.selectAll,
                            style: const TextStyle(
                                color: AppColors.primary)),
                      ),
                      TextButton(
                        onPressed: () => setSheetState(() =>
                            selected.removeWhere(
                                (c) => filtered.contains(c))),
                        child: Text(l.deselectAll,
                            style: const TextStyle(
                                color: AppColors.error)),
                      ),
                      const Spacer(),
                      Text(
                        '${selected.length} ${l.selected}',
                        style: TextStyle(
                            color: AppColors.txtHint(context), fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Course list
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(l.noCourseFound,
                                style: TextStyle(
                                    color: AppColors.txtHint(context))))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final code = filtered[i];
                              final isSelected =
                                  selected.contains(code);
                              return CheckboxListTile(
                                title: Text(code,
                                    style: TextStyle(
                                        color:
                                            AppColors.txt(context),
                                        fontSize: 15)),
                                value: isSelected,
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity
                                        .leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                onChanged: (_) {
                                  setSheetState(() {
                                    if (isSelected) {
                                      selected.remove(code);
                                    } else {
                                      selected.add(code);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.selectCourses(selected);
                        Navigator.pop(ctx);
                      },
                      child: Text(l.save),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Exam Card ────────────────────────────────────────────

class _ExamCard extends StatelessWidget {
  final Exam exam;
  final bool showDate;
  final VoidCallback onAddToCalendar;

  const _ExamCard({
    required this.exam,
    this.showDate = false,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _examTypeColor(exam.examType).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exam.examType,
                  style: TextStyle(
                    color: _examTypeColor(exam.examType),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  exam.courseCode,
                  style: TextStyle(
                    color: AppColors.txt(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAddToCalendar,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calendar_month,
                      color: AppColors.accent, size: 20),
                ),
              ),
            ],
          ),
          if (exam.courseName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              exam.courseName,
              style: TextStyle(
                  color: AppColors.txtSec(context), fontSize: 13),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (showDate) ...[
                Icon(Icons.calendar_today,
                    color: AppColors.txtHint(context), size: 14),
                const SizedBox(width: 4),
                Text(
                  DateFormat('d MMM yyyy',
                          AppLocalizations.of(context).isTr ? 'tr' : 'en')
                      .format(exam.date),
                  style: TextStyle(
                      color: AppColors.txtSec(context), fontSize: 13),
                ),
                const SizedBox(width: 16),
              ],
              Icon(Icons.access_time,
                  color: AppColors.txtHint(context), size: 14),
              const SizedBox(width: 4),
              Text(
                '${exam.startTime} - ${exam.endTime}',
                style: TextStyle(
                    color: AppColors.txtSec(context), fontSize: 13),
              ),
              if (exam.locationString.isNotEmpty) ...[
                const SizedBox(width: 16),
                Icon(Icons.location_on_outlined,
                    color: AppColors.txtHint(context), size: 14),
                const SizedBox(width: 4),
                Text(
                  exam.locationString,
                  style: TextStyle(
                      color: AppColors.txtSec(context), fontSize: 13),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _examTypeColor(String type) {
    final t = type.toUpperCase();
    if (t.contains('MT') || t.contains('MIDTERM')) return AppColors.warning;
    if (t.contains('FINAL')) return AppColors.error;
    if (t.contains('QUIZ')) return AppColors.accent;
    if (t.contains('MAKE')) return Colors.purple;
    return AppColors.primary;
  }
}

// ── Filter Chip ──────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
