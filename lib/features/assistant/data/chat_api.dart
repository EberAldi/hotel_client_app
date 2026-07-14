import 'package:dio/dio.dart';

class ChatApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3006/api',
    connectTimeout: const Duration(seconds: 4),
  ));

  Future<String> sendMessage(String message, List<Map<String, String>> history) async {
    try {
      final response = await _dio.post('/chat/', data: {
        'message': message,
        'history': history,
      });
      return response.data['reply'] as String;
    } catch (_) {
      // El microservicio 'assistant' aún no existe — respuesta simulada
      // para poder seguir construyendo la UI sin bloquear el trabajo.
      return _mockReply(message);
    }
  }

  String _mockReply(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('clima') || lower.contains('llover')) {
      return 'Hoy el centro de Oaxaca está agradable para pasear. Te recomiendo '
          'llevar algo ligero para el día y un suéter para la noche, suele refrescar.';
    }
    if (lower.contains('comer') || lower.contains('restaurante') || lower.contains('comida')) {
      return 'Cerca del hotel te recomiendo el Mercado 20 de Noviembre para tlayudas '
          'y el Mercado Benito Juárez para un mezcal de la casa. Ambos a menos de 10 min caminando.';
    }
    if (lower.contains('check') || lower.contains('hora')) {
      return 'El check-in es a partir de las 3:00 PM y el check-out antes de las 12:00 PM. '
          '¿Necesitas dejar equipaje antes de hora? Podemos guardarlo en recepción.';
    }
    return 'Con gusto te ayudo con eso. (Respuesta simulada — el asistente real se conectará '
        'al microservicio de IA próximamente)';
  }
}