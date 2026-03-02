import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/report.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/report_notifier.dart';

class CreateReportScreen extends StatefulWidget {
  final Group group;
  const CreateReportScreen({super.key, required this.group});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  Student? _selectedStudent;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedStudent != null) {
      final reportNotifier = Provider.of<ReportNotifier>(
        context,
        listen: false,
      );

      final newReport = Report(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        studentId: _selectedStudent!.id,
        date: DateTime.now(),
      );

      final success = await reportNotifier.addReport(newReport);

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reporte creado para ${_selectedStudent!.names}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear reporte')),
          );
        }
      }
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
        title: const Text('Nuevo Reporte'),
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
              const Text(
                'Seleccionar Alumno:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Student>(
                value: _selectedStudent,
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
                validator: (value) =>
                    value == null ? 'Selecciona un alumno' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título del Reporte',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor ingresa un título'
                    : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del incidente',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor describe el reporte'
                    : null,
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
                  'CREAR REPORTE',
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
