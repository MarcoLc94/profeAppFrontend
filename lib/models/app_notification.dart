import 'package:intl/intl.dart';

class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime creationDate;
  final DateTime expirationDate;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.expirationDate,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      creationDate: map['creation_date'] != null
          ? DateTime.parse(map['creation_date'])
          : DateTime.now(),
      expirationDate: map['expiration_date'] != null
          ? DateTime.parse(map['expiration_date'])
          : DateTime.now().add(const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creation_date': DateFormat('yyyy-MM-dd HH:mm').format(creationDate),
      'expiration_date': DateFormat('yyyy-MM-dd HH:mm').format(expirationDate),
    };
  }
}
