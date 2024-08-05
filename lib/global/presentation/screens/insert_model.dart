import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/car_cubit.dart';
import '../cubits/car_state.dart';
import '../../data/models/car_model.dart';

class InsertModel extends StatefulWidget {
  const InsertModel({super.key});

  @override
  _InsertModelState createState() => _InsertModelState();
}

class _InsertModelState extends State<InsertModel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _suspensionController = TextEditingController();

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _tipoController.dispose();
    _suspensionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final car = CarModel(
        id: 0, // Asigna un ID si es necesario o maneja la asignación en el backend
        marca: _marcaController.text,
        modelo: _modeloController.text,
        tipo: _tipoController.text,
        suspension: _suspensionController.text,
      );

      context.read<CarCubit>().createCar(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transport'),
      ),
      body: BlocListener<CarCubit, CarState>(
        listener: (context, state) {
          if (state is CarLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is CarSuccess) {
            Navigator.pop(context); // Cierra el formulario
            Navigator.pop(context); // Vuelve a la pantalla de la lista
          } else if (state is CarError) {
            Navigator.pop(context); // Cierra el spinner
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la marca';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el modelo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tipoController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el tipo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _suspensionController,
                  decoration: const InputDecoration(labelText: 'Suspensión'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la suspensión';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Car'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
