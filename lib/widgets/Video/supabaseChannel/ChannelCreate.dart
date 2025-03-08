import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ChatProvider.dart';
import 'chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://njgrfdshknmqyisqzpbn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZ3JmZHNoa25tcXlpc3F6cGJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0MTc4OTAsImV4cCI6MjA1Njk5Mzg5MH0.nnCon74F6A13dRCMhDYPIdAS2te96fNUgIafGzB1Z_Y',
  );

  runApp(const ChannelCreate());
}

class ChannelCreate extends StatelessWidget {
  const ChannelCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
      ),
    );
  }
}
