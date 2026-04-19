import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

import '../models/campus_event_model.dart';

class ThisWeekService {
  static const String _url = 'https://ncc.metu.edu.tr/tr/kamp%C3%BCste-bu-hafta';

  Future<List<CampusEvent>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode != 200) {
        return _fallbackEvents;
      }

      final doc = html_parser.parse(response.body);
      final text = doc.body?.text ?? '';
      final lines = text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final events = <CampusEvent>[];
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final isDateLine = _looksLikeDate(line);
        if (!isDateLine) continue;

        final time = (i + 1 < lines.length) ? lines[i + 1] : '';
        final title = (i + 2 < lines.length) ? lines[i + 2] : 'Etkinlik';
        final location = (i + 3 < lines.length) ? lines[i + 3] : 'Kampüs';
        final organizer = (i + 4 < lines.length) ? lines[i + 4] : 'ODTÜ KKK';

        events.add(CampusEvent(
          date: line,
          time: time,
          title: title,
          location: location,
          organizer: organizer,
          color: _colorForIndex(events.length),
        ));
      }

      if (events.isEmpty) {
        return _fallbackEvents;
      }

      return events.take(12).toList();
    } catch (_) {
      return _fallbackEvents;
    }
  }

  bool _looksLikeDate(String value) {
    final lower = value.toLowerCase();
    if (RegExp(r'\d{1,2}[./-]\d{1,2}[./-]\d{2,4}').hasMatch(value)) {
      return true;
    }
    return lower.contains('pazartesi') ||
        lower.contains('salı') ||
        lower.contains('carsamba') ||
        lower.contains('çarşamba') ||
        lower.contains('persembe') ||
        lower.contains('perşembe') ||
        lower.contains('cuma') ||
        lower.contains('cumartesi') ||
        lower.contains('pazar') ||
        lower.contains('monday') ||
        lower.contains('tuesday') ||
        lower.contains('wednesday') ||
        lower.contains('thursday') ||
        lower.contains('friday') ||
        lower.contains('saturday') ||
        lower.contains('sunday');
  }

  Color _colorForIndex(int index) {
    const palette = [
      Color(0xFF6C63FF),
      Color(0xFF00D9FF),
      Color(0xFF00C853),
      Color(0xFFFFAB00),
      Color(0xFFFB7185),
      Color(0xFF14B8A6),
      Color(0xFFF97316),
    ];
    return palette[index % palette.length];
  }
}

const _fallbackEvents = [
  CampusEvent(
    date: 'Bu hafta',
    time: 'Duyuruları webden çekiyoruz',
    title: 'Canlı etkinlik akışı hazırlanıyor',
    location: 'ODTÜ KKK',
    organizer: 'NCC Campus',
    color: Color(0xFF6C63FF),
  ),
];
