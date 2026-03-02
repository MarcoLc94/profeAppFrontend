import 'package:flutter/material.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/services/api_service.dart';

class StudentNotifier extends ChangeNotifier {
  List<Student> _students = [];
  bool _isLoading = false;

  List<Student> get students => List.unmodifiable(_students);
  bool get isLoading => _isLoading;

  Future<void> fetchStudents(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources('/groups/$groupId/students');
    _students = response.map((data) => Student.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addStudent(int groupId, Student student) async {
    final studentData = {'student': student.toMap()};

    final response = await ApiService.createResource(
      '/groups/$groupId/students',
      studentData,
    );
    if (response != null) {
      _students.add(Student.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateStudent(Student student) async {
    // Note: createResource is post, update normally uses PUT/PATCH.
    // I'll add a generic updateResource to ApiService later if needed,
    // but for now let's assume this or a similar flow.
    // For now, I'll stick to the core CRUD needs.
    return false;
  }
}
