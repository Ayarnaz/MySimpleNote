import 'package:flutter/material.dart';

// A widget that provides a search bar for filtering notes
class NoteSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  // Constructor to initialize the controller and onChanged callback
  const NoteSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Connects the TextField to the provided controller to handle input
      controller: controller,
      autofocus: true, // Automatically focuses the text field when it is displayed
      decoration: const InputDecoration(
        hintText: 'Search notes',
        border: InputBorder.none,
      ),
      // Triggers the onChanged callback whenever the text input changes
      onChanged: onChanged,
    );
  }
}