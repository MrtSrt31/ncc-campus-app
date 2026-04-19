import 'package:flutter/material.dart';

import '../models/campus_event_model.dart';
import '../services/this_week_service.dart';

class ThisWeekProvider extends ChangeNotifier {
  final ThisWeekService _service = ThisWeekService();

  List<CampusEvent> _events = [];
  bool _loading = false;
  String? _error;

  List<CampusEvent> get events => _events;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadEvents() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.fetchEvents();
    } catch (_) {
      _error = 'Etkinlikler yüklenemedi';
      _events = [];
    }

    _loading = false;
    notifyListeners();
  }
}
