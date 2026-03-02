import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/models/behavior_entry.dart';
import 'package:profeapp/models/student.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/behavior_notifier.dart';

class KeepBehaviorScreen extends StatefulWidget {
  final Group group;
  const KeepBehaviorScreen({super.key, required this.group});

  @override
  State<KeepBehaviorScreen> createState() => _KeepBehaviorScreenState();
}

class _KeepBehaviorScreenState extends State<KeepBehaviorScreen> {
  final _formKey = GlobalKey<FormState>();
  Student? _selectedStudent;
  BehaviorType _selectedType = BehaviorType.neutral;
  final _descriptionController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedStudent != null) {
      final behaviorNotifier = Provider.of<BehaviorNotifier>(
        context,
        listen: false,
      );

      final newEntry = BehaviorEntry(
        id: '',
        studentId: _selectedStudent!.id,
        type: _selectedType,
        description: _descriptionController.text.trim(),
        date: DateTime.now(),
      );

      final success = await behaviorNotifier.addEntry(newEntry);

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Conducta registrada para ${_selectedStudent!.names}',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar conducta')),
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
        title: const Text('Registrar Conducta'),
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
              const Text(
                'Tipo de Conducta:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTypeButton(
                    BehaviorType.positive,
                    Icons.add_reaction_outlined,
                    Colors.green,
                    'Positiva',
                  ),
                  _buildTypeButton(
                    BehaviorType.neutral,
                    Icons.sentiment_neutral_outlined,
                    Colors.grey,
                    'Neutral',
                  ),
                  _buildTypeButton(
                    BehaviorType.negative,
                    Icons.sentiment_very_dissatisfied_outlined,
                    Colors.red,
                    'Negativa',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción / Observaciones',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor describe la conducta'
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
                  'REGISTRAR CONDUCTA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    BehaviorType type,
    IconData icon,
    Color color,
    String label,
  ) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
