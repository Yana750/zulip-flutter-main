import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatProvider with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  static const Uuid uuid = Uuid(); // Генератор уникальных ID
  List<ChatChannel> channels = [];

  ChatProvider() {
    _loadChannels();
  }

  /// Загружаем каналы из Supabase
  Future<void> _loadChannels() async {
    final response = await supabase.from('channel').select();

    if (response.isNotEmpty) {
      channels = response.map((channel) => ChatChannel(
        id: channel['id'] as int, // Приведение к int
        name: channel['name'] as String, // Приведение к String
        meetingUrl: channel['meeting_url'] as String, // Приведение к String
      )).toList();
      notifyListeners();
    } else {
      print("Ошибка загрузки каналов или каналов пока нет.");
    }
  }

  /// Создаем новый канал с постоянным `meeting_url`
  Future<void> addChannel(String name) async {
    String meetingId = uuid.v4(); // Генерируем уникальный ID для встречи
    String jitsiUrl = "https://meet.jit.si/$meetingId"; // Создаем ссылку для Jitsi

    try {
      final response = await supabase.from('channel').insert([
        {
          'name': name,
          'meeting_url': jitsiUrl,
        }
      ]).select();

      if (response.isNotEmpty) {
        print("Канал успешно создан: ${response[0]}");
        channels.add(ChatChannel(
          id: (response[0]['id'] as num).toInt(),
          name: response[0]['name'] as String,
          meetingUrl: response[0]['meeting_url'] as String,
        ));
        notifyListeners();
      } else {
        print("Ошибка создания канала: пустой ответ.");
      }
    } catch (e) {
      print("Ошибка при добавлении канала: $e");
    }

  }
}

class ChatChannel {
  final int id;
  final String name;
  final String meetingUrl;
  List<String> messages = [];

  ChatChannel({required this.id, required this.name, required this.meetingUrl});
}
