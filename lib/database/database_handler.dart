import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note_model.dart';

class DatabaseHandler{
  Future<Database> intializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mysimplenote.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
            '''CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            tags TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            color INTEGER DEFAULT 0
          )'''
        );
      },
    );
  }

  // Insert note
  Future<int> insertNote(Note note) async {
    final Database db = await intializeDB(); // Initialize the database
    return await db.insert('notes', note.toMap());
  }

  // Retrieve notes
  Future<List<Note>> retrieveNotes({String sortOrder = 'timestamp'}) async {
    final Database db = await intializeDB();
    final String orderBy = sortOrder == 'timestamp' 
        ? 'timestamp DESC' 
        : 'LOWER(title) ASC';  // Case-insensitive title sort function
        
    final List<Map<String, Object?>> queryResult = await db.query(
      'notes', 
      orderBy: orderBy // Apply sorting
    );
    return queryResult.map((e) => Note.fromMap(e)).toList();
    // Convert results to Note objects
  }

  // Retrieve notes by tag
  Future<List<Note>> getNotesByTag(String tag) async {
    final Database db = await intializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
        'notes',
        where: 'tags LIKE ?',
        whereArgs: ['%$tag%'], // Partial matching for the tag
        orderBy: 'timestamp DESC'  // Newest first
    );
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  // Update notes
  Future<int> updateNote(Note note) async {
    final Database db = await intializeDB();
    return await db.update(
      'notes',
      note.toMap(), // Updated data
      where: 'id = ?', // Specify the note to update
      whereArgs: [note.id],
    );
  }

  // Delete notes
  Future<void> deleteNote(int id) async {
    final Database db = await intializeDB();
    await db.delete(
      'notes',
      where: 'id = ?', // Specify the note to delete
      whereArgs: [id],
    );
  }

  // Search notes by title or content
  Future<List<Note>> searchNotes(String query) async {
    final Database db = await intializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
        'notes',
        where: 'title LIKE ? OR content LIKE ?', // Search both title & content
        whereArgs: ['%$query%', '%$query%'], // Partial matching
        orderBy: 'timestamp DESC' // Newest notes first
    );
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }
}