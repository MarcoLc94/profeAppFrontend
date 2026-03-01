import 'package:flutter/material.dart';
import 'package:profeapp/models/subject.dart';

class SubjectNotifier extends ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => [..._subjects];

  List<Subject> getSubjectsByGrade(String grade) {
    return _subjects.where((s) => s.grade == grade).toList();
  }

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  void removeSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
