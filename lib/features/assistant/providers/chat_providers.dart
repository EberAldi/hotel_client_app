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
          content: '¡Hola! Soy el asistente virtual de Casa del Centro. '
              'Puedo recomendarte qué hacer según el clima, dónde comer cerca, '
              'o resolver dudas sobre tu estadía. ¿En qué te ayudo?',
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

    final history = state
        .map((m) => {'role': m.role == ChatRole.user ? 'user' : 'assistant', 'content': m.content})
        .toList();

    final reply = await ref.read(chatApiProvider).sendMessage(text, history);

    isTyping = false;
    state = [
      ...state,
      ChatMessage(id: '${DateTime.now().toIso8601String()}_r', role: ChatRole.assistant, content: reply),
    ];
  }
}