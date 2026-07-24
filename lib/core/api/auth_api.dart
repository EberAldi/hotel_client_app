import '../auth/dio_client.dart';
import '../config/api_config.dart';

class AuthApi {
  final DioClient _client = DioClient(ApiConfig.authBaseUrl);

  /// POST /api/auth/login/ -- devuelve {access, refresh, rol}.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('/login/', data: {
      'correo': email,
      'contrasena': password,
    });
    return response.data;
  }

  /// POST /api/auth/usuarios/ -- crea el usuario (rol "cliente" forzado en
  /// servidor). No devuelve tokens: hay que loguearse después con las mismas
  /// credenciales.
  Future<void> register(String email, String password) async {
    await _client.dio.post('/usuarios/', data: {
      'correo': email,
      'contrasena': password,
    });
  }
}