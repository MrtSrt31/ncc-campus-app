import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/gpa_provider.dart';
import '../../widgets/ad_banner_widget.dart';

class GpaScreen extends StatefulWidget {
  const GpaScreen({super.key});

  @override
  State<GpaScreen> createState() => _GpaScreenState();
}

class _GpaScreenState extends State<GpaScreen> {
  void _showAddCourseDialog() {
    final nameController = TextEditingController();
    final creditsController = TextEditingController();
    String selectedGrade = 'AA';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ders Ekle',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Ders Adı'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: creditsController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Kredi (ör: 3)'),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGrade,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    items: GpaProvider.gradePoints.keys
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setModalState(() => selectedGrade = v!),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final credits = double.tryParse(creditsController.text.trim());
                    if (name.isEmpty || credits == null || credits <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tüm alanları doğru doldurun'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    context.read<GpaProvider>().addCourse(
                          Course(name: name, credits: credits, grade: selectedGrade),
                        );
                    Navigator.pop(ctx);
                  },
                  child: const Text('Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _gradeColor(String grade) {
    final gp = GpaProvider.gradePoints[grade] ?? 0.0;
    if (gp >= 3.5) return AppColors.success;
    if (gp >= 2.5) return AppColors.accent;
    if (gp >= 1.5) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('GPA Hesapla'),
        actions: [
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: 'Simülatör',
            onPressed: () => Navigator.pushNamed(context, '/gpa-simulator'),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            color: AppColors.surface,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Tümünü Sil', style: TextStyle(color: AppColors.error)),
              ),
            ],
            onSelected: (v) {
              if (v == 'clear') {
                context.read<GpaProvider>().clearAllCourses();
              }
            },
          ),
        ],
      ),
      body: Consumer<GpaProvider>(
        builder: (context, gpa, _) => Column(
          children: [
            const AdBannerWidget(),
            _buildGpaSummary(gpa),
            Expanded(
              child: gpa.courses.isEmpty
                  ? _buildEmptyState()
                  : _buildCourseList(gpa),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCourseDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ders Ekle', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildGpaSummary(GpaProvider gpa) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.accent.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Genel Ortalama',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  gpa.currentGpa.toStringAsFixed(2),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${gpa.courses.length} Ders',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${gpa.totalCredits.toStringAsFixed(0)} Kredi',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'Henüz ders eklenmedi',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Derslerini ekleyerek GPA\'nı hesapla',
            style: TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(GpaProvider gpa) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: gpa.courses.length,
      itemBuilder: (context, index) {
        final course = gpa.courses[index];
        return Dismissible(
          key: ValueKey('${course.name}_$index'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
          onDismissed: (_) => gpa.removeCourse(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _gradeColor(course.grade).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      course.grade,
                      style: TextStyle(
                        color: _gradeColor(course.grade),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course.credits.toStringAsFixed(0)} Kredi',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  (GpaProvider.gradePoints[course.grade] ?? 0.0).toStringAsFixed(1),
                  style: TextStyle(
                    color: _gradeColor(course.grade),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
