import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/gpa_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/data/department_data.dart';
import '../../widgets/ad_banner_widget.dart';

class GpaScreen extends StatefulWidget {
  const GpaScreen({super.key});

  @override
  State<GpaScreen> createState() => _GpaScreenState();
}

class _GpaScreenState extends State<GpaScreen> {
  void _showAddCourseDialog() {
    final l = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final creditsController = TextEditingController();
    String selectedGrade = 'AA';
    Department? selectedDept;
    DepartmentCourse? selectedCourse;
    bool manualMode = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfLight(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l.addCourse,
                  style: TextStyle(
                    color: AppColors.txt(context),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                // Department selector
                if (!manualMode) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.surf(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfLight(context)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Department>(
                        value: selectedDept,
                        isExpanded: true,
                        hint: Text(l.selectDepartment, style: TextStyle(color: AppColors.txtHint(context))),
                        dropdownColor: AppColors.surf(context),
                        style: TextStyle(color: AppColors.txt(context), fontSize: 14),
                        items: DepartmentData.departments.map((d) =>
                          DropdownMenuItem(
                            value: d,
                            child: Text(l.isTr ? d.name : d.nameEn, overflow: TextOverflow.ellipsis),
                          )).toList(),
                        onChanged: (v) => setModalState(() {
                          selectedDept = v;
                          selectedCourse = null;
                        }),
                      ),
                    ),
                  ),
                  if (selectedDept != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surf(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.surfLight(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DepartmentCourse>(
                          value: selectedCourse,
                          isExpanded: true,
                          hint: Text(l.selectCourse, style: TextStyle(color: AppColors.txtHint(context))),
                          dropdownColor: AppColors.surf(context),
                          style: TextStyle(color: AppColors.txt(context), fontSize: 14),
                          items: selectedDept!.courses.map((c) =>
                            DropdownMenuItem(
                              value: c,
                              child: Text('${c.code} - ${c.name} (${c.credits.toStringAsFixed(0)} kr)',
                                overflow: TextOverflow.ellipsis),
                            )).toList(),
                          onChanged: (v) => setModalState(() {
                            selectedCourse = v;
                            if (v != null) {
                              nameController.text = '${v.code} ${v.name}';
                              creditsController.text = v.credits.toStringAsFixed(0);
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => setModalState(() => manualMode = true),
                      child: Text(l.orManual, style: const TextStyle(color: AppColors.accent)),
                    ),
                  ),
                ] else ...[
                  Center(
                    child: TextButton(
                      onPressed: () => setModalState(() => manualMode = false),
                      child: Text(l.selectDepartment, style: const TextStyle(color: AppColors.accent)),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  style: TextStyle(color: AppColors.txt(context)),
                  decoration: InputDecoration(hintText: l.courseName),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: creditsController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: AppColors.txt(context)),
                  decoration: InputDecoration(hintText: l.creditHint),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surf(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfLight(context)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedGrade,
                      isExpanded: true,
                      dropdownColor: AppColors.surf(context),
                      style: TextStyle(color: AppColors.txt(context), fontSize: 16),
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
                          SnackBar(
                            content: Text(l.fillAllFields),
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
                    child: Text(l.add),
                  ),
                ),
              ],
            ),
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        title: Text(l.gpaTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: l.simulator,
            onPressed: () => Navigator.pushNamed(context, '/gpa-simulator'),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            color: AppColors.surf(context),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'clear',
                child: Text(l.deleteAll, style: const TextStyle(color: AppColors.error)),
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
            _buildGpaSummary(gpa, l),
            Expanded(
              child: gpa.courses.isEmpty
                  ? _buildEmptyState(l)
                  : _buildCourseList(gpa, l),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCourseDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l.addCourse, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildGpaSummary(GpaProvider gpa, AppLocalizations l) {
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
                Text(
                  l.overallGpa,
                  style: TextStyle(color: AppColors.txtSec(context), fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  gpa.currentGpa.toStringAsFixed(2),
                  style: TextStyle(
                    color: AppColors.txt(context),
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
                '${gpa.courses.length} ${l.courses}',
                style: TextStyle(color: AppColors.txtSec(context), fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${gpa.totalCredits.toStringAsFixed(0)} ${l.credit}',
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

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined, size: 64, color: AppColors.txtHint(context).withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            l.noCourses,
            style: TextStyle(color: AppColors.txtSec(context), fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            l.addCoursesHint,
            style: TextStyle(color: AppColors.txtHint(context), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(GpaProvider gpa, AppLocalizations l) {
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
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
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
                        style: TextStyle(
                          color: AppColors.txt(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course.credits.toStringAsFixed(0)} ${l.credit}',
                        style: TextStyle(color: AppColors.txtSec(context), fontSize: 13),
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
