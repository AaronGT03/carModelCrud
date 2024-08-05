import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String apiUrl;

  CarRepository({required this.apiUrl});

  Future<void> createCar(CarModel car) async {
    final response = await http.post(
      Uri.parse('$apiUrl/insert_model'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create car');
    }
  }

  Future<CarModel> getCar(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get_car/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return CarModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load car');
    }
  }

  Future<void> updateCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update_model'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete_model'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id})
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }
  }

  Future<List<CarModel>> getAllCars() async {
    final response = await http.get(Uri.parse('$apiUrl/get_model'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Modelos'];
      return data.map((json) => CarModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transports');
    }
  }
}
