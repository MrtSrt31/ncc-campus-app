import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/exam_model.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';

class ExamProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final FirestoreService _firestore = FirestoreService();

  List<Exam> _allExams = [];
  List<ExamScheduleFile> _schedules = [];
  List<String> _selectedCourseCodes = [];
  bool _loading = true;
  bool _initialized = false;

  ExamProvider(this._prefs) {
    _loadSelectedCourses();
  }

  // ── Getters ────────────────────────────────────────────

  List<Exam> get allExams => _allExams;
  List<ExamScheduleFile> get schedules => _schedules;
  List<String> get selectedCourseCodes => List.unmodifiable(_selectedCourseCodes);
  bool get loading => _loading;

  List<Exam> get selectedExams {
    final normalized = _selectedCourseCodes.map(_normalize).toSet();
    return _allExams
        .where((e) => normalized.contains(_normalize(e.courseCode)))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Exam> get upcomingExams {
    final now = DateTime.now().subtract(const Duration(days: 1));
    return selectedExams.where((e) => e.date.isAfter(now)).toList();
  }

  Set<String> get availableCourseCodes =>
      _allExams.map((e) => e.courseCode).toSet();

  Set<String> get availableExamTypes =>
      _allExams.map((e) => e.examType).toSet();

  Map<DateTime, List<Exam>> get examsByDate {
    final map = <DateTime, List<Exam>>{};
    for (final exam in selectedExams) {
      final key = DateTime(exam.date.year, exam.date.month, exam.date.day);
      map.putIfAbsent(key, () => []).add(exam);
    }
    return map;
  }

  List<Exam> getExamsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return examsByDate[key] ?? [];
  }

  // ── Init ───────────────────────────────────────────────

  void init() {
    if (_initialized) return;
    _initialized = true;
    _listenToExams();
    _listenToSchedules();
  }

  void _listenToExams() {
    _firestore.streamExams().listen((exams) {
      _allExams = exams;
      _loading = false;
      _rescheduleNotifications();
      notifyListeners();
    });
  }

  void _listenToSchedules() {
    _firestore.streamExamSchedules().listen((schedules) {
      _schedules = schedules;
      notifyListeners();
    });
  }

  // ── Course Selection ───────────────────────────────────

  void _loadSelectedCourses() {
    _selectedCourseCodes = _prefs.getStringList('selectedExamCourses') ?? [];
  }

  Future<void> _saveSelectedCourses() async {
    await _prefs.setStringList('selectedExamCourses', _selectedCourseCodes);
  }

  void toggleCourse(String courseCode) {
    if (_selectedCourseCodes.contains(courseCode)) {
      _selectedCourseCodes.remove(courseCode);
    } else {
      _selectedCourseCodes.add(courseCode);
    }
    _saveSelectedCourses();
    _rescheduleNotifications();
    notifyListeners();
  }

  void selectCourses(List<String> codes) {
    _selectedCourseCodes = List.from(codes);
    _saveSelectedCourses();
    _rescheduleNotifications();
    notifyListeners();
  }

  bool isCourseSelected(String courseCode) =>
      _selectedCourseCodes.contains(courseCode);

  // ── Notifications ──────────────────────────────────────

  Future<void> _rescheduleNotifications() async {
    try {
      await NotificationService.scheduleExamNotifications(selectedExams);
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
  }

  // ── ICS Export ─────────────────────────────────────────

  Future<void> exportToCalendar() async {
    final exams = selectedExams;
    if (exams.isEmpty) return;
    final ics = _generateIcs(exams);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ncc_exams.ics');
    await file.writeAsString(ics);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/calendar')],
      text: 'NCC Sınav Takvimi',
    );
  }

  Future<void> exportSingleExam(Exam exam) async {
    final ics = _generateIcs([exam]);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ncc_exam_${exam.courseCode.replaceAll(' ', '_')}.ics');
    await file.writeAsString(ics);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/calendar')],
      text: '${exam.courseCode} ${exam.examType}',
    );
  }

  String _generateIcs(List<Exam> exams) {
    final buf = StringBuffer();
    buf.writeln('BEGIN:VCALENDAR');
    buf.writeln('VERSION:2.0');
    buf.writeln('PRODID:-//NCC Campus//Exam Schedule//EN');
    buf.writeln('CALSCALE:GREGORIAN');
    buf.writeln('METHOD:PUBLISH');

    for (final exam in exams) {
      final start = exam.startDateTime;
      final end = exam.endDateTime;
      final uid = '${_normalize(exam.courseCode)}-${exam.examType}-${exam.id}@ncc-campus';

      buf.writeln('BEGIN:VEVENT');
      buf.writeln('UID:$uid');
      buf.writeln('DTSTART:${_icsDate(start)}');
      buf.writeln('DTEND:${_icsDate(end)}');
      buf.writeln('SUMMARY:${exam.courseCode} - ${exam.examType}');
      if (exam.locationString.isNotEmpty) {
        buf.writeln('LOCATION:${exam.locationString}');
      }
      buf.writeln(
          'DESCRIPTION:${exam.courseCode} ${exam.examType}\\n${exam.startTime}-${exam.endTime}\\n${exam.locationString}');
      // Alarm: 1 day before
      buf.writeln('BEGIN:VALARM');
      buf.writeln('TRIGGER:-P1D');
      buf.writeln('ACTION:DISPLAY');
      buf.writeln('DESCRIPTION:Yarin: ${exam.courseCode} ${exam.examType}');
      buf.writeln('END:VALARM');
      // Alarm: 2 hours before
      buf.writeln('BEGIN:VALARM');
      buf.writeln('TRIGGER:-PT2H');
      buf.writeln('ACTION:DISPLAY');
      buf.writeln('DESCRIPTION:2 saat sonra: ${exam.courseCode} ${exam.examType}');
      buf.writeln('END:VALARM');
      buf.writeln('END:VEVENT');
    }

    buf.writeln('END:VCALENDAR');
    return buf.toString();
  }

  String _icsDate(DateTime dt) {
    return '${dt.year}'
        '${dt.month.toString().padLeft(2, '0')}'
        '${dt.day.toString().padLeft(2, '0')}'
        'T${dt.hour.toString().padLeft(2, '0')}'
        '${dt.minute.toString().padLeft(2, '0')}'
        '00';
  }

  static String _normalize(String code) =>
      code.replaceAll(RegExp(r'\s+'), '').toUpperCase();
}
