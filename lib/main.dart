import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'global/data/repository/car_repository.dart';
import 'global/presentation/screens/get_all_models.dart';
import 'global/presentation/cubits/car_cubit.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CarRepository(
            apiUrl: 'https://0xrcfmxbw5.execute-api.us-east-1.amazonaws.com/Prod', // Reemplaza con tu URL
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CarCubit(
              carRepository: context.read<CarRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const CarListView(),
        ),
      ),
    );
  }
}

