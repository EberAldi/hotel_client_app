import '../../../core/auth/dio_client.dart';
import '../../../core/config/api_config.dart';

class ChatApi {
  final DioClient _client = DioClient(ApiConfig.assistantBaseUrl);

  /// POST /api/asistente/chat/   body: {"mensaje": "..."}
  /// Requiere JWT (cliente o admin) -- el backend ya no acepta invitados
  /// anonimos para el chat.
  Future<String> sendMessage(String mensaje) async {
    final response = await _client.dio.post('/chat/', data: {'mensaje': mensaje});
    return response.data['respuesta'] as String;
  }
}
