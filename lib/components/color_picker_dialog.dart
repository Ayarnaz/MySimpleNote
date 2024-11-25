import 'package:flutter/material.dart';

// A dialog widget that allows the user to pick a color
class ColorPickerDialog extends StatelessWidget {
  final int selectedColor; // Currently selected color
  final Function(int) onColorSelected; // Callback when a color is selected

  const ColorPickerDialog({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    // List of predefined colors to display in the color picker
    final colors = [
      0xFFFFFFFF, // White
      0xFFF28B82, // Red
      0xFFFBBC04, // Yellow
      0xFFFFF475, // Light Yellow
      0xFFCCFF90, // Light Green
      0xFFA7FFEB, // Turquoise
      0xFFCBF0F8, // Light Blue
      0xFFAECBFA, // Blue
      0xFFD7AEFB, // Purple
      0xFFFDCFE8, // Pink
    ];

    return AlertDialog(
      title: const Text('Pick a color'),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map((color) => GestureDetector(
          onTap: () {
            onColorSelected(color);
            Navigator.of(context).pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(color),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: color == selectedColor
                ? const Icon(Icons.check, color: Colors.black54)
                : null,
          ),
        )).toList(),
      ),
    );
  }
}