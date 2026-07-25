import 'package:dio/dio.dart';
import '../config/api_config.dart';

class AuthApi {
  // Dio "plano" a propósito (sin el interceptor de DioClient que adjunta el
  // token guardado): login/registro nunca deben mandar un Authorization
  // viejo -- si el dispositivo tiene un token expirado o corrupto guardado,
  // el backend rechaza la petición completa (incluido el login) antes de
  // llegar a validar usuario/contraseña.
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.authBaseUrl));

  /// POST /api/auth/login/ -- devuelve {access, refresh, rol}.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/login/', data: {
      'correo': email,
      'contrasena': password,
    });
    return response.data;
  }

  /// POST /api/auth/usuarios/ -- crea el usuario (rol "cliente" forzado en
  /// servidor). No devuelve tokens: hay que loguearse después con las mismas
  /// credenciales.
  Future<void> register(String email, String password) async {
    await _dio.post('/usuarios/', data: {
      'correo': email,
      'contrasena': password,
    });
  }
}
