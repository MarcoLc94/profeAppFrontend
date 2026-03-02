import 'package:intl/intl.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String subject;
  final DateTime dueDate;
  final String dueTime;
  final DateTime creationDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.dueDate,
    required this.dueTime,
    required this.creationDate,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subject: map['subject'] ?? '',
      dueDate: DateTime.parse(map['due_date']),
      dueTime: map['due_time'] ?? '',
      creationDate: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'subject': subject,
      'due_date': DateFormat('yyyy-MM-dd').format(dueDate),
      'due_time': dueTime,
    };
  }
}
