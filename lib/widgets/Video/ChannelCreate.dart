import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/model/events.dart';
import '../../api/model/model.dart';
import '../../api/core.dart';

class CreateChannelScreen extends StatefulWidget {
  final ApiConnection api; // Добавляем API как параметр

  const CreateChannelScreen({super.key, required this.api});

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController _channelNameController = TextEditingController();

  void createChannel() async {
    final channelName = _channelNameController.text.trim();
    if (channelName.isEmpty) return;

    final params = {
      "name": channelName,
    };

    try {
      final response = await widget.api.post(
        "create-channel",
            (json) => json, // обработчик JSON-ответа
        "/channels",
        params,
      );

      print("Channel created: $response");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Канал успешно создан!")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка создания канала")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Создать канал")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _channelNameController,
              decoration: const InputDecoration(labelText: "Название канала"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createChannel,
              child: const Text("Создать"),
            ),
          ],
        ),
      ),
    );
  }
}
