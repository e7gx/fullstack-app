/// Represents a Todo item.
///
/// Each Todo has an [id], [title], [description], and [done] status.
class Todo {
  final int id;
  final String title;
  final String description;
  final bool done;

  /// Constructs a Todo instance.
  ///
  /// The [id], [title], [description], and [done] parameters are required.
  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
  });

  /// Factory method to create a Todo from JSON data.
  ///
  /// The [json] parameter is a map containing the JSON data.
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      done: json['done'],
    );
  }

  /// Converts a Todo instance to JSON data.
  ///
  /// Returns a map containing the JSON data.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'done': done,
    };
  }
}
