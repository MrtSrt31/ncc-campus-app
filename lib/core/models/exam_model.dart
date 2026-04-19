import 'package:cloud_firestore/cloud_firestore.dart';

class ExamScheduleFile {
  final String id;
  final String fileName;
  final String downloadUrl;
  final String semester;
  final String examType; // MT1, MT2, Final, Quiz1, Quiz2, Make-up
  final DateTime uploadedAt;
  final bool isActive;
  final int examCount;

  ExamScheduleFile({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
    required this.semester,
    required this.examType,
    required this.uploadedAt,
    this.isActive = true,
    this.examCount = 0,
  });

  Map<String, dynamic> toFirestore() => {
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'semester': semester,
        'examType': examType,
        'uploadedAt': Timestamp.fromDate(uploadedAt),
        'isActive': isActive,
        'examCount': examCount,
      };

  factory ExamScheduleFile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExamScheduleFile(
      id: doc.id,
      fileName: data['fileName'] ?? '',
      downloadUrl: data['downloadUrl'] ?? '',
      semester: data['semester'] ?? '',
      examType: data['examType'] ?? 'MT1',
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      examCount: data['examCount'] ?? 0,
    );
  }
}

class Exam {
  final String id;
  final String scheduleId;
  final String courseCode;
  final String courseName;
  final String examType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String building;
  final String room;
  final String? sections;

  Exam({
    required this.id,
    required this.scheduleId,
    required this.courseCode,
    this.courseName = '',
    required this.examType,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.building = '',
    this.room = '',
    this.sections,
  });

  DateTime get startDateTime {
    final parts = startTime.split(':');
    if (parts.length == 2) {
      return DateTime(date.year, date.month, date.day,
          int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
    }
    return date;
  }

  DateTime get endDateTime {
    final parts = endTime.split(':');
    if (parts.length == 2) {
      return DateTime(date.year, date.month, date.day,
          int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
    }
    return date.add(const Duration(hours: 2));
  }

  String get locationString {
    if (building.isNotEmpty && room.isNotEmpty) return '$building-$room';
    if (building.isNotEmpty) return building;
    if (room.isNotEmpty) return room;
    return '';
  }

  Map<String, dynamic> toFirestore() => {
        'scheduleId': scheduleId,
        'courseCode': courseCode,
        'courseName': courseName,
        'examType': examType,
        'date': Timestamp.fromDate(date),
        'startTime': startTime,
        'endTime': endTime,
        'building': building,
        'room': room,
        'sections': sections,
      };

  factory Exam.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exam(
      id: doc.id,
      scheduleId: data['scheduleId'] ?? '',
      courseCode: data['courseCode'] ?? '',
      courseName: data['courseName'] ?? '',
      examType: data['examType'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      building: data['building'] ?? '',
      room: data['room'] ?? '',
      sections: data['sections'],
    );
  }
}
