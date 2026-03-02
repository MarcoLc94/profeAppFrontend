import 'package:flutter/material.dart';
import 'package:profeapp/services/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:profeapp/services/notification_notifier.dart';
import 'package:profeapp/screens/notifications/create_notification_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthNotifier>(context, listen: false).user;
      if (user != null) {
        Provider.of<NotificationNotifier>(
          context,
          listen: false,
        ).fetchNotifications(int.parse(user.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<NotificationNotifier>(
        builder: (context, notifier, child) {
          final notifications = notifier.notifications;

          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No hay notificaciones registradas.\nPulsa + para añadir una.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFF5F5F5),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Título',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Creación',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Expiración',
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
                    rows: notifications.map((n) {
                      return DataRow(
                        cells: [
                          DataCell(Text(n.title)),
                          DataCell(
                            Text(
                              DateFormat('dd/MM/yyyy').format(n.creationDate),
                            ),
                          ),
                          DataCell(
                            Text(
                              DateFormat('dd/MM/yyyy').format(n.expirationDate),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF005E3E),
                              ),
                              onPressed: () => _showNotificationDetail(
                                context,
                                n.title,
                                n.description,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNotificationScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showNotificationDetail(
    BuildContext context,
    String title,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
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
