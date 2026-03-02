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

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id']?.toString() ?? '',
      names: map['names'] ?? '',
      lastNames: map['last_names'] ?? '',
      age: map['age'] ?? 0,
      sex: map['sex'] ?? '',
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      photoPath: map['photo_url'], // Map photo_url from backend to photoPath
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'names': names,
      'last_names': lastNames,
      'age': age,
      'sex': sex,
      'height': height,
      'weight': weight,
      'photo_url': photoPath,
    };
  }

  String get fullName => '$names $lastNames';
}
