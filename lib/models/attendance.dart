import 'package:profeapp/models/student.dart';

enum AttendanceStatus { present, absent, late }

class AttendanceEntry {
  final String id;
  final String studentId;
  final AttendanceStatus status;
  final bool isJustified;

  AttendanceEntry({
    required this.id,
    required this.studentId,
    required this.status,
    this.isJustified = false,
  });

  factory AttendanceEntry.fromMap(Map<String, dynamic> map) {
    return AttendanceEntry(
      id: map['id']?.toString() ?? '',
      studentId: map['student_id']?.toString() ?? '',
      status: _parseStatus(map['status']),
      isJustified: map['is_justified'] ?? false,
    );
  }

  static AttendanceStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      case 'present':
      default:
        return AttendanceStatus.present;
    }
  }

  String get statusValue {
    switch (status) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.late:
        return 'late';
    }
  }
}

class AttendanceSession {
  final String id;
  final DateTime date;
  final String time;
  final List<AttendanceEntry> records;

  AttendanceSession({
    required this.id,
    required this.date,
    required this.time,
    required this.records,
  });

  factory AttendanceSession.fromMap(Map<String, dynamic> map) {
    return AttendanceSession(
      id: map['id']?.toString() ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'] ?? '',
      records: (map['attendance_records'] as List? ?? [])
          .map((r) => AttendanceEntry.fromMap(r))
          .toList(),
    );
  }

  // Helper for UI statistics
  int get totalPresent =>
      records.where((e) => e.status == AttendanceStatus.present).length;
  int get totalAbsent =>
      records.where((e) => e.status == AttendanceStatus.absent).length;
  int get totalLate =>
      records.where((e) => e.status == AttendanceStatus.late).length;
  int get totalJustified => records
      .where((e) => e.status == AttendanceStatus.absent && e.isJustified)
      .length;
  int get totalStudents => records.length;

  double get attendancePercentage => totalStudents > 0
      ? ((totalPresent + totalLate) / totalStudents) * 100
      : 0;
}
