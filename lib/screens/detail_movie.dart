import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:movie_app/widget/custom_icon_button.dart';

/// Layar yang menampilkan detail film termasuk poster, judul, deskripsi,
/// dan film serupa. Menggunakan `MovieController` untuk mengambil data film
/// dan mengelola status tampilan.
class MovieDetailScreen extends StatelessWidget {
  /// ID film yang akan ditampilkan detailnya.
  final int movieId;

  /// Membuat instance `MovieDetailScreen` dengan ID film yang diperlukan.
  ///
  /// [movieId] - ID film yang akan ditampilkan detailnya.
  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find();

    // Memanggil metode untuk mengambil detail film dan film serupa
    // setelah frame pertama dirender.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController.fetchMovieDetails(movieId);
      movieController.fetchSimilarMovies(movieId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        actions: [
          Obx(() {
            final movie = movieController.movie.value;
            final isInWatchlist =
                movie != null && movieController.watchlist.contains(movie);
            final isFavorite =
                movie != null && movieController.favorites.contains(movie);

            return Row(
              children: [
                CustomIconButton(
                  isActive: isInWatchlist,
                  activeIcon: Icons.remove_circle,
                  inactiveIcon: Icons.add_circle,
                  onPressed: () {
                    if (movie != null) {
                      if (isInWatchlist) {
                        movieController.removeFromWatchlist(movie);
                        Get.snackbar('Removed', 'Movie removed from watchlist');
                      } else {
                        movieController.addToWatchlist(movie);
                        Get.snackbar('Added', 'Movie added to watchlist');
                      }
                    }
                  },
                ),
                CustomIconButton(
                  isActive: isFavorite,
                  activeIcon: Icons.favorite,
                  inactiveIcon: Icons.favorite_border,
                  onPressed: () {
                    if (movie != null) {
                      if (isFavorite) {
                        movieController.removeFromFavorite(movie);
                        Get.snackbar('Removed', 'Movie removed from favorites');
                      } else {
                        movieController.addToFavorite(movie);
                        Get.snackbar('Added', 'Movie added to favorites');
                      }
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () async {
                    final movie = movieController.movie.value;
                    if (movie != null) {
                      final imageUrl =
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}';
                      final fileName = movie.posterPath.split('/').last;
                      await movieController.saveImageToLocal(
                          imageUrl, fileName);
                    } else {
                      Get.snackbar('Error', 'No movie data available');
                    }
                  },
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        // Menampilkan indikator pemuatan jika data sedang dimuat
        if (movieController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final movie = movieController.movie.value;

        // Menampilkan pesan error jika tidak ada data film
        if (movie == null) {
          return Center(
              child: Text(
                  'Error: ${movieController.errorMovieDetails.value ?? "No movie data available"}'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isSmallScreen ? 200 : 300,
                    width: double.infinity,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      movie.overview,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Similar Movies',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() {
                    // Menampilkan indikator pemuatan untuk film serupa
                    if (movieController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Menampilkan pesan error jika tidak ada data film serupa
                    if (movieController.errorSimilarMovies.value != null) {
                      return Center(
                          child: Text(
                              'Error: ${movieController.errorSimilarMovies.value}'));
                    }

                    final similarMovies = movieController.similarMovies;

                    return Container(
                      height: isSmallScreen ? 150 : 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMovies.length,
                        itemBuilder: (context, index) {
                          final similarMovie = similarMovies[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: isSmallScreen ? 100 : 120,
                                  width: isSmallScreen ? 60 : 80,
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${similarMovie.posterPath}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  similarMovie.title,
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
