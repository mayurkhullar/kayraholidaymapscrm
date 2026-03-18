import '../constants/app_environment.dart';
import 'firebase_initializer.dart';

class AppStartupService {
  const AppStartupService._();

  static Future<void> initialize() async {
    if (!AppEnvironment.enableFirebase) {
      return;
    }

    await FirebaseInitializer.initialize();
  }
}
