import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/social_models.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/ad_banner_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConfessionsScreen extends StatefulWidget {
  const ConfessionsScreen({super.key});

  @override
  State<ConfessionsScreen> createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends State<ConfessionsScreen> {
  final _controller = TextEditingController();
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  bool get _fbAvailable => Firebase.apps.isNotEmpty;

  Future<void> _postConfession() async {
    if (!_fbAvailable) return;
    final text = _controller.text.trim();
    final l = AppLocalizations.of(context);
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.confessionEmpty),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    try {
      await _db.collection('confessions').add(Confession(
            id: '',
            content: text,
          ).toFirestore());
      _controller.clear();
    } catch (_) {}
  }

  Future<void> _toggleLike(Confession confession) async {
    if (!_fbAvailable) return;
    final auth = context.read<AuthProvider>();
    final userId = auth.currentUser?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final liked = confession.likedBy.contains(userId);
    try {
      await _db.collection('confessions').doc(confession.id).update({
        'likes': FieldValue.increment(liked ? -1 : 1),
        'likedBy': liked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: Text(l.confessionsTitle)),
      body: Column(
        children: [
          const AdBannerWidget(),
          _buildInputArea(l),
          Expanded(child: _buildConfessionsList(l)),
        ],
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        border: Border(bottom: BorderSide(color: AppColors.div(context))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              maxLength: 500,
              style: TextStyle(color: AppColors.txt(context)),
              decoration: InputDecoration(
                hintText: l.writeConfession,
                counterText: '',
                filled: true,
                fillColor: AppColors.surf(context),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _postConfession,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfessionsList(AppLocalizations l) {
    if (!_fbAvailable) return _buildEmpty(l);
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('confessions')
          .where('isReported', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(l);
        }

        final confessions = snapshot.data!.docs
            .map((d) => Confession.fromFirestore(d))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: confessions.length,
          itemBuilder: (context, index) {
            final c = confessions[index];
            return _ConfessionCard(
              confession: c,
              onLike: () => _toggleLike(c),
              onReport: () => _reportConfession(c),
              l: l,
            );
          },
        );
      },
    );
  }

  Future<void> _reportConfession(Confession c) async {
    if (!_fbAvailable) return;
    try {
      await _db.collection('confessions').doc(c.id).update({
        'isReported': true,
      });
    } catch (_) {}
  }

  Widget _buildEmpty(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64,
              color: AppColors.txtHint(context).withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(l.noConfessions,
              style: TextStyle(color: AppColors.txtSec(context), fontSize: 16)),
          const SizedBox(height: 8),
          Text(l.confessionHint,
              style: TextStyle(color: AppColors.txtHint(context), fontSize: 14)),
        ],
      ),
    );
  }
}

class _ConfessionCard extends StatelessWidget {
  final Confession confession;
  final VoidCallback onLike;
  final VoidCallback onReport;
  final AppLocalizations l;

  const _ConfessionCard({
    required this.confession,
    required this.onLike,
    required this.onReport,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_off, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(l.anonymous,
                  style: TextStyle(
                    color: AppColors.txtSec(context),
                    fontWeight: FontWeight.w600,
                  )),
              const Spacer(),
              if (confession.createdAt != null)
                Text(
                  timeago.format(confession.createdAt!, locale: 'tr'),
                  style: TextStyle(color: AppColors.txtHint(context), fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            confession.content,
            style: TextStyle(color: AppColors.txt(context), fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 20, color: AppColors.error),
                    const SizedBox(width: 6),
                    Text(
                      '${confession.likes}',
                      style: TextStyle(color: AppColors.txtSec(context), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onReport,
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: AppColors.txtHint(context)),
                    const SizedBox(width: 4),
                    Text(l.report,
                        style: TextStyle(color: AppColors.txtHint(context), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
