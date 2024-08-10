import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/auth_controller.dart'; // Import AuthController
import '../controllers/theme_controller.dart'; // Import ThemeController
import '../widget/bottom_navigation_bar.dart'; // Import BottomNavBar

/// Layar Profil Pengguna untuk menampilkan informasi pengguna,
/// daftar tonton, dan film favorit.
///
/// Layar ini menggunakan `GetX` untuk manajemen status dan menyediakan
/// opsi untuk beralih tema aplikasi. Juga menampilkan navigasi bawah
/// di bagian bawah layar.
///
/// ### Fungsionalitas:
/// - Menampilkan informasi pengguna seperti nama pengguna.
/// - Menampilkan daftar film yang ditonton dan film favorit.
/// - Menyediakan opsi untuk menghapus film dari daftar tonton atau favorit.
/// - Menyediakan tombol untuk beralih antara tema gelap dan terang.
/// - Menampilkan `BottomNavBar` di bagian bawah layar.
class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find();
    final AuthController authController =
        Get.find(); // Mengakses AuthController
    final ThemeController themeController =
        Get.find(); // Mengakses ThemeController

    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
        ],
      ),
      body: Obx(() {
        final watchlist = movieController.watchlist;
        final favorites = movieController.favorites;
        final username = authController.userName.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Informasi Pengguna
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                width: screenWidth, // Membuat kontainer mengambil lebar penuh
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Pengguna',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.06, // Menyesuaikan ukuran font berdasarkan lebar layar
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Username: $username',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.04, // Menyesuaikan ukuran font berdasarkan lebar layar
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),

              // Bagian Daftar Tonton
              Text(
                'Daftar Tonton',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.05, // Menyesuaikan ukuran font berdasarkan lebar layar
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              if (watchlist.isEmpty)
                Center(
                  child: Text(
                    'Tidak ada film di daftar tonton.',
                    style: TextStyle(
                        fontSize:
                            screenWidth * 0.04), // Menyesuaikan ukuran font
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];
                    return ListTile(
                      leading: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: screenWidth *
                            0.15, // Menyesuaikan lebar gambar berdasarkan lebar layar
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(
                            fontSize:
                                screenWidth * 0.04), // Menyesuaikan ukuran font
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          movieController.watchlist.remove(movie);
                        },
                      ),
                    );
                  },
                ),
              SizedBox(height: 16.0),

              // Bagian Favorit
              Text(
                'Favorit',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.05, // Menyesuaikan ukuran font berdasarkan lebar layar
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              if (favorites.isEmpty)
                Center(
                  child: Text(
                    'Tidak ada film favorit.',
                    style: TextStyle(
                        fontSize:
                            screenWidth * 0.04), // Menyesuaikan ukuran font
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final movie = favorites[index];
                    return ListTile(
                      leading: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: screenWidth *
                            0.15, // Menyesuaikan lebar gambar berdasarkan lebar layar
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(
                            fontSize:
                                screenWidth * 0.04), // Menyesuaikan ukuran font
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          movieController.favorites.remove(movie);
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(), // Menambahkan BottomNavBar di sini
    );
  }
}
