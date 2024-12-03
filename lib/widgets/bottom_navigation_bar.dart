import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation_cubit.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  static double navbarHeight = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return BottomNavigationBar(
          // selectedIconTheme: ,
          selectedItemColor: Colors.green,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black,
          currentIndex: state,
          onTap: (index) => context.read<NavigationCubit>().selectPage(index),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart, color: Colors.black,),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera, color: Colors.black,),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black,),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.cyanAccent,
        );
      },
    );
  }
}