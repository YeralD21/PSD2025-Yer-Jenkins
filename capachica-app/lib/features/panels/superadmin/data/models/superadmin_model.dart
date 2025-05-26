class SuperAdmin {
  final String id;
  final String name;
  final String email;

  SuperAdmin({required this.id, required this.name, required this.email});

  factory SuperAdmin.fromJson(Map<String, dynamic> json) => SuperAdmin(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );
}