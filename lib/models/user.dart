/// Representasi dari data pengguna dengan atribut utama yang diperlukan.
class User {
  /// ID unik dari pengguna.
  final String id;

  /// Nama pengguna.
  final String username;

  /// Membuat instance `User` dengan atribut yang diberikan.
  ///
  /// [id] - ID unik dari pengguna.
  /// [username] - Nama pengguna.
  User({
    required this.id,
    required this.username,
  });
}
