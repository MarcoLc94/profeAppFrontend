import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tarea'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF005E3E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.book, color: Color(0xFF005E3E)),
                  const SizedBox(width: 12),
                  Text(
                    task.subject,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005E3E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (task.description.isNotEmpty) ...[
              Text(
                task.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
            ],
            const Divider(),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de Vencimiento',
              DateFormat('dd/MM/yyyy').format(task.dueDate),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.access_time,
              'Hora de Vencimiento',
              task.dueTime,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.add_circle_outline,
              'Fecha de Creación',
              DateFormat('dd/MM/yyyy HH:mm').format(task.creationDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
