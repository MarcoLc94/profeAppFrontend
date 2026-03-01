import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/task.dart';
import 'package:profeapp/models/grade.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/grade_notifier.dart';

class GradeStudentScreen extends StatefulWidget {
  final Task task;

  const GradeStudentScreen({super.key, required this.task});

  @override
  State<GradeStudentScreen> createState() => _GradeStudentScreenState();
}

class _GradeStudentScreenState extends State<GradeStudentScreen> {
  Student? _selectedStudent;
  final _scoreController = TextEditingController();
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedStudent != null) {
      final gradeNotifier = Provider.of<GradeNotifier>(context, listen: false);

      final newGrade = Grade(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskId: widget.task.id,
        taskName: widget.task.name,
        studentId: _selectedStudent!.id,
        studentName: _selectedStudent!.fullName,
        score: double.parse(_scoreController.text),
        comment: _commentController.text,
        date: DateTime.now(),
      );

      gradeNotifier.addGrade(newGrade);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El alumno ${_selectedStudent!.names} ha sido calificado',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un alumno')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<StudentNotifier>(context).students;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificar Tarea'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tarea: ${widget.task.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005E3E),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Seleccionar Alumno:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Student>(
                initialValue: _selectedStudent,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: const Text('Elegir estudiante'),
                items: students.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s.fullName));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedStudent = value);
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _scoreController,
                decoration: const InputDecoration(
                  labelText: 'Calificación',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star_rounded),
                  hintText: 'Ej: 10.0',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (double.tryParse(value) == null)
                    return 'Ingresa un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment_rounded),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005E3E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CALIFICAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
