class Group {
  final String id;
  final String name;
  final String grade;
  final String schoolYear;

  Group({
    required this.id,
    required this.name,
    required this.grade,
    required this.schoolYear,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      grade: map['grade'] ?? '',
      schoolYear: map['school_year'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'grade': grade, 'school_year': schoolYear};
  }
}
