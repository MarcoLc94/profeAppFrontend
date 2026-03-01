import 'package:flutter/material.dart';
import 'package:profeapp/models/attendance.dart';

class AttendanceNotifier extends ChangeNotifier {
  final List<AttendanceRecord> _records = [];

  List<AttendanceRecord> get records => [..._records];

  void addRecord(AttendanceRecord record) {
    _records.insert(0, record); // Newest first
    notifyListeners();
  }
}
