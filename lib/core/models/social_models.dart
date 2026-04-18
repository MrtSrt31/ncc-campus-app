import 'package:cloud_firestore/cloud_firestore.dart';

class Confession {
  final String id;
  final String content;
  final int likes;
  final List<String> likedBy;
  final bool isReported;
  final DateTime? createdAt;

  Confession({
    required this.id,
    required this.content,
    this.likes = 0,
    this.likedBy = const [],
    this.isReported = false,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'content': content,
        'likes': likes,
        'likedBy': likedBy,
        'isReported': isReported,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory Confession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Confession(
      id: doc.id,
      content: data['content'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      isReported: data['isReported'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class MarketplaceListing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String userId;
  final String userName;
  final String contactInfo;
  final List<String> imageUrls;
  final bool isSold;
  final DateTime? createdAt;

  MarketplaceListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.userId,
    required this.userName,
    this.contactInfo = '',
    this.imageUrls = const [],
    this.isSold = false,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'userId': userId,
        'userName': userName,
        'contactInfo': contactInfo,
        'imageUrls': imageUrls,
        'isSold': isSold,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory MarketplaceListing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MarketplaceListing(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'other',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      contactInfo: data['contactInfo'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isSold: data['isSold'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class CarpoolRide {
  final String id;
  final String userId;
  final String userName;
  final String fromLocation;
  final String toLocation;
  final DateTime dateTime;
  final int totalSeats;
  final List<String> passengers;
  final String note;
  final String contactInfo;
  final DateTime? createdAt;

  CarpoolRide({
    required this.id,
    required this.userId,
    required this.userName,
    required this.fromLocation,
    required this.toLocation,
    required this.dateTime,
    required this.totalSeats,
    this.passengers = const [],
    this.note = '',
    this.contactInfo = '',
    this.createdAt,
  });

  int get availableSeats => totalSeats - passengers.length;
  bool get isFull => availableSeats <= 0;

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'userName': userName,
        'fromLocation': fromLocation,
        'toLocation': toLocation,
        'dateTime': Timestamp.fromDate(dateTime),
        'totalSeats': totalSeats,
        'passengers': passengers,
        'note': note,
        'contactInfo': contactInfo,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory CarpoolRide.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarpoolRide(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      fromLocation: data['fromLocation'] ?? '',
      toLocation: data['toLocation'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      totalSeats: data['totalSeats'] ?? 1,
      passengers: List<String>.from(data['passengers'] ?? []),
      note: data['note'] ?? '',
      contactInfo: data['contactInfo'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class CampusEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final String organizer;
  final DateTime dateTime;
  final DateTime? createdAt;

  CampusEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.organizer,
    required this.dateTime,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'location': location,
        'organizer': organizer,
        'dateTime': Timestamp.fromDate(dateTime),
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  factory CampusEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CampusEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      organizer: data['organizer'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
