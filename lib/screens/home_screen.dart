import 'package:flutter/material.dart';
import 'package:profeapp/states/auth_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authNotifier.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, Profe!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF005E3E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¿Qué te gustaría hacer hoy?',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    'Asistencia',
                    Icons.how_to_reg_rounded,
                    Colors.blue,
                  ),
                  _buildDashboardCard(
                    context,
                    'Calificaciones',
                    Icons.grade_rounded,
                    Colors.orange,
                  ),
                  _buildDashboardCard(
                    context,
                    'Reportes',
                    Icons.analytics_outlined,
                    Colors.teal,
                  ),
                  _buildDashboardCard(
                    context,
                    'Planeación',
                    Icons.calendar_month_rounded,
                    Colors.green,
                  ),
                  _buildDashboardCard(
                    context,
                    'Conducta',
                    Icons.emoji_emotions_outlined,
                    Colors.purple,
                  ),
                  _buildDashboardCard(
                    context,
                    'Evidencias',
                    Icons.folder_shared_outlined,
                    Colors.indigo,
                  ),
                  _buildDashboardCard(
                    context,
                    'Recordatorios',
                    Icons.notifications_active_outlined,
                    Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF005E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
