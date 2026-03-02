import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/services/attendance_notifier.dart';
import 'package:profeapp/screens/attendance/take_attendance_screen.dart';
import 'package:profeapp/screens/attendance/attendance_detail_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final Group group;
  const AttendanceScreen({super.key, required this.group});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceNotifier>(
        context,
        listen: false,
      ).fetchSessions(int.parse(widget.group.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceNotifier = Provider.of<AttendanceNotifier>(context);
    final sessions = attendanceNotifier.sessions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia - ${widget.group.name}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: attendanceNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
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
                            const Color(0xFF005E3E).withOpacity(0.05),
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
                          rows: List<DataRow>.generate(sessions.length, (
                            index,
                          ) {
                            final session = sessions[index];
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected != null && selected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttendanceDetailScreen(
                                            session: session,
                                          ),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(session.date),
                                  ),
                                ),
                                DataCell(Text(session.time)),
                                DataCell(
                                  Text(
                                    '${session.totalPresent + session.totalLate}/${session.totalStudents}',
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${session.attendancePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: session.attendancePercentage >= 80
                                          ? Colors.green
                                          : (session.attendancePercentage >= 60
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
              builder: (context) => TakeAttendanceScreen(group: widget.group),
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
