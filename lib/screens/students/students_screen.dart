import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/screens/students/create_student_screen.dart';
import 'package:profeapp/screens/students/student_detail_screen.dart';

class StudentsScreen extends StatefulWidget {
  final Group group;
  const StudentsScreen({super.key, required this.group});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentNotifier>(
        context,
        listen: false,
      ).fetchStudents(int.parse(widget.group.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnos - ${widget.group.name}'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: studentNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_rounded,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay alumnos registrados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
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
                          showCheckboxColumn: false,
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
                                'Nombres',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Apellidos',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Edad',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Sexo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(students.length, (
                            index,
                          ) {
                            final student = students[index];
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected != null && selected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailScreen(
                                        student: student,
                                        group: widget.group,
                                      ),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(student.names)),
                                DataCell(Text(student.lastNames)),
                                DataCell(Text('${student.age}')),
                                DataCell(
                                  Text(
                                    student.sex == 'M'
                                        ? 'Masculino'
                                        : 'Femenino',
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
              builder: (context) => CreateStudentScreen(group: widget.group),
            ),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Alumno',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
