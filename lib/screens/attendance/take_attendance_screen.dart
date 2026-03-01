import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/attendance.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/attendance_notifier.dart';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  int _currentIndex = 0;
  final Map<String, AttendanceEntry> _attendanceMap = {};

  @override
  Widget build(BuildContext context) {
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    if (students.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tomar Asistencia')),
        body: const Center(child: Text('No hay alumnos para tomar asistencia')),
      );
    }

    final currentStudent = students[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumno ${_currentIndex + 1} de ${students.length}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_pin_rounded,
                size: 100,
                color: Color(0xFF005E3E),
              ),
              const SizedBox(height: 24),
              Text(
                '${currentStudent.names} ${currentStudent.lastNames}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005E3E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Ausente Button
                  _buildAttendanceButton(
                    icon: Icons.close_rounded,
                    label: 'Ausente',
                    color: Colors.red,
                    onTap: () =>
                        _handleAbsent(currentStudent.id, students.length),
                  ),
                  // Retardo Button
                  _buildAttendanceButton(
                    icon: Icons.history_rounded,
                    label: 'Retardo',
                    color: Colors.orange,
                    onTap: () => _markAttendance(
                      currentStudent.id,
                      AttendanceEntry(status: AttendanceStatus.late),
                      students.length,
                    ),
                  ),
                  // Presente Button
                  _buildAttendanceButton(
                    icon: Icons.check_rounded,
                    label: 'Presente',
                    color: Colors.green,
                    onTap: () => _markAttendance(
                      currentStudent.id,
                      AttendanceEntry(status: AttendanceStatus.present),
                      students.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(icon, color: color, size: 36),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _handleAbsent(String studentId, int totalStudents) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Falta Detectada'),
        content: const Text('¿La falta de este alumno está justificada?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _markAttendance(
                studentId,
                AttendanceEntry(
                  status: AttendanceStatus.absent,
                  isJustified: false,
                ),
                totalStudents,
              );
            },
            child: const Text(
              'NO JUSTIFICADA',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _markAttendance(
                studentId,
                AttendanceEntry(
                  status: AttendanceStatus.absent,
                  isJustified: true,
                ),
                totalStudents,
              );
            },
            child: const Text(
              'JUSTIFICADA',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _markAttendance(
    String studentId,
    AttendanceEntry entry,
    int totalStudents,
  ) {
    _attendanceMap[studentId] = entry;

    if (_currentIndex < totalStudents - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishAttendance();
    }
  }

  void _finishAttendance() {
    final attendanceNotifier = Provider.of<AttendanceNotifier>(
      context,
      listen: false,
    );

    final record = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      attendanceMap: Map.from(_attendanceMap),
    );

    attendanceNotifier.addRecord(record);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Asistencia Completada'),
        content: const Text(
          'Se ha generado el registro de asistencia correctamente.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              Navigator.pop(context); // Pop TakeAttendanceScreen
            },
            child: const Text('ACEPTAR'),
          ),
        ],
      ),
    );
  }
}
