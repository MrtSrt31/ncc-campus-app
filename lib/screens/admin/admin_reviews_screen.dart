import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Yorum Yönetimi')),
      body: StreamBuilder<List<Review>>(
        stream: firestore.streamAllReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return const Center(
              child: Text('Henüz yorum yok', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            color: AppColors.warning,
                            size: 16,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${review.targetType} • ${review.targetId}',
                      style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              title: const Text('Yorumu Sil', style: TextStyle(color: AppColors.textPrimary)),
                              content: const Text('Bu yorumu silmek istediğine emin misin?',
                                style: TextStyle(color: AppColors.textSecondary)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    firestore.deleteReview(review.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Sil', style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
