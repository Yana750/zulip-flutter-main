import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeButton extends StatelessWidget {
  final String color;
  final double radius;
  final String label;

  const NativeButton({
    super.key,
    required this.color,
    required this.radius,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: "custom_button_view",
      layoutDirection: TextDirection.ltr,
      creationParams: {
        "color": color,
        "radius": radius,
        "label": label,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
