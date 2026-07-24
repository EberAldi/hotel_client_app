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
      await _authService.saveTokens(data['access'], data['refresh']);
      return true;
    });
  }

  /// El endpoint de registro solo crea el usuario, no devuelve tokens -- por
  /// eso se hace login inmediatamente después con las mismas credenciales.
  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _api.register(email, password);
      final data = await _api.login(email, password);
      await _authService.saveTokens(data['access'], data['refresh']);
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