import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChatProvider.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Каналы")),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) => ListView.builder(
          itemCount: chatProvider.channels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(chatProvider.channels[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(channel: chatProvider.channels[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showCreateChannelDialog(context);
        },
      ),
    );
  }

  void _showCreateChannelDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Создать канал"),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<ChatProvider>(context, listen: false).addChannel(_controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text("Создать"),
            ),
          ],
        );
      },
    );
  }
}
