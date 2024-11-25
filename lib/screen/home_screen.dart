import 'package:flutter/material.dart';
import '../database/database_handler.dart';
import '../model/note_model.dart';
import 'note_editor_screen.dart';
import 'note_detail_screen.dart';
import '../components/note_card.dart';
import '../components/note_search_bar.dart';
import '../components/tag_filter_dialog.dart';
import '../utils/preferences_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instances of DatabaseHandler and PreferencesHandler for data management
  final DatabaseHandler _databaseHandler = DatabaseHandler();
  final PreferencesHandler _preferencesHandler = PreferencesHandler();
  // List to hold all notes and filtered notes
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  // Flags for loading and search state
  bool _isLoading = true;
  bool _isSearching = false;
  // Text controller for search input
  final TextEditingController _searchController = TextEditingController();
  // Sorting preference, either by timestamp or alphabetical order of titles
  String _sortOrder = 'timestamp';

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load user preferences for sorting
    _loadNotes(); // Load the list of notes
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller when the screen is disposed
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final sortOrder = await _preferencesHandler.getSortOrder();
    setState(() {
      _sortOrder = sortOrder; // Update the sorting order based on saved preference
    });
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    _notes = await _databaseHandler.retrieveNotes(sortOrder: _sortOrder);
    _filteredNotes = _notes; // Initially set filtered notes to all notes
    setState(() => _isLoading = false);
  }

  // Search function that filters notes based on query text
  void _searchNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = _notes; // Show all notes if query is empty
      } else {
        _filteredNotes = _notes
            .where((note) =>
                note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter notes based on title or content
      }
    });
  }

  void _toggleSortOrder() async {
    final newOrder = _sortOrder == 'timestamp' ? 'title' : 'timestamp';
    await _preferencesHandler.setSortOrder(newOrder);
    setState(() => _sortOrder = newOrder);
    _loadNotes(); // Reload the notes with the updated sort order
  }

  // Opens a dialog to filter notes by tags
  void _showTagFilterDialog() {
    final Set<String> allTags = {};
    for (var note in _notes) {
      if (note.tags != null && note.tags!.isNotEmpty) {
        allTags.addAll(
            note.tags!.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty));
      }
    }

    // Show the tag filter dialog
    showDialog(
      context: context,
      builder: (context) => TagFilterDialog(
        tags: allTags,
        onTagSelected: (tag) {
          Navigator.pop(context);
          setState(() {
            _filteredNotes = _notes
                .where((note) => note.tags != null &&
                note.tags!.toLowerCase().contains(tag.toLowerCase()))
                .toList();
          });
        },
        onShowAll: () {
          Navigator.pop(context);
          setState(() => _filteredNotes = _notes); // Show all notes if "Show All" is selected
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? NoteSearchBar(
                controller: _searchController,
                onChanged: _searchNotes,
              )
            : const Text('My Simple Notes'),
        actions: [
          // Search icon that toggles between showing and hiding the search bar
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();  // Clear search when closing
                  _filteredNotes = _notes;    // Reset to all notes
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          if (!_isSearching) ...[
            // Sorting menu for sorting by timestamp or title
            PopupMenuButton<String>(
              icon: Icon(
                _sortOrder == 'timestamp' 
                    ? Icons.access_time 
                    : Icons.sort_by_alpha_rounded,
              ),
              tooltip: 'Sort by',
              initialValue: _sortOrder,
              onSelected: (String value) {
                if (value != _sortOrder) {
                  _toggleSortOrder(); // Toggle the sorting order when selected
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'timestamp',
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: _sortOrder == 'timestamp' ? Theme.of(context).primaryColor : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sort by time',
                        style: TextStyle(
                          color: _sortOrder == 'timestamp' ? Theme.of(context).primaryColor : null,
                          fontWeight: _sortOrder == 'timestamp' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (_sortOrder == 'timestamp')
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.check, size: 18),
                        ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'title',
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort_by_alpha_rounded,
                        color: _sortOrder == 'title' ? Theme.of(context).primaryColor : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sort alphabetically',
                        style: TextStyle(
                          color: _sortOrder == 'title' ? Theme.of(context).primaryColor : null,
                          fontWeight: _sortOrder == 'title' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (_sortOrder == 'title')
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.check, size: 18),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showTagFilterDialog,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loading spinner if the notes are still loading
          : _filteredNotes.isEmpty
          ? const Center(child: Text('No notes yet'))
          : ListView.builder(
        itemCount: _filteredNotes.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return NoteCard(
            note: note,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: note), // Navigate to the note details screen
                ),
              );
              if (result == true) {
                _loadNotes(); // Reload notes after editing
              }
            },
            onDelete: () async {
              await _databaseHandler.deleteNote(note.id!);
              _loadNotes(); // Reload notes after deletion
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(), // Navigate to the note editor screen
            ),
          );
          if (result == true) {
            _loadNotes(); // Reload notes after adding a new one
          }
        },
      ),
    );
  }
}
