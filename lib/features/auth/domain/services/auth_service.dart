import '../models/login_request.dart';
import '../models/login_result.dart';

abstract class AuthService {
  Future<LoginResult> login(LoginRequest request);
}
