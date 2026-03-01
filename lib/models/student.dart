class Student {
  final String id;
  final String names;
  final String lastNames;
  final int age;
  final String sex;
  final double? height;
  final double? weight;
  final String? photoPath;

  Student({
    required this.id,
    required this.names,
    required this.lastNames,
    required this.age,
    required this.sex,
    this.height,
    this.weight,
    this.photoPath,
  });

  String get fullName => '$names $lastNames';
}
