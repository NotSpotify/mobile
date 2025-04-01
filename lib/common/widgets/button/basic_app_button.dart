import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final Color? color;
  final double? height;
  const BasicAppButton({
    super.key,
    this.onPressed,
    this.title,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 50),
        backgroundColor: color ?? Theme.of(context).primaryColor,
      ),
      child: Text(title ?? '', style: TextStyle(color: Colors.white)),
    );
  }
}
