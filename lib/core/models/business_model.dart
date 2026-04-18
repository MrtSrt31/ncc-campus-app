import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String id;
  final String name;
  final String category;
  final String phone;
  final String description;
  final List<String> photos;
  final List<MenuItem> menu;
  final String openHours;
  final bool isOpen;
  final double rating;
  final int reviewCount;
  final DateTime? createdAt;

  Business({
    required this.id,
    required this.name,
    required this.category,
    this.phone = '',
    this.description = '',
    this.photos = const [],
    this.menu = const [],
    this.openHours = '',
    this.isOpen = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'category': category,
        'phone': phone,
        'description': description,
        'photos': photos,
        'menu': menu.map((m) => m.toFirestore()).toList(),
        'openHours': openHours,
        'isOpen': isOpen,
        'rating': rating,
        'reviewCount': reviewCount,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };

  factory Business.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Business(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      menu: (data['menu'] as List<dynamic>?)
              ?.map((m) => MenuItem.fromFirestore(m))
              .toList() ??
          [],
      openHours: data['openHours'] ?? '',
      isOpen: data['isOpen'] ?? true,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Business copyWith({
    String? id,
    String? name,
    String? category,
    String? phone,
    String? description,
    List<String>? photos,
    List<MenuItem>? menu,
    String? openHours,
    bool? isOpen,
    double? rating,
    int? reviewCount,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      menu: menu ?? this.menu,
      openHours: openHours ?? this.openHours,
      isOpen: isOpen ?? this.isOpen,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt,
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final String? description;

  MenuItem({required this.name, required this.price, this.description});

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'price': price,
        'description': description,
      };

  factory MenuItem.fromFirestore(Map<String, dynamic> data) => MenuItem(
        name: data['name'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        description: data['description'],
      );
}
