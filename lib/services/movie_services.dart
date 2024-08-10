import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

/// Kelas `MovieService` menyediakan metode untuk mengambil data film dari API The Movie Database.
///
/// ### Fungsi:
/// - `fetchNowPlayingMovies()`: Mengambil daftar film yang sedang tayang saat ini.
/// - `fetchPopularMovies()`: Mengambil daftar film yang populer.
/// - `fetchMovieDetails(int movieId)`: Mengambil detail dari film berdasarkan ID film.
/// - `fetchSimilarMovies(int movieId)`: Mengambil daftar film yang mirip dengan film berdasarkan ID film.
///
/// Semua metode mengembalikan data dalam bentuk list `Movie` atau objek `Movie`
/// dan menangani status respons API untuk menangani kesalahan jika diperlukan.
class MovieService {
  final String apiKey = 'b84152339afb1e91f13155be1b1863bc';
  final String baseUrl = 'https://api.themoviedb.org/3';

  /// Mengambil daftar film yang sedang tayang saat ini.
  ///
  /// Mengembalikan `Future<List<Movie>>` yang berisi daftar film yang sedang tayang saat ini.
  ///
  /// Menggunakan API endpoint:
  /// `$baseUrl/movie/now_playing?api_key=$apiKey`
  Future<List<Movie>> fetchNowPlayingMovies() async {
    return await _fetchMovies('$baseUrl/movie/now_playing?api_key=$apiKey');
  }

  /// Mengambil daftar film yang populer.
  ///
  /// Mengembalikan `Future<List<Movie>>` yang berisi daftar film populer.
  ///
  /// Menggunakan API endpoint:
  /// `$baseUrl/movie/popular?api_key=$apiKey`
  Future<List<Movie>> fetchPopularMovies() async {
    return await _fetchMovies('$baseUrl/movie/popular?api_key=$apiKey');
  }

  /// Mengambil detail dari film berdasarkan ID film.
  ///
  /// Mengambil informasi lengkap tentang film dengan ID tertentu.
  ///
  /// - Parameter: `movieId` ID dari film yang ingin diambil detailnya.
  /// - Mengembalikan `Future<Movie>` yang berisi detail film.
  /// - Melemparkan `Exception` jika terjadi kesalahan saat memuat detail film.
  Future<Movie> fetchMovieDetails(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  /// Mengambil daftar film yang mirip dengan film berdasarkan ID film.
  ///
  /// Mengembalikan daftar film yang memiliki kesamaan dengan film yang ditentukan.
  ///
  /// - Parameter: `movieId` ID dari film yang ingin dicari film miripnya.
  /// - Mengembalikan `Future<List<Movie>>` yang berisi daftar film yang mirip.
  /// - Melemparkan `Exception` jika tidak ditemukan film mirip atau terjadi kesalahan saat memuat data.
  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        return (data['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('No similar movies found in the response data.');
      }
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  /// Mengambil daftar film dari URL yang diberikan.
  ///
  /// Ini adalah metode internal yang digunakan oleh metode publik untuk
  /// mengambil data film dari API.
  ///
  /// - Parameter: `url` URL lengkap untuk meminta data film.
  /// - Mengembalikan `Future<List<Movie>>` yang berisi daftar film.
  /// - Melemparkan `Exception` jika tidak ada film ditemukan atau terjadi kesalahan saat memuat data.
  Future<List<Movie>> _fetchMovies(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        return (data['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('No movies found in the response data.');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
