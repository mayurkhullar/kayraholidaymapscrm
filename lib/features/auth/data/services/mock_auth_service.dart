import 'dart:async';

import '../../domain/models/login_request.dart';
import '../../domain/models/login_result.dart';
import '../../domain/services/auth_service.dart';

class MockAuthService implements AuthService {
  const MockAuthService();

  @override
  Future<LoginResult> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (request.phoneNumber.trim().isNotEmpty &&
        request.password.trim().isNotEmpty) {
      return const LoginResult(
        success: true,
        message: 'Login successful.',
        authToken: 'mock-auth-token',
        userId: 'mock-user-id',
      );
    }

    return const LoginResult(
      success: false,
      message: 'Phone number and password are required.',
    );
  }
}
