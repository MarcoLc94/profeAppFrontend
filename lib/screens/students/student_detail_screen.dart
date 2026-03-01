import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/services/grade_notifier.dart';
import 'package:profeapp/screens/students/create_student_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(student.fullName),
          backgroundColor: const Color(0xFF005E3E),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateStudentScreen(student: student),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Resumen', icon: Icon(Icons.analytics_outlined)),
              Tab(text: 'Información', icon: Icon(Icons.person_outline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildResumenTab(context), _buildInfoTab(context)],
        ),
      ),
    );
  }

  Widget _buildResumenTab(BuildContext context) {
    final gradeNotifier = Provider.of<GradeNotifier>(context);
    final studentGrades = gradeNotifier.getGradesForStudent(student.id);

    double average = 0;
    if (studentGrades.isNotEmpty) {
      average =
          studentGrades.fold<double>(0, (p, c) => p + c.score) /
          studentGrades.length;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatCard(
                'Promedio',
                average == 0 ? '--' : average.toStringAsFixed(1),
                Icons.grade_rounded,
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Asistencia',
                '95%',
                Icons.how_to_reg_rounded,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Conducta',
            'A',
            Icons.emoji_emotions_outlined,
            Colors.purple,
            fullWidth: true,
          ),
          const SizedBox(height: 32),
          const Text(
            'Calificaciones de Tareas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (studentGrades.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No hay calificaciones registradas',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...studentGrades.map(
              (grade) => _buildActivityItem(
                'Tarea: ${grade.taskName}',
                grade.score.toStringAsFixed(1),
                grade.score >= 6 ? Colors.green : Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: student.photoPath != null
                ? FileImage(File(student.photoPath!))
                : null,
            child: student.photoPath == null
                ? const Icon(Icons.person, size: 80, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nombres', student.names),
                _buildInfoRow('Apellidos', student.lastNames),
                _buildInfoRow('Edad', '${student.age} años'),
                _buildInfoRow(
                  'Sexo',
                  student.sex == 'M' ? 'Masculino' : 'Femenino',
                ),
                _buildInfoRow(
                  'Estatura',
                  student.height != null
                      ? '${student.height} cm'
                      : 'No registrado',
                ),
                _buildInfoRow(
                  'Peso',
                  student.weight != null
                      ? '${student.weight} kg'
                      : 'No registrado',
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const Text(
                  'Notas del Alumno',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No hay notas adicionales para este alumno.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
