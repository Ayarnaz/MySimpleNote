import 'package:flutter/material.dart';
import '../model/note_model.dart';

// A widget that represents a card displaying a single note
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Sets the background color of the card using the note's color property
      color: Color(note.color),
      child: ListTile(
        // Displays the title of the note in bold text
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Displays additional content such as the note's content and tags
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content,
              maxLines: 2, // Limits content to two lines
              overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
            ),
            // If tags are present, displays them below the content
            if (note.tags != null && note.tags!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: note.tags!
                    .split(',')
                    .map((tag) => tag.trim()) // Removes extra spaces from each tag
                    .where((tag) => tag.isNotEmpty)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),  // Semi-transparent white background
                            borderRadius: BorderRadius.circular(12),  // Rounded corners
                          ),
                          child: Text(tag),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}