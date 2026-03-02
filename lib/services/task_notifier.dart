import 'package:flutter/material.dart';
import 'package:profeapp/models/task.dart';
import 'package:profeapp/services/api_service.dart';

class TaskNotifier extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(int groupId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources('/groups/$groupId/tasks');
    _tasks = response.map((data) => Task.fromMap(data)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTask(int groupId, Task task) async {
    final taskData = {'task': task.toMap()};

    final response = await ApiService.createResource(
      '/groups/$groupId/tasks',
      taskData,
    );
    if (response != null) {
      _tasks.add(Task.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeTask(String id) async {
    final success = await ApiService.deleteResource('/tasks/$id');
    if (success) {
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateTask(Task task) async {
    final taskData = {'task': task.toMap()};

    final response = await ApiService.updateResource(
      '/tasks/${task.id}',
      taskData,
    );
    if (response != null) {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = Task.fromMap(response);
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
