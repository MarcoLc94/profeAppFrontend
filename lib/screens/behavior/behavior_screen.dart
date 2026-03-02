import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/models/behavior_entry.dart';
import 'package:profeapp/services/behavior_notifier.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/screens/behavior/keep_behavior_screen.dart';

class BehaviorScreen extends StatefulWidget {
  final Group group;
  const BehaviorScreen({super.key, required this.group});

  @override
  State<BehaviorScreen> createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends State<BehaviorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groupId = int.parse(widget.group.id);
      Provider.of<BehaviorNotifier>(
        context,
        listen: false,
      ).fetchEntriesForGroup(groupId);
      Provider.of<StudentNotifier>(
        context,
        listen: false,
      ).fetchStudents(groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final behaviorNotifier = Provider.of<BehaviorNotifier>(context);
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    // Filter entries for students in this group
    final entries = behaviorNotifier.entries
        .where((e) => students.any((s) => s.id == e.studentId))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Conducta - ${widget.group.name}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: behaviorNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay registros de conducta',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona + para registrar una conducta',
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
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFF005E3E).withOpacity(0.05),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Alumno',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Tipo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Descripción',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Fecha',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: entries.map((entry) {
                            final student = students.cast<dynamic>().firstWhere(
                              (s) => s.id == entry.studentId,
                              orElse: () => null,
                            );
                            final studentName =
                                student?.fullName ?? 'ID: ${entry.studentId}';

                            return DataRow(
                              cells: [
                                DataCell(Text(studentName)),
                                DataCell(_buildTypeChip(entry.type)),
                                DataCell(
                                  Text(
                                    entry.description,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(entry.date),
                                  ),
                                ),
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
            MaterialPageRoute(
              builder: (context) => KeepBehaviorScreen(group: widget.group),
            ),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTypeChip(BehaviorType type) {
    Color color;
    String label;
    IconData icon;

    switch (type) {
      case BehaviorType.positive:
        color = Colors.green;
        label = 'Positiva';
        icon = Icons.add_circle_outline;
        break;
      case BehaviorType.negative:
        color = Colors.red;
        label = 'Negativa';
        icon = Icons.remove_circle_outline;
        break;
      case BehaviorType.neutral:
        color = Colors.grey;
        label = 'Neutral';
        icon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
