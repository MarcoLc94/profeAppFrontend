import 'package:flutter/material.dart';
import 'package:profeapp/models/group.dart';

class GroupNotifier extends ChangeNotifier {
  final List<Group> _groups = [];

  List<Group> get groups => List.unmodifiable(_groups);

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }
}
