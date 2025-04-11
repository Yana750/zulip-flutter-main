import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  _JoinMeetingScreenState createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final TextEditingController _controller = TextEditingController();
  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<void> _joinMeeting() async {
    String meetingText = _controller.text.trim();

    if (meetingText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите код или ссылку")),
      );
      return;
    }

    String meetingId = _extractMeetingId(meetingText);
    if (meetingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Неверный формат ссылки или кода")),
      );
      return;
    }

    try {
      var options = JitsiMeetConferenceOptions(
        room: meetingId,
        serverURL: "https://jitsi-connectrm.ru:8443", // Сервер
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "disableInviteFunctions": true, // Отключение кнопки приглашения
        },
      );

      await _jitsiMeet.join(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка подключения: $e")),
      );
    }
  }

  /// Функция для извлечения кода встречи из ссылки или строки
  String _extractMeetingId(String input) {
    if (input.contains("meet.jit.si/")) {
      Uri? uri = Uri.tryParse(input);
      return uri?.pathSegments.isNotEmpty == true ? uri!.pathSegments.last : "";
    }
    return input; // Если просто код встречи
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.link, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              "Введите код или ссылку",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Например: abcdefghw или https://meet.jit.si/example",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinMeeting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Подключиться", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
