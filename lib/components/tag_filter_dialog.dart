import 'package:flutter/material.dart';

// A dialog widget for filtering notes based on tags
class TagFilterDialog extends StatelessWidget {
  final Set<String> tags; // A set of available tags to display for filtering
  final Function(String) onTagSelected; // Callback when a specific tag is selected
  final VoidCallback onShowAll; // Callback to show all notes without filtering

  const TagFilterDialog({
    super.key,
    required this.tags,
    required this.onTagSelected,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by Tag'),
      // Content of the dialog - displays available tags or a message if none exist
      content: tags.isEmpty
          ? const Text('No tags available')
          : Wrap(
        spacing: 8,
        children: tags.map((tag) => FilterChip(
          label: Text(tag),
          onSelected: (_) => onTagSelected(tag),
        )).toList(),
      ),
      actions: [
        // Button to show all notes without applying any filters
        TextButton(
          onPressed: onShowAll,
          child: const Text('Show All'),
        ),
      ],
    );
  }
}