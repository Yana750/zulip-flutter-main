import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JitsiWebView extends StatefulWidget {
  final String roomUrl;

  const JitsiWebView({super.key, required this.roomUrl});

  @override
  State<JitsiWebView> createState() => _JitsiWebViewState();
}

class _JitsiWebViewState extends State<JitsiWebView> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    final webUri = WebUri(widget.roomUrl);

    return Scaffold(
      appBar: AppBar(title: const Text("Видеозвонок")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: webUri),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(useHybridComposition: true),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
            allowsPictureInPictureMediaPlayback: true,
            allowsAirPlayForMediaPlayback: false,
          )
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;

          // Добавляем JS хендлер, который Flutter вызовет при окончании звонка
          controller.addJavaScriptHandler(
            handlerName: 'onConferenceLeft',
            callback: (args) {
              Navigator.of(context).pop();
            },
          );
        },
        onLoadStop: (controller, url) async {
          // Внедряем JS, который создаст API и подпишется на событие выхода
          await controller.evaluateJavascript(source: """
            if (!window.api && window.JitsiMeetExternalAPI) {
              const domain = '${Uri.parse(widget.roomUrl).host}';
              const room = '${Uri.parse(widget.roomUrl).pathSegments.last}';
              window.api = new JitsiMeetExternalAPI(domain, {roomName: room});
              
              window.api.addEventListener('conferenceLeft', () => {
                window.flutter_inappwebview.callHandler('onConferenceLeft');
              });
            }
          """);
        },
        onConsoleMessage: (controller, message) {
          print("Console: ${message.message}");
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
