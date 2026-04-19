import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/services/firestore_service.dart';

class ReviewsScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  final String targetName;

  const ReviewsScreen({
    super.key,
    required this.targetId,
    required this.targetType,
    required this.targetName,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _firestore = FirestoreService();

  void _showAddReviewDialog() {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yorum yapmak için giriş yapmalısın'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final commentC = TextEditingController();
    double rating = 3.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfLight(context), borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.targetName} için yorum',
                style: TextStyle(color: AppColors.txt(context), fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 36,
                  unratedColor: AppColors.surfLight(context),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: AppColors.warning),
                  onRatingUpdate: (r) => setModalState(() => rating = r),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentC,
                maxLines: 4,
                style: TextStyle(color: AppColors.txt(context)),
                decoration: const InputDecoration(hintText: 'Yorumun... (anonim olarak paylaşılır)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (commentC.text.trim().isEmpty) return;
                    final review = Review(
                      id: '',
                      userId: auth.currentUser?.uid ?? '',
                      userName: 'Anonim',
                      targetId: widget.targetId,
                      targetType: widget.targetType,
                      rating: rating,
                      comment: commentC.text.trim(),
                    );
                    await _firestore.addReview(review);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Yorum Yap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: Text('${widget.targetName} Yorumları')),
      body: StreamBuilder<List<Review>>(
        stream: _firestore.streamReviews(widget.targetId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rate_review, size: 64, color: AppColors.txtHint(context).withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Henüz yorum yok', style: TextStyle(color: AppColors.txtSec(context), fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('İlk yorumu sen yaz!', style: TextStyle(color: AppColors.txtHint(context), fontSize: 14)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: AppColors.primary, size: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Anonim', style: TextStyle(
                          color: AppColors.txt(context), fontSize: 14, fontWeight: FontWeight.w600,
                        )),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < review.rating.round() ? Icons.star : Icons.star_border,
                            color: AppColors.warning, size: 16,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      review.comment,
                      style: TextStyle(color: AppColors.txtSec(context), fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReviewDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Yorum Yaz', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
