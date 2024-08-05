import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/car_repository.dart';
import '../cubits/car_cubit.dart';
import '../cubits/car_state.dart';
import 'insert_model.dart';
import 'update_model.dart'; // Asegúrate de importar la pantalla de actualización

class CarListView extends StatelessWidget {
  const CarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
      ),
      body: BlocProvider(
        create: (context) => CarCubit(
          carRepository: RepositoryProvider.of<CarRepository>(context),
        ),
        child: const CarListScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertModel()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Car',
      ),
    );
  }
}

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            carCubit.fetchAllCars();
          },
          child: const Text('Fetch Cars'),
        ),
        Expanded(
          child: BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CarSuccess) {
                final cars = state.cars;
                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Marca')),
                          DataColumn(label: Text('Modelo')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Suspensión')),
                          DataColumn(label: Text('Acciones')), // Nueva columna
                        ],
                        rows: cars.map(
                              (car) => DataRow(
                            cells: [
                              DataCell(Text(car.id?.toString() ?? 'N/A')),
                              DataCell(Text(car.marca)),
                              DataCell(Text(car.modelo)),
                              DataCell(Text(car.tipo)),
                              DataCell(Text(car.suspension)),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateModel(car: car),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm Deletion'),
                                              content: const Text('Are you sure you want to delete this car?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    carCubit.deleteCar(car.id!);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ), // Nueva celda con botones de edición y eliminación
                            ],
                          ),
                        ).toList(),
                      ),
                    ),
                  ),
                );
              } else if (state is CarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Press the button to fetch cars'));
            },
          ),
        ),
      ],
    );
  }
}
