import 'package:flutter/material.dart';
import 'package:profeapp/models/grade.dart';
import 'package:profeapp/services/api_service.dart';

class GradeNotifier extends ChangeNotifier {
  List<Grade> _grades = [];
  bool _isLoading = false;

  List<Grade> get grades => List.unmodifiable(_grades);
  bool get isLoading => _isLoading;

  Future<void> fetchGradesForStudent(int studentId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/students/$studentId/grades',
    );
    _grades = response.map((data) => Grade.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGradesForGroup(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources('/groups/$groupId/grades');
    _grades = response.map((data) => Grade.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Helper to get grades from memory if already loaded
  List<Grade> getGradesForStudent(String studentId) {
    return _grades.where((g) => g.studentId == studentId).toList();
  }

  Future<bool> addGrade(Grade grade) async {
    final gradeData = {'grade': grade.toMap()};

    final response = await ApiService.createResource(
      '/students/${grade.studentId}/grades',
      gradeData,
    );
    if (response != null) {
      _grades.add(Grade.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }
}
