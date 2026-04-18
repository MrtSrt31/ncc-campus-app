import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/business_model.dart';
import '../models/user_model.dart';
import '../models/campus_models.dart';

import '../models/social_models.dart';

class FirestoreService {
  FirebaseFirestore? _dbInstance;

  bool get _isAvailable => Firebase.apps.isNotEmpty;

  FirebaseFirestore get _db {
    _dbInstance ??= FirebaseFirestore.instance;
    return _dbInstance!;
  }

  // ── Users ──────────────────────────────────────────────
  Future<void> createUser(AppUser user) async {
    if (!_isAvailable) return;
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    if (!_isAvailable) return null;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    if (!_isAvailable) return;
    await _db.collection('users').doc(uid).update(data);
  }

  Stream<List<AppUser>> streamAllUsers() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => AppUser.fromFirestore(d)).toList());
  }

  // ── Businesses ─────────────────────────────────────────
  Future<String> addBusiness(Business business) async {
    if (!_isAvailable) return '';
    final doc = await _db.collection('businesses').add(business.toFirestore());
    return doc.id;
  }

  Future<void> updateBusiness(String id, Map<String, dynamic> data) async {
    if (!_isAvailable) return;
    await _db.collection('businesses').doc(id).update(data);
  }

  Future<void> deleteBusiness(String id) async {
    if (!_isAvailable) return;
    await _db.collection('businesses').doc(id).delete();
  }

  Stream<List<Business>> streamBusinesses() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('businesses')
        .orderBy('name')
        .snapshots()
        .map((s) => s.docs.map((d) => Business.fromFirestore(d)).toList());
  }

  // ── Announcements ──────────────────────────────────────
  Future<String> addAnnouncement(Announcement a) async {
    if (!_isAvailable) return '';
    final doc = await _db.collection('announcements').add(a.toFirestore());
    return doc.id;
  }

  Future<void> updateAnnouncement(String id, Map<String, dynamic> data) async {
    if (!_isAvailable) return;
    await _db.collection('announcements').doc(id).update(data);
  }

  Future<void> deleteAnnouncement(String id) async {
    if (!_isAvailable) return;
    await _db.collection('announcements').doc(id).delete();
  }

  Stream<List<Announcement>> streamAnnouncements({bool activeOnly = false}) {
    if (!_isAvailable) return Stream.value([]);
    Query<Map<String, dynamic>> query = _db
        .collection('announcements')
        .orderBy('date', descending: true);
    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }
    return query.snapshots().map(
        (s) => s.docs.map((d) => Announcement.fromFirestore(d)).toList());
  }

  // ── Ring Schedule ──────────────────────────────────────
  Future<void> setRingSchedule(RingSchedule rs) async {
    if (!_isAvailable) return;
    await _db
        .collection('ringSchedule')
        .doc(rs.id)
        .set(rs.toFirestore());
  }

  Future<void> deleteRingSchedule(String id) async {
    if (!_isAvailable) return;
    await _db.collection('ringSchedule').doc(id).delete();
  }

  Stream<List<RingSchedule>> streamRingSchedule() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('ringSchedule')
        .orderBy('period')
        .snapshots()
        .map((s) => s.docs.map((d) => RingSchedule.fromFirestore(d)).toList());
  }

  // ── Cafeteria Menu ─────────────────────────────────────
  Future<void> setCafeteriaMenu(CafeteriaMenu menu) async {
    if (!_isAvailable) return;
    await _db.collection('cafeteriaMenu').doc(menu.id).set(menu.toFirestore());
  }

  Future<void> deleteCafeteriaMenu(String id) async {
    if (!_isAvailable) return;
    await _db.collection('cafeteriaMenu').doc(id).delete();
  }

  Stream<List<CafeteriaMenu>> streamCafeteriaMenu() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('cafeteriaMenu')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
            (s) => s.docs.map((d) => CafeteriaMenu.fromFirestore(d)).toList());
  }

  Future<CafeteriaMenu?> getTodayMenu() async {
    if (!_isAvailable) return null;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snap = await _db
        .collection('cafeteriaMenu')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return CafeteriaMenu.fromFirestore(snap.docs.first);
  }

  // ── Reviews ────────────────────────────────────────────
  Future<String> addReview(Review review) async {
    if (!_isAvailable) return '';
    final doc = await _db.collection('reviews').add(review.toFirestore());
    return doc.id;
  }

  Future<void> deleteReview(String id) async {
    if (!_isAvailable) return;
    await _db.collection('reviews').doc(id).delete();
  }

  Stream<List<Review>> streamReviews(String targetId) {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('reviews')
        .where('targetId', isEqualTo: targetId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Review.fromFirestore(d)).toList());
  }

  Stream<List<Review>> streamAllReviews() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Review.fromFirestore(d)).toList());
  }

  // ── Stats (Admin) ──────────────────────────────────────
  Future<Map<String, int>> getStats() async {
    if (!_isAvailable) return {'users': 0, 'businesses': 0, 'reviews': 0, 'announcements': 0, 'confessions': 0, 'marketplace': 0, 'carpool': 0};
    final users = await _db.collection('users').count().get();
    final businesses = await _db.collection('businesses').count().get();
    final reviews = await _db.collection('reviews').count().get();
    final announcements = await _db.collection('announcements').count().get();
    final confessions = await _db.collection('confessions').count().get();
    final marketplace = await _db.collection('marketplace').count().get();
    final carpool = await _db.collection('carpool').count().get();

    return {
      'users': users.count ?? 0,
      'businesses': businesses.count ?? 0,
      'reviews': reviews.count ?? 0,
      'announcements': announcements.count ?? 0,
      'confessions': confessions.count ?? 0,
      'marketplace': marketplace.count ?? 0,
      'carpool': carpool.count ?? 0,
    };
  }

  // ── Confessions ────────────────────────────────────────
  Stream<List<Confession>> streamConfessions() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('confessions')
        .where('isReported', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Confession.fromFirestore(d)).toList());
  }

  Future<void> deleteConfession(String id) async {
    if (!_isAvailable) return;
    await _db.collection('confessions').doc(id).delete();
  }

  // ── Marketplace ────────────────────────────────────────
  Stream<List<MarketplaceListing>> streamMarketplace() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('marketplace')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => MarketplaceListing.fromFirestore(d)).toList());
  }

  Future<void> deleteMarketplaceListing(String id) async {
    if (!_isAvailable) return;
    await _db.collection('marketplace').doc(id).delete();
  }

  // ── Carpool ────────────────────────────────────────────
  Stream<List<CarpoolRide>> streamCarpool() {
    if (!_isAvailable) return Stream.value([]);
    return _db
        .collection('carpool')
        .orderBy('dateTime')
        .snapshots()
        .map((s) => s.docs.map((d) => CarpoolRide.fromFirestore(d)).toList());
  }

  Future<void> deleteCarpoolRide(String id) async {
    if (!_isAvailable) return;
    await _db.collection('carpool').doc(id).delete();
  }
}
