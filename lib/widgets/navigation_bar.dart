import 'package:flutter/material.dart';
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/screens/latihan_screen.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  _MyNavigationBar createState() => _MyNavigationBar();
}

class _MyNavigationBar extends State<MyNavigationBar> {
  int _selectedIndex = 0; // Menyimpan index navigasi

  // Pages that correspond to the BottomNavigationBar items
  final List<Widget> _pages = [
    const HomeScreen(),
    const MyLatihan(),
    // Add other pages here like History and Profile if needed
  ];

  // Menangani perubahan halaman ketika item BottomNavigationBar dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // menangani navigasi back, agar kembali ke halaman sebelumnya.
      body: WillPopScope(
        onWillPop: () async {
          // Cek apakah ada halaman sebelumnya di stack atau tidak
          if (_selectedIndex == 0) {
            return true; // Izinkan navigasi back jika di halaman pertama
          } else {
            setState(() {
              _selectedIndex = 0; // Reset ke halaman utama
            });
            return false; // Mencegah menutup aplikasi, dan pergi ke halaman sebelumnya
          }
        },
        child:
            _pages.elementAt(_selectedIndex), // Tampilkan halaman yang dipilih
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(0, 139, 144, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: ImageIcon(
              AssetImage('assets/icons/home.png'),
              size: 24,
            ),
          ),
          // BottomNavigationBarItem(
          //   label: 'Latihan',
          //   icon: ImageIcon(
          //     AssetImage('assets/icons/latihan.png'),
          //     size: 24,
          //   ),
          // ),
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
    );
  }
}
