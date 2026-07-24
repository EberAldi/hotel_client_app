import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_api.dart';
import '../data/chat_models.dart';

final chatApiProvider = Provider((ref) => ChatApi());

final chatMessagesProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(ChatNotifier.new);

class ChatNotifier extends Notifier<List<ChatMessage>> {
  bool isTyping = false;

  @override
  List<ChatMessage> build() => [
        ChatMessage(
          id: 'welcome',
          role: ChatRole.assistant,
          content: '¡Hola! Soy Luna, el asistente virtual de Casa del Centro. '
              'Puedo resolver dudas sobre tu estadía, horarios y los servicios del hotel. ¿En qué te ayudo?',
        ),
      ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    state = [
      ...state,
      ChatMessage(id: DateTime.now().toIso8601String(), role: ChatRole.user, content: text),
    ];

    isTyping = true;
    ref.notifyListeners();

    String respuesta;
    try {
      respuesta = await ref.read(chatApiProvider).sendMessage(text);
    } on DioException catch (e) {
      final detalle = e.response?.data is Map ? e.response?.data['detail'] : null;
      respuesta = detalle?.toString() ?? 'No pude responder en este momento. Intenta de nuevo en un rato.';
    }

    isTyping = false;
    state = [
      ...state,
      ChatMessage(id: '${DateTime.now().toIso8601String()}_r', role: ChatRole.assistant, content: respuesta),
    ];
  }
}
