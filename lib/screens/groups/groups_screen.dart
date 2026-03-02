import 'package:flutter/material.dart';
import 'package:profeapp/services/group_notifier.dart';
import 'package:provider/provider.dart';
import 'package:profeapp/services/auth_notifier.dart';
import 'package:profeapp/screens/groups/create_group_screen.dart';
import 'package:profeapp/screens/students/students_menu_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthNotifier>(context, listen: false).user;
      if (user != null) {
        Provider.of<GroupNotifier>(
          context,
          listen: false,
        ).fetchGroups(int.parse(user.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context);
    final groups = groupNotifier.groups;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Grupos'),
        backgroundColor: const Color(0xFF005E3E),
        foregroundColor: Colors.white,
      ),
      body: groupNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_off_rounded,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aún no tienes grupos creados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crea tu primer grupo para comenzar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF005E3E).withOpacity(0.1),
                      child: Text(
                        group.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF005E3E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('${group.grade} • ${group.schoolYear}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentsMenuScreen(group: group),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
          );
        },
        backgroundColor: const Color(0xFF005E3E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Crear Grupo', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
