import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/services/attendance_notifier.dart';
import 'package:profeapp/screens/attendance/take_attendance_screen.dart';
import 'package:profeapp/screens/attendance/attendance_detail_screen.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceNotifier = Provider.of<AttendanceNotifier>(context);
    final records = attendanceNotifier.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 80,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay registros de asistencia',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia una nueva sesión de asistencia',
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
                            const Color(0xFF005E3E).withValues(alpha: 0.05),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                '#',
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
                                'Hora',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Alumnos',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '% Asistencia',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(records.length, (index) {
                            final record = records[index];
                            return DataRow(
                              onSelectChanged: (selected) {
                                // Detailed view on double tap or simple tap?
                                // User requested double click (doble click me aparecerea una lista vertical)
                                // Since DataTable doesn't have double tap directly on DataRow easily without wrapping cell,
                                // I'll use simple tap for now or wrap cell.
                                // Let's use simple tap for convenience or add a gesture detector to the whole row if possible.
                                if (selected != null && selected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttendanceDetailScreen(
                                            record: record,
                                          ),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(Text('${records.length - index}')),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(record.date),
                                  ),
                                ),
                                DataCell(
                                  Text(DateFormat('HH:mm').format(record.date)),
                                ),
                                DataCell(
                                  Text(
                                    '${record.totalPresent + record.totalLate}/${record.totalStudents}',
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${record.attendancePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: record.attendancePercentage >= 80
                                          ? Colors.green
                                          : (record.attendancePercentage >= 60
                                                ? Colors.orange
                                                : Colors.red),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TakeAttendanceScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Asistencia',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
