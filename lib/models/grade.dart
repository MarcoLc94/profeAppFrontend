class Grade {
  final String id;
  final String taskId;
  final String taskName;
  final String studentId;
  final String studentName;
  final double score;
  final String comment;
  final DateTime date;

  Grade({
    required this.id,
    required this.taskId,
    required this.taskName,
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.comment,
    required this.date,
  });
}
