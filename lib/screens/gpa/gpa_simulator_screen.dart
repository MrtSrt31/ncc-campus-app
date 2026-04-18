import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/gpa_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../widgets/ad_banner_widget.dart';

class GpaSimulatorScreen extends StatefulWidget {
  const GpaSimulatorScreen({super.key});

  @override
  State<GpaSimulatorScreen> createState() => _GpaSimulatorScreenState();
}

class _GpaSimulatorScreenState extends State<GpaSimulatorScreen> {
  final _courseNameController = TextEditingController();
  final _creditsController = TextEditingController();
  final _targetGpaController = TextEditingController();
  String _selectedGrade = 'BB';
  double? _simulatedGpa;
  String? _minimumGrade;

  @override
  void dispose() {
    _courseNameController.dispose();
    _creditsController.dispose();
    _targetGpaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpa = context.watch<GpaProvider>();
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.gpaSimulator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdBannerWidget(),
            const SizedBox(height: 8),
            _buildCurrentGpaCard(gpa),
            const SizedBox(height: 28),
            Text(
              l.ifIGetGrade,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _courseNameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: l.courseName),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _creditsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: l.credit),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGrade,
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  items: GpaProvider.gradePoints.keys
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGrade = v!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final credits = double.tryParse(_creditsController.text.trim());
                  if (credits == null || credits <= 0) return;
                  setState(() {
                    _simulatedGpa = gpa.simulateGpa(
                      _courseNameController.text.trim(),
                      credits,
                      _selectedGrade,
                    );
                  });
                },
                child: Text(l.calculate),
              ),
            ),
            if (_simulatedGpa != null) ...[
              const SizedBox(height: 20),
              _buildResultCard(
                l.estimatedGpa,
                _simulatedGpa!.toStringAsFixed(2),
                AppColors.accent,
              ),
            ],
            const SizedBox(height: 40),
            Text(
              l.targetGpaQuestion,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetGpaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(hintText: l.targetGpaHint),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final targetGpa = double.tryParse(_targetGpaController.text.trim());
                  final credits = double.tryParse(_creditsController.text.trim());
                  if (targetGpa == null || credits == null || credits <= 0) return;
                  setState(() {
                    _minimumGrade = gpa.minimumGradeForTarget(targetGpa, credits);
                  });
                },
                icon: const Icon(Icons.gps_fixed, color: Colors.white),
                label: Text(l.calculate),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              ),
            ),
            if (_minimumGrade != null) ...[
              const SizedBox(height: 20),
              _buildResultCard(
                l.minimumGrade,
                _minimumGrade!,
                _minimumGrade == 'Impossible' ? AppColors.error : AppColors.success,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentGpaCard(GpaProvider gpa) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.school_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.currentGpa,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Text(
                gpa.currentGpa.toStringAsFixed(2),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            l.coursesCredits(gpa.courses.length, gpa.totalCredits.toStringAsFixed(0)),
            style: const TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
