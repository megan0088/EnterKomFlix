import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

/// Layar Splash untuk menampilkan animasi saat aplikasi dimulai.
///
/// Layar ini menunjukkan animasi Lottie selama beberapa detik dan kemudian
/// secara otomatis menavigasi pengguna ke layar masuk.
///
/// [SplashScreen] adalah layar pertama yang muncul saat aplikasi diluncurkan,
/// dan digunakan untuk memberikan kesan awal yang menarik sambil memuat
/// sumber daya aplikasi.
///
/// ### Fungsionalitas:
/// - Menampilkan animasi Lottie di tengah layar.
/// - Menavigasi ke layar masuk setelah 4 detik.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  /// Menavigasi ke layar masuk setelah penundaan waktu.
  ///
  /// Menggunakan [Future.delayed] untuk menunggu selama 4 detik sebelum
  /// melakukan navigasi ke '/sign_in'.
  _navigateToSignIn() async {
    await Future.delayed(Duration(seconds: 4), () {});
    Get.offNamed('/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/Animation - 1723085307955.json',
          width: screenWidth * 0.5,
          height: screenHeight * 0.5,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
