import 'dart:math';

class Worker {
  final String id;
  final String name;
  final int age;
  final String contactNumber;
  final double wage;

  Worker({
    String? id,
    required this.name,
    required this.age,
    required this.contactNumber,
    required this.wage,
  }) : id = id ?? _generateId();

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
           Random().nextInt(9999).toString();
  }

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      contactNumber: json['contactNumber'] as String,
      wage: (json['wage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'contactNumber': contactNumber,
      'wage': wage,
    };
  }
}
