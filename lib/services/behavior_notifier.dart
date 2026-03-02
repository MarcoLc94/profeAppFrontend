import 'package:flutter/material.dart';
import 'package:profeapp/models/behavior_entry.dart';
import 'package:profeapp/services/api_service.dart';

class BehaviorNotifier extends ChangeNotifier {
  List<BehaviorEntry> _entries = [];
  bool _isLoading = false;

  List<BehaviorEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  Future<void> fetchEntriesForStudent(int studentId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/students/$studentId/behavior_entries',
    );
    _entries = response.map((data) => BehaviorEntry.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEntriesForGroup(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/groups/$groupId/behavior_entries',
    );
    _entries = response.map((data) => BehaviorEntry.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // Helper to filter from memory if already loaded
  List<BehaviorEntry> getEntriesForStudent(String studentId) {
    return _entries.where((e) => e.studentId == studentId).toList();
  }

  Future<bool> addEntry(BehaviorEntry entry) async {
    final entryData = {'behavior_entry': entry.toMap()};

    final response = await ApiService.createResource(
      '/students/${entry.studentId}/behavior_entries',
      entryData,
    );
    if (response != null) {
      _entries.add(BehaviorEntry.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }
}
