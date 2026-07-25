import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioClient(String baseUrl) : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          if (status == 401 || status == 403) {
            // El access token dura solo 2 minutos, así que expira todo el
            // tiempo. En vez de seguir reenviándolo roto en cada request
            // (lo que puede tumbar hasta el login), lo borramos aquí; la
            // próxima acción que requiera sesión vuelve a pedir login.
            await _storage.delete(key: 'access_token');
            await _storage.delete(key: 'refresh_token');
          }
          return handler.next(error);
        },
      ),
    );
  }
}