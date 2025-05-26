class Emprendedor {
  final String id;
  final String name;
  final String businessName;

  Emprendedor({required this.id, required this.name, required this.businessName});

  factory Emprendedor.fromJson(Map<String, dynamic> json) => Emprendedor(
    id: json['id'],
    name: json['name'],
    businessName: json['businessName'],
  );
}