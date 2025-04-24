import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final Color backgroundColor;

  const StyledButton({
    required this.title,
    required this.onPressed,
    this.disabled = false,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
