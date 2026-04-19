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
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: const Text('Yorum Yönetimi')),
      body: StreamBuilder<List<Review>>(
        stream: firestore.streamAllReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return Center(
              child: Text('Henüz yorum yok', style: TextStyle(color: AppColors.txtSec(context))),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: TextStyle(
                            color: AppColors.txt(context), fontSize: 14, fontWeight: FontWeight.w600,
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
                      style: TextStyle(color: AppColors.txtHint(context), fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: TextStyle(color: AppColors.txtSec(context), fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.surf(context),
                              title: Text('Yorumu Sil', style: TextStyle(color: AppColors.txt(context))),
                              content: Text('Bu yorumu silmek istediğine emin misin?',
                                style: TextStyle(color: AppColors.txtSec(context))),
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
