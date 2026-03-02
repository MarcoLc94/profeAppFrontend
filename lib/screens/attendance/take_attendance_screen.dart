import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/group.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/attendance.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/attendance_notifier.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final Group group;
  const TakeAttendanceScreen({super.key, required this.group});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  int _currentIndex = 0;
  final Map<String, AttendanceEntry> _attendanceMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentNotifier>(
        context,
        listen: false,
      ).fetchStudents(int.parse(widget.group.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    if (studentNotifier.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tomar Asistencia')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                currentStudent.fullName,
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
                  _buildAttendanceButton(
                    icon: Icons.close_rounded,
                    label: 'Ausente',
                    color: Colors.red,
                    onTap: () =>
                        _handleAbsent(currentStudent.id, students.length),
                  ),
                  _buildAttendanceButton(
                    icon: Icons.history_rounded,
                    label: 'Retardo',
                    color: Colors.orange,
                    onTap: () => _markAttendance(
                      currentStudent.id,
                      AttendanceEntry(
                        id: '',
                        studentId: currentStudent.id,
                        status: AttendanceStatus.late,
                      ),
                      students.length,
                    ),
                  ),
                  _buildAttendanceButton(
                    icon: Icons.check_rounded,
                    label: 'Presente',
                    color: Colors.green,
                    onTap: () => _markAttendance(
                      currentStudent.id,
                      AttendanceEntry(
                        id: '',
                        studentId: currentStudent.id,
                        status: AttendanceStatus.present,
                      ),
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
              color: color.withOpacity(0.1),
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
                  id: '',
                  studentId: studentId,
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
                  id: '',
                  studentId: studentId,
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

  Future<void> _finishAttendance() async {
    final attendanceNotifier = Provider.of<AttendanceNotifier>(
      context,
      listen: false,
    );

    final List<Map<String, dynamic>> records = _attendanceMap.values
        .map(
          (e) => {
            'student_id': int.parse(e.studentId),
            'status': e.statusValue,
            'is_justified': e.isJustified,
          },
        )
        .toList();

    final now = DateTime.now();
    final timeStr = DateFormat('HH:mm').format(now);

    final success = await attendanceNotifier.addSession(
      int.parse(widget.group.id),
      now,
      timeStr,
      records,
    );

    if (success) {
      _showSuccessDialog();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la asistencia')),
        );
      }
    }
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
