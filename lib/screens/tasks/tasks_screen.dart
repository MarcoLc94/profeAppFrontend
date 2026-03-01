import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/services/task_notifier.dart';
import 'package:profeapp/models/task.dart';
import 'package:profeapp/screens/tasks/create_task_screen.dart';
import 'package:profeapp/screens/tasks/task_detail_screen.dart';
import 'package:profeapp/screens/tasks/grade_student_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskNotifier = Provider.of<TaskNotifier>(context);
    final tasks = taskNotifier.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay tareas creadas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona el botón + para agregar una tarea',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DataTable(
                          columnSpacing: 24,
                          showCheckboxColumn: false,
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFF005E3E).withValues(alpha: 0.05),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Materia',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Tarea',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Vence',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Hora',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: tasks.map((task) {
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected != null && selected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailScreen(task: task),
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                _showTaskOptions(context, task);
                              },
                              cells: [
                                DataCell(Text(task.subject)),
                                DataCell(Text(task.name)),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(task.dueDate),
                                  ),
                                ),
                                DataCell(Text(task.dueTime)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005E3E),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.grade_rounded, color: Colors.orange),
                title: const Text('Calificar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GradeStudentScreen(task: task),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: Colors.blue),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  // Future: Edit task logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: Colors.red),
                title: const Text('Eliminar'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la tarea "${task.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskNotifier>(
                context,
                listen: false,
              ).removeTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Tarea eliminada')));
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
