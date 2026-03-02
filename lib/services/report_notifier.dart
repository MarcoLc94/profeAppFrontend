import 'package:flutter/material.dart';
import 'package:profeapp/models/report.dart';
import 'package:profeapp/services/api_service.dart';

class ReportNotifier extends ChangeNotifier {
  List<Report> _reports = [];
  bool _isLoading = false;

  List<Report> get reports => List.unmodifiable(_reports);
  bool get isLoading => _isLoading;

  Future<void> fetchReportsForStudent(int studentId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/students/$studentId/reports',
    );
    _reports = response.map((data) => Report.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReportsForGroup(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources('/groups/$groupId/reports');
    _reports = response.map((data) => Report.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Helper to filter from memory if already loaded
  List<Report> getReportsForStudent(String studentId) {
    return _reports.where((r) => r.studentId == studentId).toList();
  }

  Future<bool> addReport(Report report) async {
    final reportData = {'report': report.toMap()};

    final response = await ApiService.createResource(
      '/students/${report.studentId}/reports',
      reportData,
    );
    if (response != null) {
      _reports.add(Report.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }
}
