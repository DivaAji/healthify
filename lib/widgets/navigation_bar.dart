import 'package:flutter/material.dart';
import 'package:healthify/screens/history/history_screen.dart';
import 'package:healthify/screens/profile/profile_screen.dart';
import 'package:healthify/screens/home_screen.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  _MyNavigationBar createState() => _MyNavigationBar();
}

class _MyNavigationBar extends State<MyNavigationBar> {
  int _selectedIndex = 0; // Menyimpan index navigasi

  final List<Widget> _pages = [
    const HomeScreen(),
    const WorkoutHistory(),
    const ProfileScreen(),
  ];

  // Menangani perubahan halaman ketika item BottomNavigationBar dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: _pages[_selectedIndex]), // Tampilkan halaman yang dipilih
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromRGBO(0, 139, 144, 1),
          unselectedItemColor: const Color.fromARGB(255, 163, 162, 162),
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: ImageIcon(
                AssetImage('assets/icons/home.png'),
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'History',
              icon: ImageIcon(
                AssetImage('assets/icons/history.png'),
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profil',
              icon: ImageIcon(
                AssetImage('assets/icons/user.png'),
                size: 24,
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ],
    );
  }
}
