import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proba/features/navigation/presentation/pages/profile/profile_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_not_found_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_found_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_page.dart';
import 'package:proba/features/navigation/presentation/pages/statistics/no_internet_page.dart';
import 'package:proba/features/navigation/presentation/widgets/top_location_bar.dart';
import 'package:proba/utils/elements.dart';
import '../../../../utils/arduino_controller.dart';
import '../blocs/navigation_cubit.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const SensorPage(),
    Elements.hasInternet ? const StatisticsPage() : const NoInternetPage(),
    StatisticsPage(),
    const ProfilePage(
      profileData: {
        'name': 'John Doe',
        'username': '@johndoe',
      },
    ),
  ];

  void checkUsbAttached() {
    Elements.arduinoController = new ArduinoController();
    Elements.arduinoController!.connectToArduino();
  }

  @override
  Widget build(BuildContext context) {
    checkUsbAttached();

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return IndexedStack(
              index: state,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
