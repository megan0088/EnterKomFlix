import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/auth_controller.dart';

/// Layar untuk masuk pengguna dengan username dan password.
///
/// Layar ini memungkinkan pengguna untuk memasukkan kredensial mereka untuk masuk
/// dan memberikan umpan balik visual melalui animasi Lottie dan snackbar.
///
/// Widget `SignInScreen` berisi:
/// - Animasi Lottie yang ditampilkan di bagian atas layar.
/// - Field teks untuk memasukkan username dan password.
/// - Tombol masuk yang memicu proses otentikasi.
///
/// [AuthController] digunakan untuk mengelola proses masuk dan status pengguna.
class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Menampilkan animasi Lottie.
              Lottie.asset(
                'assets/Animation - 1723002189873.json',
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
                fit: BoxFit.fill,
              ),
              SizedBox(height: screenHeight * 0.03),

              /// Menampilkan judul aplikasi di tengah layar.
              Align(
                alignment: Alignment.center,
                child: Text(
                  'EnterKomFlix',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                  textAlign: TextAlign.center, // Aligns text in the center
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              /// Field teks untuk memasukkan username.
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  hintText: 'Masukkan username Anda',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.person,
                      color: Theme.of(context).colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Field teks untuk memasukkan password.
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  hintText: 'Masukkan password Anda',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.lock,
                      color: Theme.of(context).colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.03),

              /// Tombol untuk masuk.
              /// Menampilkan indikator loading saat otentikasi sedang berlangsung.
              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Harap masukkan username dan password',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          try {
                            await authController.signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (authController.isSignedIn.value) {
                              Get.offAllNamed('/home');
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Gagal Masuk',
                              'Terjadi kesalahan. Silakan coba lagi.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Masuk'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
