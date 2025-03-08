import 'package:flutter/material.dart';
import '../newMeeting.dart';
import 'ChatProvider.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatChannel channel;

  const ChatDetailScreen({Key? key, required this.channel}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _startVideoCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MeetingReadyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () => _startVideoCall(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.channel.messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(widget.channel.messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Введите сообщение"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        widget.channel.messages.add(_messageController.text);
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
