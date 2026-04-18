import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/social_models.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/ad_banner_widget.dart';

class CarpoolScreen extends StatefulWidget {
  const CarpoolScreen({super.key});

  @override
  State<CarpoolScreen> createState() => _CarpoolScreenState();
}

class _CarpoolScreenState extends State<CarpoolScreen> {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  bool get _fbAvailable => Firebase.apps.isNotEmpty;

  void _showAddRideDialog() {
    final auth = context.read<AuthProvider>();
    final l = AppLocalizations.of(context);
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginRequired), backgroundColor: AppColors.error),
      );
      return;
    }

    final fromC = TextEditingController();
    final toC = TextEditingController();
    final noteC = TextEditingController();
    final contactC = TextEditingController();
    int seats = 3;
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Text(l.addRide, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                TextField(
                  controller: fromC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l.from,
                    prefixIcon: const Icon(Icons.my_location, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: toC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l.to,
                    prefixIcon: const Icon(Icons.location_on, color: AppColors.error),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date != null) setModalState(() => selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.surfaceLight),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(DateFormat('dd.MM.yyyy').format(selectedDate),
                                  style: const TextStyle(color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) setModalState(() => selectedTime = time);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.surfaceLight),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(selectedTime.format(context),
                                  style: const TextStyle(color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${l.seats}: ', style: const TextStyle(color: AppColors.textSecondary)),
                    IconButton(
                      onPressed: () {
                        if (seats > 1) setModalState(() => seats--);
                      },
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
                    ),
                    Text('$seats', style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                    IconButton(
                      onPressed: () {
                        if (seats < 7) setModalState(() => seats++);
                      },
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: l.contact),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: l.note),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (fromC.text.trim().isEmpty || toC.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.fillAllFields), backgroundColor: AppColors.error),
                        );
                        return;
                      }
                      final dateTime = DateTime(
                        selectedDate.year, selectedDate.month, selectedDate.day,
                        selectedTime.hour, selectedTime.minute,
                      );
                      await _db.collection('carpool').add(CarpoolRide(
                        id: '',
                        userId: auth.currentUser?.uid ?? '',
                        userName: auth.displayName ?? '',
                        fromLocation: fromC.text.trim(),
                        toLocation: toC.text.trim(),
                        dateTime: dateTime,
                        totalSeats: seats,
                        note: noteC.text.trim(),
                        contactInfo: contactC.text.trim(),
                      ).toFirestore());
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(l.addRide),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _joinRide(CarpoolRide ride) async {
    if (!_fbAvailable) return;
    final auth = context.read<AuthProvider>();
    final l = AppLocalizations.of(context);
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginRequired), backgroundColor: AppColors.error),
      );
      return;
    }
    final uid = auth.currentUser?.uid ?? '';
    if (ride.passengers.contains(uid)) return;
    try {
      await _db.collection('carpool').doc(ride.id).update({
        'passengers': FieldValue.arrayUnion([uid]),
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.carpoolTitle)),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(child: _buildRidesList(l)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRideDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l.addRide, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildRidesList(AppLocalizations l) {
    if (!_fbAvailable) return _buildEmpty(l);
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('carpool')
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .orderBy('dateTime')
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(l);
        }

        final rides = snapshot.data!.docs
            .map((d) => CarpoolRide.fromFirestore(d))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: rides.length,
          itemBuilder: (context, index) => _RideCard(
            ride: rides[index],
            onJoin: () => _joinRide(rides[index]),
            l: l,
          ),
        );
      },
    );
  }

  Widget _buildEmpty(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_outlined, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(l.noRides, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          Text(l.rideHint, style: const TextStyle(color: AppColors.textHint, fontSize: 14)),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final CarpoolRide ride;
  final VoidCallback onJoin;
  final AppLocalizations l;

  const _RideCard({required this.ride, required this.onJoin, required this.l});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy').format(ride.dateTime);
    final timeStr = DateFormat('HH:mm').format(ride.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.userName,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    Text('$dateStr  •  $timeStr',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ride.isFull
                      ? AppColors.error.withValues(alpha: 0.15)
                      : AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${ride.availableSeats}/${ride.totalSeats}',
                  style: TextStyle(
                    color: ride.isFull ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.my_location, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(ride.fromLocation,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Column(
              children: List.generate(3, (_) => Container(
                width: 2, height: 4,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: AppColors.textHint,
              )),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(ride.toLocation,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
              ),
            ],
          ),
          if (ride.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(ride.note,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (ride.contactInfo.isNotEmpty) ...[
                const Icon(Icons.phone, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text(ride.contactInfo,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
              const Spacer(),
              if (!ride.isFull)
                ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: const Icon(Icons.person_add, size: 18),
                  label: Text(l.join),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(l.full,
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
