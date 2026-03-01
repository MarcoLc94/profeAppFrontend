enum AttendanceStatus { present, absent, late }

class AttendanceEntry {
  final AttendanceStatus status;
  final bool isJustified;

  AttendanceEntry({required this.status, this.isJustified = false});
}

class AttendanceRecord {
  final String id;
  final DateTime date;
  final Map<String, AttendanceEntry> attendanceMap; // StudentID -> Entry

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.attendanceMap,
  });

  int get totalPresent => attendanceMap.values
      .where((e) => e.status == AttendanceStatus.present)
      .length;
  int get totalAbsent => attendanceMap.values
      .where((e) => e.status == AttendanceStatus.absent)
      .length;
  int get totalLate => attendanceMap.values
      .where((e) => e.status == AttendanceStatus.late)
      .length;
  int get totalJustified => attendanceMap.values
      .where((e) => e.status == AttendanceStatus.absent && e.isJustified)
      .length;
  int get totalStudents => attendanceMap.length;

  double get attendancePercentage => totalStudents > 0
      ? ((totalPresent + totalLate) / totalStudents) * 100
      : 0;
}
