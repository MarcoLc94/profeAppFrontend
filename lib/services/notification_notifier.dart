import 'package:flutter/material.dart';
import 'package:profeapp/models/app_notification.dart';
import 'package:profeapp/services/api_service.dart';

class NotificationNotifier extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.getResources(
      '/users/$userId/notifications',
    );
    _notifications = response
        .map((data) => AppNotification.fromMap(data))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addNotification(int userId, AppNotification notification) async {
    final notificationData = {'notification': notification.toMap()};

    final response = await ApiService.createResource(
      '/users/$userId/notifications',
      notificationData,
    );
    if (response != null) {
      _notifications.add(AppNotification.fromMap(response));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeNotification(String id) async {
    final success = await ApiService.deleteResource('/notifications/$id');
    if (success) {
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  List<AppNotification> get activeNotifications {
    final now = DateTime.now();
    return _notifications.where((n) => n.expirationDate.isAfter(now)).toList();
  }
}
