import 'package:flutter/material.dart';

class ButtonIconWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Icon icon;
  final VoidCallback onClicked;

  const ButtonIconWidget({
    Key? key,
    required this.text,
    this.color = Colors.white,
    required this.onClicked,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        iconSize: 50,
        onPressed: onClicked,
        icon: icon,
        color: color,
      );
}
