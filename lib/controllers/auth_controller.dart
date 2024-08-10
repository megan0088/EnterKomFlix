import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mengelola status autentikasi pengguna dan menyediakan metode untuk masuk dan keluar.
class AuthController extends GetxController {
  /// Menunjukkan apakah pengguna telah masuk.
  var isSignedIn = false.obs;

  /// Menyimpan nama pengguna dari pengguna yang telah masuk.
  var userName = ''.obs;

  /// Menunjukkan apakah proses autentikasi sedang memuat.
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Memuat data pengguna dari shared preferences.
  ///
  /// Mengambil status masuk dan nama pengguna dari shared preferences dan
  /// memperbarui variabel observasi yang sesuai.
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    isSignedIn.value = prefs.getBool('isSignedIn') ?? false;
    userName.value = prefs.getString('userName') ?? '';
  }

  /// Masuk dengan [email] dan [password] yang diberikan.
  ///
  /// Mensimulasikan proses autentikasi dengan penundaan selama 2 detik. Jika
  /// berhasil, memperbarui status masuk dan nama pengguna, serta menyimpan
  /// nilai-nilai ini dalam shared preferences.
  ///
  /// [email] - Alamat email pengguna.
  /// [password] - Kata sandi pengguna.
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      // Mensimulasikan penundaan autentikasi
      await Future.delayed(Duration(seconds: 2));

      isSignedIn.value = true;
      userName.value = email;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', isSignedIn.value);
      await prefs.setString('userName', userName.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Keluar dari pengguna yang saat ini masuk.
  ///
  /// Menghapus status masuk dan nama pengguna, serta menghapus nilai-nilai ini
  /// dari shared preferences.
  Future<void> signOut() async {
    isSignedIn.value = false;
    userName.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isSignedIn');
    await prefs.remove('userName');
  }
}
