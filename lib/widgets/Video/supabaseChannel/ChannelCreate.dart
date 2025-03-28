import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChatProvider.dart';
import 'ChannelScreen.dart';

class ChannelCreate extends StatelessWidget {
  const ChannelCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
      ),
    );
  }
}
