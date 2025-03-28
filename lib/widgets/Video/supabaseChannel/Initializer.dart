import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ChannelScreen.dart';
import 'ChatProvider.dart';

class AppInitializer {
  // Функция инициализации Supabase и возвращения главного виджета
  static Future<Widget> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Инициализация Supabase
    await Supabase.initialize(
      url: 'https://njgrfdshknmqyisqzpbn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZ3JmZHNoa25tcXlpc3F6cGJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0MTc4OTAsImV4cCI6MjA1Njk5Mzg5MH0.nnCon74F6A13dRCMhDYPIdAS2te96fNUgIafGzB1Z_Y',
    );

    // Оборачиваем все в ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const ChatScreen(),
    );
  }
}
