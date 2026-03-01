import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Mock Google Sign-In
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    notifyListeners();
  }

  // Mock OTP Request
  Future<bool> requestOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate a successful SMS sent
    return true;
  }

  // Mock OTP Verification
  Future<bool> verifyOtpAndLogin(String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otpCode.length == 6) {
      // Basic mock validation
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
