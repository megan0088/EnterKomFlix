import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../models/movie.dart';
import '../services/movie_services.dart';

/// Mengelola data film dan statusnya, termasuk film yang sedang tayang, film populer,
/// serta film yang mirip, dan menyediakan metode untuk menambah atau menghapus film dari
/// daftar tontonan dan favorit.
class MovieController extends GetxController {
  /// Daftar film yang sedang tayang.
  var nowPlaying = <Movie>[].obs;

  /// Daftar film populer.
  var popular = <Movie>[].obs;

  /// Menunjukkan apakah proses pengambilan data sedang memuat.
  var isLoading = false.obs;

  /// Detail film yang dipilih.
  var movie = Rxn<Movie>();

  /// Daftar film yang mirip dengan film yang dipilih.
  var similarMovies = <Movie>[].obs;

  /// Menyimpan pesan error untuk film yang sedang tayang.
  var errorNowPlaying = Rxn<String>();

  /// Menyimpan pesan error untuk film populer.
  var errorPopular = Rxn<String>();

  /// Menyimpan pesan error untuk detail film.
  var errorMovieDetails = Rxn<String>();

  /// Menyimpan pesan error untuk film yang mirip.
  var errorSimilarMovies = Rxn<String>();

  /// Daftar film yang ditambahkan ke daftar tontonan.
  var watchlist = <Movie>[].obs;

  /// Daftar film yang ditambahkan ke favorit.
  var favorites = <Movie>[].obs;

  final MovieService _movieService = MovieService();

  @override
  void onInit() {
    super.onInit();
    fetchNowPlayingMovies();
    fetchPopularMovies();
  }

  /// Mengambil daftar film yang sedang tayang.
  ///
  /// Mengupdate variabel `nowPlaying` dengan daftar film yang sedang tayang dan
  /// menangani error jika terjadi kesalahan.
  Future<void> fetchNowPlayingMovies() async {
    isLoading.value = true;
    errorNowPlaying.value = null;

    try {
      nowPlaying.assignAll(await _movieService.fetchNowPlayingMovies());
    } catch (e) {
      errorNowPlaying.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengambil daftar film populer.
  ///
  /// Mengupdate variabel `popular` dengan daftar film populer dan
  /// menangani error jika terjadi kesalahan.
  Future<void> fetchPopularMovies() async {
    isLoading.value = true;
    errorPopular.value = null;

    try {
      popular.assignAll(await _movieService.fetchPopularMovies());
    } catch (e) {
      errorPopular.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengambil detail film berdasarkan [movieId].
  ///
  /// Mengupdate variabel `movie` dengan detail film dan menangani error jika terjadi
  /// kesalahan.
  ///
  /// [movieId] - ID film yang detailnya akan diambil.
  Future<void> fetchMovieDetails(int movieId) async {
    isLoading.value = true;
    errorMovieDetails.value = null;

    try {
      movie.value = await _movieService.fetchMovieDetails(movieId);
    } catch (e) {
      errorMovieDetails.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengambil daftar film yang mirip dengan film berdasarkan [movieId].
  ///
  /// Mengupdate variabel `similarMovies` dengan daftar film yang mirip dan menangani error
  /// jika terjadi kesalahan.
  ///
  /// [movieId] - ID film yang akan dicari film miripnya.
  Future<void> fetchSimilarMovies(int movieId) async {
    isLoading.value = true;
    errorSimilarMovies.value = null;

    try {
      similarMovies.assignAll(await _movieService.fetchSimilarMovies(movieId));
    } catch (e) {
      errorSimilarMovies.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Menambahkan film ke daftar tontonan jika belum ada di daftar.
  ///
  /// [movie] - Film yang akan ditambahkan ke daftar tontonan.
  void addToWatchlist(Movie movie) {
    if (!watchlist.contains(movie)) {
      watchlist.add(movie);
    }
  }

  /// Menghapus film dari daftar tontonan jika ada di daftar.
  ///
  /// [movie] - Film yang akan dihapus dari daftar tontonan.
  void removeFromWatchlist(Movie movie) {
    if (watchlist.contains(movie)) {
      watchlist.remove(movie);
    }
  }

  /// Menambahkan film ke daftar favorit jika belum ada di daftar.
  ///
  /// [movie] - Film yang akan ditambahkan ke daftar favorit.
  void addToFavorite(Movie movie) {
    if (!favorites.contains(movie)) {
      favorites.add(movie);
    }
  }

  /// Menghapus film dari daftar favorit jika ada di daftar.
  ///
  /// [movie] - Film yang akan dihapus dari daftar favorit.
  void removeFromFavorite(Movie movie) {
    if (favorites.contains(movie)) {
      favorites.remove(movie);
    }
  }

  /// Menyimpan gambar ke penyimpanan lokal.
  ///
  /// Memeriksa dan meminta izin penyimpanan pada Android, kemudian mengunduh dan
  /// menyimpan gambar ke folder Unduhan.
  ///
  /// [imageUrl] - URL gambar yang akan diunduh.
  /// [fileName] - Nama file untuk gambar yang disimpan.
  Future<void> saveImageToLocal(String imageUrl, String fileName) async {
    try {
      if (Platform.isAndroid) {
        print("Memeriksa status izin...");
        var status = await Permission.storage.status;

        if (!status.isGranted) {
          print("Meminta izin...");
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          print("Izin diberikan, menyimpan gambar...");
          await _downloadAndSaveImage(imageUrl, fileName);
        } else if (status.isPermanentlyDenied) {
          print("Izin secara permanen ditolak.");
          Get.snackbar('Izin Ditolak',
              'Izin penyimpanan secara permanen ditolak. Harap aktifkan di pengaturan aplikasi.');
          await openAppSettings();
        } else {
          print("Izin ditolak.");
          Get.snackbar(
              'Izin Ditolak', 'Tidak dapat menyimpan gambar tanpa izin');
        }
      } else {
        Get.snackbar('Error', 'Fitur ini tidak didukung pada platform Anda.');
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Terjadi kesalahan saat menyimpan gambar: $e');
    }
  }

  /// Mengunduh dan menyimpan gambar ke penyimpanan lokal.
  ///
  /// Mengunduh gambar dari [imageUrl] dan menyimpannya dengan nama file [fileName]
  /// di folder Unduhan.
  ///
  /// [imageUrl] - URL gambar yang akan diunduh.
  /// [fileName] - Nama file untuk gambar yang disimpan.
  Future<void> _downloadAndSaveImage(String imageUrl, String fileName) async {
    try {
      final downloadDir = Directory('/storage/emulated/0/Download');

      if (!(await downloadDir.exists())) {
        await downloadDir.create(recursive: true);
      }

      final filePath = '${downloadDir.path}/$fileName';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        Get.snackbar('Sukses', 'Gambar disimpan ke folder Unduhan');
      } else {
        Get.snackbar('Error', 'Gagal mengunduh gambar');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat menyimpan gambar: $e');
    }
  }
}
