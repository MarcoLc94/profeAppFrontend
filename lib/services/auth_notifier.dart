import 'package:flutter/material.dart';
import 'package:profeapp/services/api_service.dart';

class User {
  final String id;
  final String names;
  final String lastNames;
  final String role; // e.g. 'maestro'

  User({
    required this.id,
    required this.names,
    required this.lastNames,
    this.role = 'maestro',
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      names: map['names'] ?? '',
      lastNames: map['last_names'] ?? '',
      role: map['role'] ?? 'maestro',
    );
  }

  String get fullName => '$names $lastNames';
}

class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  Future<bool> login(String phoneNumber, String password) async {
    final response = await ApiService.login(phoneNumber, password);
    if (response != null) {
      _isAuthenticated = true;
      _user = User.fromMap(response);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _user = User(id: '1', names: 'Maestro', lastNames: 'Demo');
    notifyListeners();
  }

  Future<bool> requestOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyOtpAndLogin(String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otpCode.length == 6) {
      _isAuthenticated = true;
      _user = User(id: '1', names: 'Maestro', lastNames: 'Demo');
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
