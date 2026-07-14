import '../auth/dio_client.dart';
import '../config/api_config.dart';

class AuthApi {
  final DioClient _client = DioClient(ApiConfig.authBaseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final response = await _client.dio.post('/auth/register', data: payload);
    return response.data;
  }
}