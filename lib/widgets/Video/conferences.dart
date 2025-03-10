import 'package:flutter/material.dart';

import 'joinWithCode.dart';
import 'newMeeting.dart';

class ConferenceScreen extends StatelessWidget {
  const ConferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Видеозвонок"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {
                //Создать новую встречу
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MeetingReadyScreen(meetingUrl: channel.meetingUrl),
                //   ),
                // );
              },
              label: const Text(
                "Новая встреча",
                style: TextStyle(fontSize: 14),
              ),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 30),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton.icon(
              onPressed: () {
                //Подключиться по ссылке
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinMeetingScreen()),
                );
              },
              icon: const Icon(Icons.margin),
              label: const Text(
                "Подключиться к встрече",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(350, 30),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.indigo),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
