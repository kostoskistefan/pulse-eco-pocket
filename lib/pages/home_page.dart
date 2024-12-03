import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_eco_pocket/utils/elements.dart';
import 'package:pulse_eco_pocket/blocs/navigation_cubit.dart';
import 'package:pulse_eco_pocket/pages/sensor/sensor_page.dart';
import 'package:pulse_eco_pocket/pages/camera/camera_page.dart';
import 'package:pulse_eco_pocket/pages/profile/profile_page.dart';
import 'package:pulse_eco_pocket/widgets/bottom_navigation_bar.dart';
import 'package:pulse_eco_pocket/pages/statistics/statistics_page.dart';
import 'package:pulse_eco_pocket/pages/statistics/no_internet_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const SensorPage(),
    Elements.hasInternet ? const StatisticsPage() : const NoInternetPage(),
    CameraPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
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
