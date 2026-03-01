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
            Center(
              child: Icon(
                Icons.assignment_rounded,
                size: 80,
                color: const Color(0xFF005E3E).withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailSection(
              context,
              'Nombre de la Tarea',
              task.name,
              Icons.assignment_outlined,
            ),
            const SizedBox(height: 16),
            _buildDetailSection(
              context,
              'Materia',
              task.subject,
              Icons.book_outlined,
            ),
            const Divider(height: 48),
            Row(
              children: [
                Expanded(
                  child: _buildDetailSection(
                    context,
                    'Fecha de Vencimiento',
                    DateFormat('dd/MM/yyyy').format(task.dueDate),
                    Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailSection(
                    context,
                    'Hora de Vencimiento',
                    task.dueTime,
                    Icons.access_time_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailSection(
              context,
              'Fecha de Creación',
              DateFormat('dd/MM/yyyy HH:mm').format(task.creationDate),
              Icons.create_outlined,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Future edit function
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('EDITAR TAREA'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF005E3E)),
                  foregroundColor: const Color(0xFF005E3E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
