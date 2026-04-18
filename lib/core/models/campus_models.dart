import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final String category; // 'event', 'announcement', 'exam', 'general'
  final DateTime date;
  final String? imageUrl;
  final bool isActive;
  final DateTime? createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.imageUrl,
    this.isActive = true,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'category': category,
        'date': Timestamp.fromDate(date),
        'imageUrl': imageUrl,
        'isActive': isActive,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'general',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class RingSchedule {
  final String id;
  final int period;
  final String startTime;
  final String endTime;

  RingSchedule({
    required this.id,
    required this.period,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toFirestore() => {
        'period': period,
        'startTime': startTime,
        'endTime': endTime,
      };

  factory RingSchedule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RingSchedule(
      id: doc.id,
      period: data['period'] ?? 0,
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }
}

class CafeteriaMenu {
  final String id;
  final DateTime date;
  final List<String> soup;
  final List<String> mainCourse;
  final List<String> sideDish;
  final List<String> extra;

  CafeteriaMenu({
    required this.id,
    required this.date,
    this.soup = const [],
    this.mainCourse = const [],
    this.sideDish = const [],
    this.extra = const [],
  });

  Map<String, dynamic> toFirestore() => {
        'date': Timestamp.fromDate(date),
        'soup': soup,
        'mainCourse': mainCourse,
        'sideDish': sideDish,
        'extra': extra,
      };

  factory CafeteriaMenu.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CafeteriaMenu(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      soup: List<String>.from(data['soup'] ?? []),
      mainCourse: List<String>.from(data['mainCourse'] ?? []),
      sideDish: List<String>.from(data['sideDish'] ?? []),
      extra: List<String>.from(data['extra'] ?? []),
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String targetId; // business/professor/course ID
  final String targetType; // 'business', 'professor', 'course'
  final double rating;
  final String comment;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'userName': userName,
        'targetId': targetId,
        'targetType': targetType,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonim',
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
