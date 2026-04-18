import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course {
  String name;
  double credits;
  String grade;

  Course({required this.name, required this.credits, required this.grade});

  Map<String, dynamic> toJson() => {
        'name': name,
        'credits': credits,
        'grade': grade,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        name: json['name'] as String,
        credits: (json['credits'] as num).toDouble(),
        grade: json['grade'] as String,
      );
}

class GpaProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  final List<Course> _courses = [];
  double _currentGpa = 0.0;
  double _totalCredits = 0.0;

  static const Map<String, double> gradePoints = {
    'AA': 4.0,
    'BA': 3.5,
    'BB': 3.0,
    'CB': 2.5,
    'CC': 2.0,
    'DC': 1.5,
    'DD': 1.0,
    'FD': 0.5,
    'FF': 0.0,
  };

  GpaProvider(this._prefs) {
    _loadFromPrefs();
  }

  List<Course> get courses => List.unmodifiable(_courses);
  double get currentGpa => _currentGpa;
  double get totalCredits => _totalCredits;

  void _loadFromPrefs() {
    final coursesJson = _prefs.getString('courses');
    if (coursesJson != null) {
      final List<dynamic> decoded = jsonDecode(coursesJson);
      _courses.addAll(decoded.map((e) => Course.fromJson(e)));
      _calculateGpa();
    }
  }

  Future<void> _saveToPrefs() async {
    final encoded = jsonEncode(_courses.map((c) => c.toJson()).toList());
    await _prefs.setString('courses', encoded);
  }

  void addCourse(Course course) {
    _courses.add(course);
    _calculateGpa();
    _saveToPrefs();
    notifyListeners();
  }

  void removeCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      _calculateGpa();
      _saveToPrefs();
      notifyListeners();
    }
  }

  void updateCourse(int index, Course course) {
    if (index >= 0 && index < _courses.length) {
      _courses[index] = course;
      _calculateGpa();
      _saveToPrefs();
      notifyListeners();
    }
  }

  void clearAllCourses() {
    _courses.clear();
    _currentGpa = 0.0;
    _totalCredits = 0.0;
    _saveToPrefs();
    notifyListeners();
  }

  void _calculateGpa() {
    if (_courses.isEmpty) {
      _currentGpa = 0.0;
      _totalCredits = 0.0;
      return;
    }

    double totalPoints = 0.0;
    double totalCreds = 0.0;

    for (final course in _courses) {
      final gp = gradePoints[course.grade] ?? 0.0;
      totalPoints += gp * course.credits;
      totalCreds += course.credits;
    }

    _totalCredits = totalCreds;
    _currentGpa = totalCreds > 0 ? totalPoints / totalCreds : 0.0;
  }

  double simulateGpa(String courseName, double credits, String targetGrade) {
    final gp = gradePoints[targetGrade] ?? 0.0;

    double totalPoints = 0.0;
    double totalCreds = 0.0;

    for (final course in _courses) {
      final courseGp = gradePoints[course.grade] ?? 0.0;
      totalPoints += courseGp * course.credits;
      totalCreds += course.credits;
    }

    totalPoints += gp * credits;
    totalCreds += credits;

    return totalCreds > 0 ? totalPoints / totalCreds : 0.0;
  }

  String minimumGradeForTarget(double targetGpa, double newCredits) {
    double totalPoints = 0.0;
    double totalCreds = 0.0;

    for (final course in _courses) {
      final gp = gradePoints[course.grade] ?? 0.0;
      totalPoints += gp * course.credits;
      totalCreds += course.credits;
    }

    final neededPoints = targetGpa * (totalCreds + newCredits) - totalPoints;
    final neededGradePoint = neededPoints / newCredits;

    if (neededGradePoint <= 0.0) return 'FF';
    if (neededGradePoint <= 0.5) return 'FD';
    if (neededGradePoint <= 1.0) return 'DD';
    if (neededGradePoint <= 1.5) return 'DC';
    if (neededGradePoint <= 2.0) return 'CC';
    if (neededGradePoint <= 2.5) return 'CB';
    if (neededGradePoint <= 3.0) return 'BB';
    if (neededGradePoint <= 3.5) return 'BA';
    if (neededGradePoint <= 4.0) return 'AA';
    return 'Impossible';
  }
}
