import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/movie_controller.dart';
import '../controllers/auth_controller.dart';
import 'detail_movie.dart';
import 'package:movie_app/widget/bottom_navigation_bar.dart';

/// Layar utama aplikasi yang menampilkan film-film yang sedang tayang,
/// film-film populer, dan menu navigasi di bagian bawah.
class HomeScreen extends StatelessWidget {
  final MovieController movieController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(authController.isSignedIn.value
              ? 'Hello, ${authController.userName.value}'
              : 'Movie App');
        }),
        actions: [
          if (authController.isSignedIn.value)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authController.signOut();
                Get.offAllNamed('/sign_in');
              },
            ),
        ],
      ),
      body: Obx(() {
        // Menampilkan indikator pemuatan saat data sedang dimuat
        if (movieController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              // Bagian Now Playing
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Now Playing',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.3,
                child: CarouselSlider.builder(
                  itemCount: movieController.nowPlaying.length > 6
                      ? 6
                      : movieController.nowPlaying.length,
                  itemBuilder: (context, index, realIndex) {
                    final movie = movieController.nowPlaying[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => MovieDetailScreen(movieId: movie.id));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            movie.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.download),
                                          onPressed: () async {
                                            final imageUrl =
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}';
                                            final fileName = movie.posterPath
                                                .split('/')
                                                .last;
                                            await movieController
                                                .saveImageToLocal(
                                                    imageUrl, fileName);
                                          },
                                        ),
                                        IconButton(
                                          icon: Obx(() => Icon(
                                                movieController.favorites
                                                        .contains(movie)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: movieController.favorites
                                                        .contains(movie)
                                                    ? Colors.red
                                                    : Colors.white,
                                              )),
                                          onPressed: () {
                                            if (movieController.favorites
                                                .contains(movie)) {
                                              movieController
                                                  .removeFromFavorite(movie);
                                            } else {
                                              movieController
                                                  .addToFavorite(movie);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Obx(() => Icon(
                                                movieController.watchlist
                                                        .contains(movie)
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: movieController.watchlist
                                                        .contains(movie)
                                                    ? Colors.red
                                                    : Colors.white,
                                              )),
                                          onPressed: () {
                                            if (movieController.watchlist
                                                .contains(movie)) {
                                              movieController
                                                  .removeFromWatchlist(movie);
                                            } else {
                                              movieController
                                                  .addToWatchlist(movie);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.3,
                    autoPlay: true,
                    viewportFraction: screenWidth > 600 ? 0.5 : 0.8,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
              // Bagian Popular
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 4 : 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: screenWidth > 600 ? 0.6 : 0.7,
                ),
                itemCount: movieController.popular.length > 20
                    ? 20
                    : movieController.popular.length,
                itemBuilder: (context, index) {
                  final movie = movieController.popular[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => MovieDetailScreen(movieId: movie.id));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Obx(() => Icon(
                                            movieController.favorites
                                                    .contains(movie)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: movieController.favorites
                                                    .contains(movie)
                                                ? Colors.red
                                                : Colors.white,
                                          )),
                                      onPressed: () {
                                        if (movieController.favorites
                                            .contains(movie)) {
                                          movieController
                                              .removeFromFavorite(movie);
                                        } else {
                                          movieController.addToFavorite(movie);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Obx(() => Icon(
                                            movieController.watchlist
                                                    .contains(movie)
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: movieController.watchlist
                                                    .contains(movie)
                                                ? Colors.red
                                                : Colors.white,
                                          )),
                                      onPressed: () {
                                        if (movieController.watchlist
                                            .contains(movie)) {
                                          movieController
                                              .removeFromWatchlist(movie);
                                        } else {
                                          movieController.addToWatchlist(movie);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      }),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
