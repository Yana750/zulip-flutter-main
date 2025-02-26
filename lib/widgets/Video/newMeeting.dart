import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:uuid/uuid.dart';

class MeetingReadyScreen extends StatefulWidget {
  const MeetingReadyScreen({super.key});

  @override
  _MeetingReadyScreenState createState() => _MeetingReadyScreenState();
}

class _MeetingReadyScreenState extends State<MeetingReadyScreen> {
  String meetingCode = "";
  late JitsiMeet _jitsiMeet;

  @override
  void initState() {
    super.initState();
    _jitsiMeet = JitsiMeet();
    generateMeetingCode();
  }


  void generateMeetingCode() {
    var uuid = const Uuid();
    setState(() {
      meetingCode = uuid.v4().substring(0, 8); // Генерируем случайный код
    });
  }

  Future<void> startMeeting() async {
    try {
      var options = JitsiMeetConferenceOptions(
        room: meetingCode,
        serverURL: "https://jitsi-connectrm.ru:8443/",
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
        },
      );

      await _jitsiMeet.join(options);
    } catch (error) {
      print("Ошибка подключения: $error");
    }
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
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.computer, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              "Ваша встреча готова",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.link, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(meetingCode, style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.grey),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: "https://meet.jit.si/$meetingCode"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ссылка скопирована!")),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                startMeeting();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Начать вывзов", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
