class LoginResult {
  const LoginResult({
    required this.success,
    this.message,
    this.authToken,
    this.userId,
  });

  final bool success;
  final String? message;
  final String? authToken;
  final String? userId;
}
