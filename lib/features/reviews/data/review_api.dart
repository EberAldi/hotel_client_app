import '../../../core/auth/dio_client.dart';
import '../../../core/config/api_config.dart';
import 'review_models.dart';

class ReviewApi {
  final DioClient _client = DioClient(ApiConfig.reviewBaseUrl);

  Future<List<Resena>> getResenas({String? tipoObjetivo, String? objetivoId}) async {
    final response = await _client.dio.get('/resenas/', queryParameters: {
      if (tipoObjetivo != null) 'tipo_objetivo': tipoObjetivo,
      if (objetivoId != null) 'objetivo_id': objetivoId,
    });
    return (response.data as List).map((e) => Resena.fromJson(e)).toList();
  }

  /// cliente_id y estado los asigna el servidor a partir del JWT -- nunca se
  /// mandan en el body.
  Future<void> crearResena({
    required String tipoObjetivo,
    required String objetivoId,
    required int calificacion,
    required String comentario,
  }) async {
    await _client.dio.post('/resenas/', data: {
      'tipo_objetivo': tipoObjetivo,
      'objetivo_id': objetivoId,
      'calificacion': calificacion,
      'comentario': comentario,
    });
  }
}
