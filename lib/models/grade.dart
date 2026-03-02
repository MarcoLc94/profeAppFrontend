class Grade {
  final String id;
  final String taskId;
  final String studentId;
  final double score;
  final String comment;
  final DateTime date;

  Grade({
    required this.id,
    required this.taskId,
    required this.studentId,
    required this.score,
    required this.comment,
    required this.date,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id']?.toString() ?? '',
      taskId: map['task_id']?.toString() ?? '',
      studentId: map['student_id']?.toString() ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      date: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': int.parse(taskId),
      'student_id': int.parse(studentId),
      'score': score,
      'comment': comment,
    };
  }
}
