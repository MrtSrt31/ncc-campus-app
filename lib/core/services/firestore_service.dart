import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business_model.dart';
import '../models/user_model.dart';
import '../models/campus_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────
  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Stream<List<AppUser>> streamAllUsers() {
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => AppUser.fromFirestore(d)).toList());
  }

  // ── Businesses ─────────────────────────────────────────
  Future<String> addBusiness(Business business) async {
    final doc = await _db.collection('businesses').add(business.toFirestore());
    return doc.id;
  }

  Future<void> updateBusiness(String id, Map<String, dynamic> data) async {
    await _db.collection('businesses').doc(id).update(data);
  }

  Future<void> deleteBusiness(String id) async {
    await _db.collection('businesses').doc(id).delete();
  }

  Stream<List<Business>> streamBusinesses() {
    return _db
        .collection('businesses')
        .orderBy('name')
        .snapshots()
        .map((s) => s.docs.map((d) => Business.fromFirestore(d)).toList());
  }

  // ── Announcements ──────────────────────────────────────
  Future<String> addAnnouncement(Announcement a) async {
    final doc = await _db.collection('announcements').add(a.toFirestore());
    return doc.id;
  }

  Future<void> updateAnnouncement(String id, Map<String, dynamic> data) async {
    await _db.collection('announcements').doc(id).update(data);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _db.collection('announcements').doc(id).delete();
  }

  Stream<List<Announcement>> streamAnnouncements({bool activeOnly = false}) {
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
    await _db
        .collection('ringSchedule')
        .doc(rs.id)
        .set(rs.toFirestore());
  }

  Future<void> deleteRingSchedule(String id) async {
    await _db.collection('ringSchedule').doc(id).delete();
  }

  Stream<List<RingSchedule>> streamRingSchedule() {
    return _db
        .collection('ringSchedule')
        .orderBy('period')
        .snapshots()
        .map((s) => s.docs.map((d) => RingSchedule.fromFirestore(d)).toList());
  }

  // ── Cafeteria Menu ─────────────────────────────────────
  Future<void> setCafeteriaMenu(CafeteriaMenu menu) async {
    await _db.collection('cafeteriaMenu').doc(menu.id).set(menu.toFirestore());
  }

  Future<void> deleteCafeteriaMenu(String id) async {
    await _db.collection('cafeteriaMenu').doc(id).delete();
  }

  Stream<List<CafeteriaMenu>> streamCafeteriaMenu() {
    return _db
        .collection('cafeteriaMenu')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
            (s) => s.docs.map((d) => CafeteriaMenu.fromFirestore(d)).toList());
  }

  Future<CafeteriaMenu?> getTodayMenu() async {
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
    final doc = await _db.collection('reviews').add(review.toFirestore());
    return doc.id;
  }

  Future<void> deleteReview(String id) async {
    await _db.collection('reviews').doc(id).delete();
  }

  Stream<List<Review>> streamReviews(String targetId) {
    return _db
        .collection('reviews')
        .where('targetId', isEqualTo: targetId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Review.fromFirestore(d)).toList());
  }

  Stream<List<Review>> streamAllReviews() {
    return _db
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Review.fromFirestore(d)).toList());
  }

  // ── Stats (Admin) ──────────────────────────────────────
  Future<Map<String, int>> getStats() async {
    final users = await _db.collection('users').count().get();
    final businesses = await _db.collection('businesses').count().get();
    final reviews = await _db.collection('reviews').count().get();
    final announcements = await _db.collection('announcements').count().get();

    return {
      'users': users.count ?? 0,
      'businesses': businesses.count ?? 0,
      'reviews': reviews.count ?? 0,
      'announcements': announcements.count ?? 0,
    };
  }
}
