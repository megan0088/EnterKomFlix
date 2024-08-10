import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// `BottomNavBar` adalah widget navigasi bawah yang digunakan untuk
/// berpindah antara layar utama dan profil pengguna.
///
/// Widget ini menggunakan `BottomNavigationBar` untuk menampilkan dua
/// item navigasi: Home dan Profile. Memiliki efek bayangan di bawahnya
/// dan sudut yang melengkung di bagian atas.
///
/// ### Fungsionalitas:
/// - Menyediakan dua item navigasi: Home dan Profile.
/// - Menyesuaikan indeks item yang dipilih berdasarkan rute saat ini.
/// - Mengarahkan pengguna ke rute yang sesuai saat item navigasi dipilih.
///
/// ### Desain:
/// - Menggunakan `BoxDecoration` untuk memberikan warna latar belakang putih,
///   bayangan, dan sudut melengkung di bagian atas.
/// - Menggunakan `ClipRRect` untuk menerapkan sudut melengkung pada `BottomNavigationBar`.
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _getCurrentIndex(context),
          onTap: (index) {
            if (index == 0) {
              Get.toNamed('/home');
            } else if (index == 1) {
              Get.toNamed('/profile');
            }
          },
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  /// Mendapatkan indeks item yang dipilih berdasarkan rute saat ini.
  ///
  /// - Parameter: `context` konteks build untuk mendapatkan rute saat ini.
  /// - Mengembalikan indeks item navigasi saat ini: 0 untuk Home dan 1 untuk Profile.
  int _getCurrentIndex(BuildContext context) {
    final routeName = Get.currentRoute;
    if (routeName == '/home') {
      return 0;
    } else if (routeName == '/profile') {
      return 1;
    }
    return 0;
  }
}
