import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JitsiCallPage extends StatelessWidget {
  final String roomName;

  const JitsiCallPage({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Звонок: $roomName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: const SafeArea(
        child: JitsiMeetViewWrapper(),
      ),
    );
  }
}

class JitsiMeetViewWrapper extends StatelessWidget {
  const JitsiMeetViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;

    if (args == null) {
      return const Center(child: Text("Room name not provided"));
    }

    return AndroidView(
      viewType: 'jitsi_meet_view',
      creationParams: {'room': args},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
