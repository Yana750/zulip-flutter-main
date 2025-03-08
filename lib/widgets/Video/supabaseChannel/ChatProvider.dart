import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  List<ChatChannel> channels = [];

  ChatProvider() {
    _loadChannels();
  }

  /// Загружаем каналы из Supabase
  void _loadChannels() async {
    final response = await supabase.from('channel').select();
    channels = response.map((channel) => ChatChannel(
      id: channel['id'] as int, // Приведение к int
      name: channel['name'] as String, // Приведение к String
      meetingUrl: channel['meeting_url'] as String, // Приведение к String
    )).toList();
    notifyListeners();
  }

  /// Добавляем канал и сохраняем в Supabase
  Future<void> addChannel(String name) async {
    String meetingCode = "meet-${DateTime.now().millisecondsSinceEpoch}";
    String jitsiUrl = "https://meet.jit.si/$meetingCode";

    final response = await supabase.from('channel').insert({
      'name': name,
      'meeting_url': jitsiUrl,
    }).select();

    if (response.isNotEmpty) {
      channels.add(ChatChannel(
        id: (response[0]['id'] as num).toInt(), // Приводим к int, если это число
        name: response[0]['name'] as String, // Приводим к String
        meetingUrl: response[0]['meeting_url'] as String, // Приводим к String
      ));
      notifyListeners();
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
