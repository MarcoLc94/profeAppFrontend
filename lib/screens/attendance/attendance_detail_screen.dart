import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/attendance.dart';
import 'package:profeapp/services/student_notifier.dart';

class AttendanceDetailScreen extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceDetailScreen({super.key, required this.record});

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
            color: const Color(0xFF005E3E).withValues(alpha: 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Presentes',
                  '${record.totalPresent}',
                  Colors.green,
                ),
                _buildStatItem(
                  'Retardos',
                  '${record.totalLate}',
                  Colors.orange,
                ),
                _buildStatItem('Ausentes', '${record.totalAbsent}', Colors.red),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(record.date)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text('No hay información de alumnos'))
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final entry = record.attendanceMap[student.id];

                      if (entry == null) return const SizedBox.shrink();

                      final isPresent =
                          entry.status == AttendanceStatus.present;
                      final isLate = entry.status == AttendanceStatus.late;
                      final isAbsent = entry.status == AttendanceStatus.absent;

                      Color statusColor = Colors.grey;
                      String statusText = '';
                      IconData statusIcon = Icons.help_outline;

                      if (isPresent) {
                        statusColor = Colors.green;
                        statusText = 'Presente';
                        statusIcon = Icons.check_rounded;
                      } else if (isLate) {
                        statusColor = Colors.orange;
                        statusText = 'Retardo';
                        statusIcon = Icons.history_rounded;
                      } else if (isAbsent) {
                        statusColor = Colors.red;
                        statusText = entry.isJustified
                            ? 'Ausente (Justificado)'
                            : 'Ausente';
                        statusIcon = Icons.close_rounded;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withValues(alpha: 0.1),
                            child: Icon(statusIcon, color: statusColor),
                          ),
                          title: Text(
                            student.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
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
