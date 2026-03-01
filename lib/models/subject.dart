class Subject {
  final String id;
  final String name;
  final String grade; // e.g., "1ero", "2do", etc.
  final DateTime creationDate;

  Subject({
    required this.id,
    required this.name,
    required this.grade,
    required this.creationDate,
  });
}
