class CarModel {
  final int? id;
  final String marca;
  final String modelo;
  final String tipo;
  final String suspension;

  // Constructor del objeto
  CarModel({
    this.id,
    required this.marca,
    required this.modelo,
    required this.tipo,
    required this.suspension,
  });

  // Método para convertir el objeto JSON a un CarModel
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipo: json['tipo'],
      suspension: json['suspension'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'tipo': tipo,
      'suspension': suspension,
    };
  }
}
