import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proba/features/navigation/presentation/pages/profile/profile_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_not_found_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_found_page.dart';
import 'package:proba/features/navigation/presentation/widgets/top_location_bar.dart';
import 'package:proba/utils/elements.dart';
import '../blocs/navigation_cubit.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    Elements.arduinoController?.readyNotifier.subscribe((ready) {
      _pages[0] = ready ? const SensorFoundPage() : const SensorNotFoundPage();
      // openSensorFoundPage(context);
      setState(() {

      });
    });

    _pages = [
      Elements.hasUsb ? const SensorFoundPage() : const SensorNotFoundPage(),
      StatisticsPage(),
      StatisticsPage(),
      const ProfilePage(
        profileData: {
          'name': 'John Doe',
          'username': '@johndoe',
        },
      ),
    ];

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
