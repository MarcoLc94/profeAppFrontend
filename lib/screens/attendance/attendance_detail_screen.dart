import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/attendance.dart';
import 'package:profeapp/services/student_notifier.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceSession session;

  const AttendanceDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Asistencia'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF005E3E).withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Presentes',
                  '${session.totalPresent}',
                  Colors.green,
                ),
                _buildStatItem(
                  'Retardos',
                  '${session.totalLate}',
                  Colors.orange,
                ),
                _buildStatItem(
                  'Ausentes',
                  '${session.totalAbsent}',
                  Colors.red,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Fecha: ${DateFormat('dd/MM/yyyy').format(session.date)} ${session.time}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: session.records.isEmpty
                ? const Center(child: Text('No hay registros en esta sesión'))
                : ListView.builder(
                    itemCount: session.records.length,
                    itemBuilder: (context, index) {
                      final entry = session.records[index];
                      // Find student name from notifier or fallback to ID
                      final student = students.cast<dynamic>().firstWhere(
                        (s) => s.id == entry.studentId,
                        orElse: () => null,
                      );

                      final studentName =
                          student?.fullName ?? 'Alumno ID: ${entry.studentId}';

                      Color statusColor = Colors.grey;
                      String statusText = '';
                      IconData statusIcon = Icons.help_outline;

                      switch (entry.status) {
                        case AttendanceStatus.present:
                          statusColor = Colors.green;
                          statusText = 'Presente';
                          statusIcon = Icons.check_rounded;
                          break;
                        case AttendanceStatus.late:
                          statusColor = Colors.orange;
                          statusText = 'Retardo';
                          statusIcon = Icons.history_rounded;
                          break;
                        case AttendanceStatus.absent:
                          statusColor = Colors.red;
                          statusText = entry.isJustified
                              ? 'Ausente (Justificado)'
                              : 'Ausente';
                          statusIcon = Icons.close_rounded;
                          break;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withOpacity(0.1),
                            child: Icon(statusIcon, color: statusColor),
                          ),
                          title: Text(
                            studentName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
