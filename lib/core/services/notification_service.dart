import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../models/exam_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // Default to Asia/Famagusta (North Cyprus)
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Famagusta'));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      } catch (_) {}
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  static Future<void> scheduleExamNotifications(List<Exam> exams) async {
    if (!_initialized) return;
    await cancelAllExamNotifications();
    await requestPermissions();

    final now = DateTime.now();
    int count = 0;

    for (final exam in exams) {
      if (count >= 40) break;

      // Day before at 20:00
      final dayBefore = DateTime(
        exam.date.year,
        exam.date.month,
        exam.date.day - 1,
        20,
        0,
      );
      if (dayBefore.isAfter(now)) {
        await _schedule(
          id: exam.hashCode,
          title: 'Yarın Sınav Var! 📚',
          body:
              '${exam.courseCode} ${exam.examType} - ${exam.startTime} | ${exam.locationString}',
          dateTime: dayBefore,
        );
        count++;
      }

      // Exam day at 08:00
      final examDay = DateTime(
        exam.date.year,
        exam.date.month,
        exam.date.day,
        8,
        0,
      );
      if (examDay.isAfter(now)) {
        await _schedule(
          id: exam.hashCode + 100000,
          title: 'Bugün Sınav Var! 🎯',
          body:
              '${exam.courseCode} ${exam.examType} - ${exam.startTime} | ${exam.locationString}',
          dateTime: examDay,
        );
        count++;
      }
    }
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    try {
      final tzDate = tz.TZDateTime.from(dateTime, tz.local);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'exam_notifications',
            'Sınav Bildirimleri',
            channelDescription: 'Sınav hatırlatma bildirimleri',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Notification schedule failed: $e');
    }
  }

  static Future<void> cancelAllExamNotifications() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }
}
