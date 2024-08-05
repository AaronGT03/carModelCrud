import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/car_cubit.dart';
import '../cubits/car_state.dart';
import '../../data/models/car_model.dart';

class UpdateModel extends StatefulWidget {
  final CarModel car;

  const UpdateModel({super.key, required this.car});

  @override
  _UpdateModelState createState() => _UpdateModelState();
}

class _UpdateModelState extends State<UpdateModel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _marcaController;
  late final TextEditingController _modeloController;
  late final TextEditingController _tipoController;
  late final TextEditingController _suspensionController;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.car.marca);
    _modeloController = TextEditingController(text: widget.car.modelo);
    _tipoController = TextEditingController(text: widget.car.tipo);
    _suspensionController = TextEditingController(text: widget.car.suspension);
  }

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
      final updatedCar = CarModel(
        id: widget.car.id,
        marca: _marcaController.text,
        modelo: _modeloController.text,
        tipo: _tipoController.text,
        suspension: _suspensionController.text,
      );

      context.read<CarCubit>().updateCar(updatedCar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Car'),
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
                  child: const Text('Update Car'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
