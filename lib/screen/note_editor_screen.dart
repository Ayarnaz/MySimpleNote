import 'package:flutter/material.dart';
import '../database/database_handler.dart';
import '../model/note_model.dart';
import '../components/color_picker_dialog.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // null for new note, existing note for editing

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to validate the form
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _databaseHandler = DatabaseHandler(); // Instance of DatabaseHandler to manage notes
  int _selectedColor = 0xFFFFFFFF; // Default white color

  @override
  void initState() {
    super.initState();
    // If editing an existing note, populate the fields with the note's data
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _tagsController.text = widget.note!.tags ?? ''; // Default to an empty string if tags are null
      _selectedColor = widget.note!.color;
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed to free resources
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {  // Validate the form inputs
      // Create a Note object with the entered data
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        tags: _tagsController.text.isEmpty ? null : _tagsController.text,
        color: _selectedColor,
      );

      // Insert a new note or update an existing note
      if (widget.note == null) {
        await _databaseHandler.insertNote(note);  // Insert new note
      } else {
        await _databaseHandler.updateNote(note);  // Update existing note
      }

      if (mounted) {
        Navigator.pop(context, true); // true indicates success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () => _showColorPicker(),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        color: Color(_selectedColor), // Set the background color of the screen
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {  // Validate that the title is not empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {  // Validate that the content is not empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Tags input field
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma-separated)',
                  border: OutlineInputBorder(),
                  hintText: 'work, important, todo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shows the color picker dialog
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        selectedColor: _selectedColor,
        onColorSelected: (color) {
          setState(() => _selectedColor = color);
        },
      ),
    );
  }
}