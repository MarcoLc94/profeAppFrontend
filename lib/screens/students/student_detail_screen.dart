import 'dart:io';
import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:profeapp/services/task_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/models/behavior_entry.dart';
import 'package:profeapp/models/report.dart';
import 'package:profeapp/services/grade_notifier.dart';
import 'package:profeapp/services/behavior_notifier.dart';
import 'package:profeapp/services/report_notifier.dart';
import 'package:profeapp/screens/students/create_student_screen.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;
  final Group group;

  const StudentDetailScreen({
    super.key,
    required this.student,
    required this.group,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentId = int.parse(widget.student.id);
      Provider.of<GradeNotifier>(
        context,
        listen: false,
      ).fetchGradesForStudent(studentId);
      Provider.of<BehaviorNotifier>(
        context,
        listen: false,
      ).fetchEntriesForStudent(studentId);
      Provider.of<ReportNotifier>(
        context,
        listen: false,
      ).fetchReportsForStudent(studentId);
      // Ensure tasks are loaded for name lookups
      Provider.of<TaskNotifier>(
        context,
        listen: false,
      ).fetchTasks(int.parse(widget.group.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.student.fullName),
          backgroundColor: const Color(0xFF005E3E),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateStudentScreen(
                      group: widget.group,
                      student: widget.student,
                    ),
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
    final behaviorNotifier = Provider.of<BehaviorNotifier>(context);
    final taskNotifier = Provider.of<TaskNotifier>(context);

    final studentGrades = gradeNotifier.getGradesForStudent(widget.student.id);
    final behaviorEntries = behaviorNotifier.getEntriesForStudent(
      widget.student.id,
    );
    final tasks = taskNotifier.tasks;

    double averageScore = 0;
    if (studentGrades.isNotEmpty) {
      averageScore =
          studentGrades.fold<double>(0, (p, c) => p + c.score) /
          studentGrades.length;
    }

    double behaviorGrade = 10.0;
    for (var entry in behaviorEntries) {
      if (entry.type == BehaviorType.negative) behaviorGrade -= 0.5;
      if (entry.type == BehaviorType.positive) behaviorGrade += 0.2;
    }
    behaviorGrade = behaviorGrade.clamp(0, 10);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatCard(
                'Promedio',
                averageScore == 0 ? '--' : averageScore.toStringAsFixed(1),
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
            behaviorGrade.toStringAsFixed(1),
            Icons.emoji_emotions_outlined,
            _getBehaviorColor(behaviorGrade),
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
            ...studentGrades.map((grade) {
              final task = tasks.cast<dynamic>().firstWhere(
                (t) => t.id == grade.taskId,
                orElse: () => null,
              );
              return _buildActivityItem(
                'Tarea: ${task?.title ?? 'ID: ${grade.taskId}'}',
                grade.score.toStringAsFixed(1),
                grade.score >= 6 ? Colors.green : Colors.red,
              );
            }),
          const SizedBox(height: 24),
          const Text(
            'Últimas Observaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (behaviorEntries.isEmpty)
            const Text(
              'Sin observaciones recientes',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...behaviorEntries
                .take(3)
                .map(
                  (e) => _buildActivityItem(
                    e.description,
                    _getBehaviorLabel(e.type),
                    _getBehaviorTypeColor(e.type),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    final reportNotifier = Provider.of<ReportNotifier>(context);
    final studentReports = reportNotifier.getReportsForStudent(
      widget.student.id,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                widget.student.photoPath != null &&
                    widget.student.photoPath!.startsWith('/')
                ? FileImage(File(widget.student.photoPath!))
                : null,
            child: widget.student.photoPath == null
                ? const Icon(Icons.person, size: 80, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nombres', widget.student.names),
                _buildInfoRow('Apellidos', widget.student.lastNames),
                _buildInfoRow('Edad', '${widget.student.age} años'),
                _buildInfoRow(
                  'Sexo',
                  widget.student.sex == 'M' ? 'Masculino' : 'Femenino',
                ),
                _buildInfoRow(
                  'Estatura',
                  widget.student.height != null
                      ? '${widget.student.height} cm'
                      : 'No registrado',
                ),
                _buildInfoRow(
                  'Peso',
                  widget.student.weight != null
                      ? '${widget.student.weight} kg'
                      : 'No registrado',
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                const Text(
                  'Reportes Formales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (studentReports.isEmpty)
                  const Text(
                    'No hay reportes para este alumno.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...studentReports.map(
                    (r) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(r.title),
                        subtitle: Text(DateFormat('dd/MM/yyyy').format(r.date)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _showReportDetail(context, r),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetail(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(report.date)}'),
            const Divider(height: 24),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(report.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
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
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
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
            color: color.withOpacity(0.1),
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getBehaviorColor(double score) {
    if (score >= 9) return Colors.green;
    if (score >= 7) return Colors.orange;
    return Colors.red;
  }

  String _getBehaviorLabel(BehaviorType type) {
    switch (type) {
      case BehaviorType.positive:
        return 'Positiva';
      case BehaviorType.negative:
        return 'Negativa';
      case BehaviorType.neutral:
        return 'Neutral';
    }
  }

  Color _getBehaviorTypeColor(BehaviorType type) {
    switch (type) {
      case BehaviorType.positive:
        return Colors.green;
      case BehaviorType.negative:
        return Colors.red;
      case BehaviorType.neutral:
        return Colors.grey;
    }
  }
}
