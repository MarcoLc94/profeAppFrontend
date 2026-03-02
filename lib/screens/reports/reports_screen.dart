import 'package:flutter/material.dart';
import 'package:profeapp/models/report.dart';
import 'package:profeapp/models/group.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/services/report_notifier.dart';
import 'package:profeapp/screens/reports/create_report_screen.dart';

class ReportsScreen extends StatefulWidget {
  final Group group;
  const ReportsScreen({super.key, required this.group});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportNotifier>(
        context,
        listen: false,
      ).fetchReportsForGroup(int.parse(widget.group.id));
      // Ensure students are loaded for name lookups
      Provider.of<StudentNotifier>(
        context,
        listen: false,
      ).fetchStudents(int.parse(widget.group.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportNotifier = Provider.of<ReportNotifier>(context);
    final studentNotifier = Provider.of<StudentNotifier>(context);

    final reports = reportNotifier.reports;
    final students = studentNotifier.students;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes - ${widget.group.name}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: reportNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay reportes registrados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Presiona + para crear un nuevo reporte',
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
                                'Título',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Fecha',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Acciones',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: reports.map((report) {
                            final student = students.cast<dynamic>().firstWhere(
                              (s) => s.id == report.studentId,
                              orElse: () => null,
                            );
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    student?.fullName ??
                                        'ID: ${report.studentId}',
                                  ),
                                ),
                                DataCell(Text(report.title)),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(report.date),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility_outlined,
                                      color: Color(0xFF005E3E),
                                    ),
                                    onPressed: () {
                                      _showReportDetail(
                                        context,
                                        report,
                                        student?.fullName ??
                                            'ID: ${report.studentId}',
                                      );
                                    },
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
              builder: (context) => CreateReportScreen(group: widget.group),
            ),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showReportDetail(
    BuildContext context,
    Report report,
    String studentName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alumno: $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
}
