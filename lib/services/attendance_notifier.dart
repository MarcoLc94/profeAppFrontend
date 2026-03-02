import 'package:flutter/material.dart';
import 'package:profeapp/models/attendance.dart';
import 'package:profeapp/services/api_service.dart';

class AttendanceNotifier extends ChangeNotifier {
  List<AttendanceSession> _sessions = [];
  bool _isLoading = false;

  List<AttendanceSession> get sessions => List.unmodifiable(_sessions);
  bool get isLoading => _isLoading;

  Future<void> fetchSessions(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/groups/$groupId/attendances',
    );
    _sessions = response
        .map((data) => AttendanceSession.fromMap(data))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addSession(
    int groupId,
    DateTime date,
    String time,
    List<Map<String, dynamic>> records,
  ) async {
    final sessionData = {
      'attendance': {
        'date': date.toIso8601String().split('T')[0],
        'time': time,
      },
      'attendance_records': records,
    };

    final response = await ApiService.createResource(
      '/groups/$groupId/attendances',
      sessionData,
    );
    if (response != null) {
      _sessions.insert(0, AttendanceSession.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }
}
