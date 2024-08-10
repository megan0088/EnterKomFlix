/// Representasi dari data film dengan atribut utama yang diperlukan.
class Movie {
  /// ID unik dari film.
  final int id;

  /// Judul film.
  final String title;

  /// Deskripsi atau ringkasan film.
  final String overview;

  /// Jalur poster film.
  final String posterPath;

  /// Daftar ID genre film.
  final List<int> genreIds;

  /// Membuat instance `Movie` dengan atribut yang diberikan.
  ///
  /// [id] - ID unik dari film.
  /// [title] - Judul film.
  /// [overview] - Deskripsi atau ringkasan film.
  /// [posterPath] - Jalur poster film.
  /// [genreIds] - Daftar ID genre film.
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.genreIds,
  });

  /// Membuat instance `Movie` dari objek JSON.
  ///
  /// Mengambil data film dari peta JSON dan mengembalikannya sebagai instance `Movie`.
  ///
  /// [json] - Peta JSON yang berisi data film.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}
