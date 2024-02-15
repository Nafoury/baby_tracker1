import 'package:flutter/material.dart';

class EntryButton extends StatelessWidget {
  final dynamic entryData; // Use dynamic to allow different types
  final VoidCallback onTap;

  const EntryButton({
    required this.entryData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade100, // Customize the color as needed
        ),
      ),
    );
  }
}
