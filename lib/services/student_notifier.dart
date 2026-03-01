import 'package:flutter/material.dart';
import 'package:profeapp/models/student.dart';

class StudentNotifier extends ChangeNotifier {
  final List<Student> _students = [];

  List<Student> get students => List.unmodifiable(_students);

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(Student updatedStudent) {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }
}
