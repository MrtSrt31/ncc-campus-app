import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ParsedExam {
  String courseCode;
  String date; // DD.MM.YYYY
  String startTime;
  String endTime;
  String building;
  String room;
  String sections;

  ParsedExam({
    required this.courseCode,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.building = '',
    this.room = '',
    this.sections = '',
  });
}

class ExamParserService {
  /// Extract text from PDF and parse exam entries
  static List<ParsedExam> parseExamPdf(Uint8List pdfBytes) {
    final text = extractText(pdfBytes);
    return parseText(text);
  }

  /// Extract raw text from PDF bytes
  static String extractText(Uint8List pdfBytes) {
    final document = PdfDocument(inputBytes: pdfBytes);
    final extractor = PdfTextExtractor(document);
    final text = extractor.extractText();
    document.dispose();
    return text;
  }

  /// Parse exam text into structured data
  static List<ParsedExam> parseText(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // Try tabular format first (all info on one line)
    var results = _parseTabular(lines);
    if (results.isEmpty) {
      results = _parseGrouped(lines);
    }
    return results;
  }

  // ── Patterns ──────────────────────────────────────────

  // Course code: 2-5 uppercase letters + space + 3 digits + optional letter
  static final _coursePattern = RegExp(r'\b([A-Z]{2,5})\s+(\d{3}[A-Z]?)\b');

  // Date: DD.MM.YYYY or DD/MM/YYYY
  static final _dateDotPattern = RegExp(r'(\d{1,2})\.(\d{1,2})\.(\d{2,4})');
  static final _dateSlashPattern = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{2,4})');
  static final _dateWordPattern = RegExp(
    r'(\d{1,2})\s+(January|February|March|April|May|June|July|August|September|October|November|December|Ocak|Şubat|Mart|Nisan|Mayıs|Haziran|Temmuz|Ağustos|Eylül|Ekim|Kasım|Aralık)\s+(\d{4})',
    caseSensitive: false,
  );

  // Time range: HH:MM - HH:MM
  static final _timePattern =
      RegExp(r'(\d{1,2}[:.]\d{2})\s*[-–]\s*(\d{1,2}[:.]\d{2})');

  // Section
  static final _sectionPattern =
      RegExp(r'(?:Sec(?:tion)?\.?\s*[:\s]*|Böl(?:üm)?\.?\s*[:\s]*)([0-9,\s]+)', caseSensitive: false);

  // Known METU NCC building codes
  static const _buildingCodes = [
    'SZ', 'S', 'MM', 'BZ', 'KST', 'ENG', 'LIB', 'CC', 'GYM', 'LAB',
  ];

  // ── Tabular Parser ────────────────────────────────────

  static List<ParsedExam> _parseTabular(List<String> lines) {
    final results = <ParsedExam>[];

    for (final line in lines) {
      final courseMatch = _coursePattern.firstMatch(line);
      if (courseMatch == null) continue;

      final courseCode = '${courseMatch.group(1)} ${courseMatch.group(2)}';
      final dateStr = _extractDate(line);
      final timeMatch = _timePattern.firstMatch(line);

      if (dateStr == null || timeMatch == null) continue;

      final roomInfo = _extractRoom(line, courseMatch.end);
      final sectionMatch = _sectionPattern.firstMatch(line);

      results.add(ParsedExam(
        courseCode: courseCode,
        date: dateStr,
        startTime: timeMatch.group(1)!.replaceAll('.', ':'),
        endTime: timeMatch.group(2)!.replaceAll('.', ':'),
        building: roomInfo['building'] ?? '',
        room: roomInfo['room'] ?? '',
        sections: sectionMatch?.group(1)?.trim() ?? '',
      ));
    }

    return results;
  }

  // ── Grouped Parser ────────────────────────────────────

  static List<ParsedExam> _parseGrouped(List<String> lines) {
    final results = <ParsedExam>[];
    String? currentDate;
    String? currentStartTime;
    String? currentEndTime;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Check for date header line (no course code)
      final dateStr = _extractDate(line);
      if (dateStr != null && !_coursePattern.hasMatch(line)) {
        currentDate = dateStr;
      }

      // Check for time header line (no course code)
      final timeMatch = _timePattern.firstMatch(line);
      if (timeMatch != null && !_coursePattern.hasMatch(line)) {
        currentStartTime = timeMatch.group(1)!.replaceAll('.', ':');
        currentEndTime = timeMatch.group(2)!.replaceAll('.', ':');
      }

      // Check for course code
      final courseMatch = _coursePattern.firstMatch(line);
      if (courseMatch != null && currentDate != null) {
        final courseCode = '${courseMatch.group(1)} ${courseMatch.group(2)}';

        // Line might have its own date/time
        final lineDate = _extractDate(line);
        final lineTime = _timePattern.firstMatch(line);

        final examDate = lineDate ?? currentDate;
        final startTime =
            lineTime?.group(1)?.replaceAll('.', ':') ?? currentStartTime ?? '';
        final endTime =
            lineTime?.group(2)?.replaceAll('.', ':') ?? currentEndTime ?? '';

        final roomInfo = _extractRoom(line, courseMatch.end);
        final sectionMatch = _sectionPattern.firstMatch(line);

        if (startTime.isNotEmpty) {
          results.add(ParsedExam(
            courseCode: courseCode,
            date: examDate!,
            startTime: startTime,
            endTime: endTime,
            building: roomInfo['building'] ?? '',
            room: roomInfo['room'] ?? '',
            sections: sectionMatch?.group(1)?.trim() ?? '',
          ));
        }
      }
    }

    return results;
  }

  // ── Helpers ───────────────────────────────────────────

  static String? _extractDate(String text) {
    // DD.MM.YYYY
    var match = _dateDotPattern.firstMatch(text);
    if (match != null) {
      final day = match.group(1)!.padLeft(2, '0');
      final month = match.group(2)!.padLeft(2, '0');
      var year = match.group(3)!;
      if (year.length == 2) year = '20$year';
      return '$day.$month.$year';
    }

    // DD/MM/YYYY
    match = _dateSlashPattern.firstMatch(text);
    if (match != null) {
      final day = match.group(1)!.padLeft(2, '0');
      final month = match.group(2)!.padLeft(2, '0');
      var year = match.group(3)!;
      if (year.length == 2) year = '20$year';
      return '$day.$month.$year';
    }

    // "12 April 2026"
    final wordMatch = _dateWordPattern.firstMatch(text);
    if (wordMatch != null) {
      final day = wordMatch.group(1)!.padLeft(2, '0');
      final monthName = wordMatch.group(2)!;
      final year = wordMatch.group(3)!;
      final month = _monthNumber(monthName);
      if (month != null) {
        return '$day.${month.toString().padLeft(2, '0')}.$year';
      }
    }

    return null;
  }

  static Map<String, String> _extractRoom(String text, int afterIndex) {
    final afterText = afterIndex < text.length ? text.substring(afterIndex) : text;

    // Look for "BUILDING-ROOM" or "BUILDING ROOM" patterns
    // First try known building codes
    for (final code in _buildingCodes) {
      final pattern = RegExp('$code\\s*[-\\s]\\s*(\\d{1,4}[A-Z]?)', caseSensitive: false);
      final match = pattern.firstMatch(afterText);
      if (match != null) {
        return {'building': code, 'room': match.group(1)!};
      }
    }

    // Generic building-room pattern
    final genericMatch = RegExp(r'\b([A-Z]{1,4})\s*[-]\s*(\d{1,4}[A-Z]?)\b').firstMatch(afterText);
    if (genericMatch != null) {
      final b = genericMatch.group(1)!;
      // Skip if it matches a course code pattern
      if (b.length <= 3) {
        return {'building': b, 'room': genericMatch.group(2)!};
      }
    }

    return {};
  }

  static int? _monthNumber(String name) {
    const months = {
      'january': 1, 'february': 2, 'march': 3, 'april': 4,
      'may': 5, 'june': 6, 'july': 7, 'august': 8,
      'september': 9, 'october': 10, 'november': 11, 'december': 12,
      'ocak': 1, 'şubat': 2, 'mart': 3, 'nisan': 4,
      'mayıs': 5, 'haziran': 6, 'temmuz': 7, 'ağustos': 8,
      'eylül': 9, 'ekim': 10, 'kasım': 11, 'aralık': 12,
    };
    return months[name.toLowerCase()];
  }

  /// Parse date string (DD.MM.YYYY) to DateTime
  static DateTime? parseDateString(String dateStr) {
    final parts = dateStr.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }
}
