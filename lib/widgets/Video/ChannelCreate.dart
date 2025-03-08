import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

// void main() {
//   runApp(ChannelCreateVideo());
// }

class ChatProvider with ChangeNotifier {
  List<ChatChannel> channels = [];

  void addChannel(String name) {
    channels.add(ChatChannel(name));
    notifyListeners();
  }
}

class ChatChannel {
  String name;
  List<String> messages = [];
  ChatChannel(this.name);
}

class ChannelCreateVideo extends StatelessWidget {
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
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController _controller = TextEditingController();
              return AlertDialog(
                title: const Text("Создать канал"),
                content: TextField(controller: _controller),
                actions: [
                  TextButton(
                    onPressed: () {
                      Provider.of<ChatProvider>(context, listen: false).addChannel(_controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text("Создать"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final ChatChannel channel;
  ChatDetailScreen({required this.channel});

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
                    setState(() {
                      widget.channel.messages.add(_messageController.text);
                      _messageController.clear();
                    });
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
    startMeeting();
  }

  void generateMeetingCode() {
    var uuid = const Uuid();
    setState(() {
      meetingCode = uuid.v4().substring(0, 8);
    });
  }

  Future<void> startMeeting() async {
    try {
      var options = JitsiMeetConferenceOptions(
        room: meetingCode,
        serverURL: "Введите URL",
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
      body: const Center(
        child: CircularProgressIndicator(), // Пока идет подключение
      ),
    );
  }
}
