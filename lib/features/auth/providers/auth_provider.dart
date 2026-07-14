import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/auth_api.dart';
import '../../../core/auth/auth_service.dart';

final authApiProvider = Provider((ref) => AuthApi());
final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  late final AuthApi _api = ref.read(authApiProvider);
  late final AuthService _authService = ref.read(authServiceProvider);

  @override
  Future<bool> build() async {
    final token = await _authService.getAccessToken();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await _api.login(email, password);
      await _authService.saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    });
  }

  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await _api.register({'email': email, 'password': password});
      await _authService.saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    });
  }

  /// Simulado por ahora — luego se conecta con google_sign_in + tu endpoint de OAuth
  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 800));
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncData(false);
  }
}