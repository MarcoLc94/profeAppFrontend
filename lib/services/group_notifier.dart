import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:profeapp/services/api_service.dart';

class GroupNotifier extends ChangeNotifier {
  List<Group> _groups = [];
  bool _isLoading = false;

  List<Group> get groups => List.unmodifiable(_groups);
  bool get isLoading => _isLoading;

  Future<void> fetchGroups(int userId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources('/users/$userId/groups');
    _groups = response.map((data) => Group.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGroup(
    int userId,
    String name,
    String grade,
    String schoolYear,
  ) async {
    final groupData = {
      'group': {'name': name, 'grade': grade, 'school_year': schoolYear},
    };

    final response = await ApiService.createResource(
      '/users/$userId/groups',
      groupData,
    );
    if (response != null) {
      _groups.add(Group.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }
}
