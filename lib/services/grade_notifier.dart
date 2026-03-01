import 'package:flutter/material.dart';
import 'package:profeapp/models/grade.dart';

class GradeNotifier extends ChangeNotifier {
  final List<Grade> _grades = [];

  List<Grade> get grades => [..._grades];

  void addGrade(Grade grade) {
    // Remove existing grade for the same student and task if it exists (update)
    _grades.removeWhere(
      (g) => g.taskId == grade.taskId && g.studentId == grade.studentId,
    );
    _grades.add(grade);
    notifyListeners();
  }

  List<Grade> getGradesForStudent(String studentId) {
    return _grades.where((g) => g.studentId == studentId).toList();
  }

  List<Grade> getGradesForTask(String taskId) {
    return _grades.where((g) => g.taskId == taskId).toList();
  }

  void removeGrade(String id) {
    _grades.removeWhere((g) => g.id == id);
    notifyListeners();
  }
}
