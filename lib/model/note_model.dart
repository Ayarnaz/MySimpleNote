class Note {
  final int? id;
  String title;
  String content;
  String? tags;
  DateTime timestamp;
  int color;

  // Constructor for the Note class, allowing for default values
  Note({
    this.id,
    required this.title,
    required this.content,
    this.tags,
    DateTime? timestamp,
    this.color = 0,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert the Note object to a Map for database operations (inserting/updating)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'timestamp': timestamp.toIso8601String(), // The timestamp in ISO 8601 string format
      'color': color,
    };
  }

  // Create a Note object from a Map (used for fetching from the database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      tags: map['tags'],
      timestamp: DateTime.parse(map['timestamp']), // Convert timestamp string back to DateTime
      color: map['color'],
    );
  }

  // Clone method for creating a modified copy of the note (useful for editing)
  Note copy({
    int? id,
    String? title,
    String? content,
    String? tags,
    DateTime? timestamp,
    int? color,
  }) {
    return Note(
      // Use the existing note details unless provided with new details
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      timestamp: timestamp ?? this.timestamp,
      color: color ?? this.color,
    );
  }
}