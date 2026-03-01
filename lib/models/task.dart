class Task {
  final String id;
  final String name;
  final String subject;
  final DateTime dueDate;
  final String dueTime;
  final DateTime creationDate;

  Task({
    required this.id,
    required this.name,
    required this.subject,
    required this.dueDate,
    required this.dueTime,
    required this.creationDate,
  });
}
