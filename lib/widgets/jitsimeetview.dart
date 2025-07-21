import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JitsiMeetView extends StatelessWidget {
  final String roomName;

  const JitsiMeetView({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'jitsi_meet_view',
      creationParams: {
        'room': roomName,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
