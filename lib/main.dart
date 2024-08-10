import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/movie_controller.dart';
import 'controllers/theme_controller.dart';
import 'services/movie_services.dart';
import 'screens/home_screen.dart';
import 'screens/detail_movie.dart';
import 'screens/user_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

/// Fungsi utama aplikasi yang menginisialisasi dependensi dan menjalankan
/// aplikasi.
///
/// Inisialisasi dependensi menggunakan GetX dan menjalankan widget `MyApp`.
void main() {
  Get.put(MovieController());
  Get.put(AuthController());
  Get.put(MovieService());
  Get.put(ThemeController());

  runApp(MyApp());
}

/// `MyApp` adalah widget utama aplikasi yang menyediakan konfigurasi tema dan
/// routing untuk aplikasi.
///
/// Widget ini menggunakan `GetMaterialApp` dari GetX untuk manajemen rute dan
/// tema. Menyediakan halaman utama dan rute untuk navigasi aplikasi.
///
/// ### Fungsionalitas:
/// - Mengonfigurasi tema aplikasi berdasarkan status saat ini dari `ThemeController`.
/// - Mengatur rute aplikasi dengan menggunakan `GetPage` untuk navigasi antar layar.
/// - Menonaktifkan tampilan banner debug.
///
/// ### Rute:
/// - `/`: Menampilkan `SplashScreen`.
/// - `/sign_in`: Menampilkan `SignInScreen`.
/// - `/home`: Menampilkan `HomeScreen`.
/// - `/movie/:id`: Menampilkan `MovieDetailScreen` dengan ID film dinamis.
/// - `/profile`: Menampilkan `UserProfileScreen`.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'Movie App',
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/sign_in', page: () => SignInScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(
            name: '/movie/:id',
            page: () {
              final id = Get.parameters['id'];
              return MovieDetailScreen(movieId: int.parse(id!));
            },
          ),
          GetPage(name: '/profile', page: () => UserProfileScreen()),
        ],
        theme: themeController.currentTheme.value,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
