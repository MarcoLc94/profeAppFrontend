import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:profeapp/screens/students/students_screen.dart';
import 'package:profeapp/screens/attendance/attendance_screen.dart';
import 'package:profeapp/screens/tasks/tasks_screen.dart';
import 'package:profeapp/screens/reports/reports_screen.dart';
import 'package:profeapp/screens/behavior/behavior_screen.dart';
import 'package:profeapp/screens/grades/grades_screen.dart';

class StudentsMenuScreen extends StatelessWidget {
  final Group group;

  const StudentsMenuScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupo ${group.name}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Alumnos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF005E3E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Grado: ${group.grade} • Ciclo: ${group.schoolYear}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Alumnos',
                    Icons.format_list_bulleted_rounded,
                    Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentsScreen(group: group),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Asistencia',
                    Icons.how_to_reg_rounded,
                    Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceScreen(group: group),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Conducta',
                    Icons.emoji_emotions_outlined,
                    Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BehaviorScreen(group: group),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Tareas',
                    Icons.assignment_turned_in_outlined,
                    Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TasksScreen(group: group),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Reporte',
                    Icons.assignment_late_outlined,
                    Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportsScreen(group: group),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Calificaciones',
                    Icons.grade_rounded,
                    Colors.amber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GradesScreen(group: group),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title estará disponible pronto')),
              );
            },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
