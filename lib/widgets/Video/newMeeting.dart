import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JitsiMeetPage extends StatefulWidget {
  const JitsiMeetPage({super.key});

  @override
  _JitsiMeetPageState createState() => _JitsiMeetPageState();
}

class _JitsiMeetPageState extends State<JitsiMeetPage> {
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late JitsiMeet _jitsiMeet;

  @override
  void initState() {
    super.initState();
    _jitsiMeet = JitsiMeet();
  }

  void _joinMeeting() async {
    String roomName = _roomController.text.trim();
    String userName = _nameController.text.trim();

    if (roomName.isNotEmpty) {
      var options = JitsiMeetConferenceOptions(
        room: roomName,
        userInfo: JitsiMeetUserInfo(displayName: userName.isNotEmpty ? userName : "Guest"),
      );

      try {
        await _jitsiMeet.join(options);
      } catch (error) {
        print("Ошибка при подключении: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jitsi Meet Flutter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: "Room Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinMeeting,
              child: const Text("Join Meeting"),
            ),
          ],
        ),
      ),
    );
  }
}
