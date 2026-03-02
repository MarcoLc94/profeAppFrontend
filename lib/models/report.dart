import 'package:intl/intl.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final String studentId;
  final DateTime date;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.studentId,
    required this.date,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      studentId: map['student_id']?.toString() ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'student_id': int.parse(studentId),
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }
}
