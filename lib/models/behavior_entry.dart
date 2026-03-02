import 'package:intl/intl.dart';

enum BehaviorType { positive, negative, neutral }

class BehaviorEntry {
  final String id;
  final String studentId;
  final BehaviorType type;
  final String description;
  final DateTime date;

  BehaviorEntry({
    required this.id,
    required this.studentId,
    required this.type,
    required this.description,
    required this.date,
  });

  factory BehaviorEntry.fromMap(Map<String, dynamic> map) {
    return BehaviorEntry(
      id: map['id']?.toString() ?? '',
      studentId: map['student_id']?.toString() ?? '',
      type: _parseType(map['behavior_type']),
      description: map['description'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  static BehaviorType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'positive':
        return BehaviorType.positive;
      case 'negative':
        return BehaviorType.negative;
      case 'neutral':
      default:
        return BehaviorType.neutral;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': int.parse(studentId),
      'behavior_type': type.name,
      'description': description,
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }
}
