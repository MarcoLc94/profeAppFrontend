import 'package:flutter/material.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/screens/students/create_student_screen.dart';
import 'package:profeapp/screens/students/student_detail_screen.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentNotifier = Provider.of<StudentNotifier>(context);
    final students = studentNotifier.students;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alumnos'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: students.isEmpty
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
                  const SizedBox(height: 8),
                  const Text(
                    'Registra a tu primer alumno',
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
                            DataColumn(
                              label: Text(
                                'Est. (cm)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Peso (kg)',
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
                                      builder: (context) =>
                                          StudentDetailScreen(student: student),
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
                                DataCell(
                                  Text(student.height?.toString() ?? '-'),
                                ),
                                DataCell(
                                  Text(student.weight?.toString() ?? '-'),
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
              builder: (context) => const CreateStudentScreen(),
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
