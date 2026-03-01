import 'package:flutter/material.dart';
import 'package:profeapp/screens/subjects/subject_list_screen.dart';

class SubjectsGradesScreen extends StatelessWidget {
  const SubjectsGradesScreen({super.key});

  final List<Map<String, dynamic>> grades = const [
    {'name': '1ero', 'color': Colors.blue},
    {'name': '2do', 'color': Colors.green},
    {'name': '3ero', 'color': Colors.orange},
    {'name': '4to', 'color': Colors.red},
    {'name': '5to', 'color': Colors.purple},
    {'name': '6to', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias por Grado'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: grades.length,
          itemBuilder: (context, index) {
            final grade = grades[index];
            return _buildGradeCard(context, grade['name'], grade['color']);
          },
        ),
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, String name, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectListScreen(grade: name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                name[0],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
