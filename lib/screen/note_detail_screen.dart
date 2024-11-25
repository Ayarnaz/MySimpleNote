import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp
import '../model/note_model.dart';
import 'note_editor_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note; // The note passed from the previous screen to display its details

  const NoteDetailScreen({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the NoteEditorScreen to edit the note
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditorScreen(note: note),
                ),
              );
              if (result == true) {
                Navigator.pop(context, true); // Refresh home screen
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(note.color),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Display the timestamp when the note was last modified, formatted
            Text(
              'Last modified: ${DateFormat('MMM dd, yyyy HH:mm').format(note.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            if (note.tags != null && note.tags!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: note.tags!
                    .split(',') // Split the tags by comma
                    .map((tag) => tag.trim()) // Trim each tag to remove extra spaces
                    .where((tag) => tag.isNotEmpty) // Filter out empty tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(tag),
                        ))
                    .toList(), // Convert the list of tag containers to a list
              ),
            ],
            const SizedBox(height: 24),
            Text(
              note.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}