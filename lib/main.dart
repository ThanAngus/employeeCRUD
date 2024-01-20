import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realtime_inno_test/bloc/crud_operation_bloc.dart';
import 'package:realtime_inno_test/bloc/employeeBloc.dart';
import 'package:realtime_inno_test/model/employeeModel.dart';
import 'package:realtime_inno_test/screens/rootPage.dart';
import 'package:realtime_inno_test/utils/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter().whenComplete(() async {
    Hive.registerAdapter(EmployeeModelAdapter());
    Hive.registerAdapter(RolesAdapter());
    await Hive.openBox<EmployeeModel>('employeeBox');
  });
  final box = Hive.box<EmployeeModel>('employeeBox');
  runApp(
    BlocProvider(
      create: (context) => EmployeeBloc(box)..add(LoadEmployees()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Innovation Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        primaryColor: AppColors.primaryColor,
        primarySwatch: const MaterialColor(
          0xFF1A3517,
          <int, Color>{
            50: Color(0xFFeef7ed),
            100: Color(0xFFcde8ca),
            200: Color(0xFFabd8a6),
            300: Color(0xFF8ac983),
            400: Color(0xFF68ba5f),
            500: Color(0xFF4fa045),
            600: Color(0xFF3d7c36),
            700: Color(0xFF2c5927),
            800: Color(0xFF1a3517),
            900: Color(0xFF091208),
          },
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBG,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: AppColors.statusColor,
          ),
        ),
      ),
      home: const RootPage(),
    );
  }
}
