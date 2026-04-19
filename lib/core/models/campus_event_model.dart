import 'package:flutter/material.dart';

class CampusEvent {
  final String date;
  final String time;
  final String title;
  final String location;
  final String organizer;
  final Color color;

  const CampusEvent({
    required this.date,
    required this.time,
    required this.title,
    required this.location,
    required this.organizer,
    required this.color,
  });
}
