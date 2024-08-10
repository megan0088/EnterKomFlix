import 'package:flutter/material.dart';

/// `CustomIconButton` adalah widget tombol ikon yang dapat diaktifkan atau
/// dinonaktifkan dengan warna dan ikon yang dapat disesuaikan.
///
/// Widget ini memungkinkan pengguna untuk menampilkan ikon yang berbeda
/// berdasarkan status aktif atau tidak aktif. Anda juga dapat mengonfigurasi
/// warna ikon untuk kedua status tersebut.
///
/// ### Fungsionalitas:
/// - Menampilkan ikon aktif atau tidak aktif berdasarkan status `isActive`.
/// - Mengubah warna ikon sesuai dengan status aktif atau tidak aktif.
/// - Memungkinkan penanganan interaksi pengguna melalui callback `onPressed`.
///
/// ### Parameter:
/// - `isActive`: Status yang menentukan apakah ikon aktif atau tidak.
/// - `activeIcon`: Ikon yang ditampilkan ketika tombol dalam keadaan aktif.
/// - `inactiveIcon`: Ikon yang ditampilkan ketika tombol dalam keadaan tidak aktif.
/// - `onPressed`: Callback yang dipanggil saat tombol ditekan.
/// - `activeColor`: Warna ikon saat tombol aktif (opsional, default: `Colors.red`).
/// - `inactiveColor`: Warna ikon saat tombol tidak aktif (opsional, default: `Colors.white`).
class CustomIconButton extends StatelessWidget {
  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onPressed;
  final Color activeColor;
  final Color inactiveColor;

  CustomIconButton({
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onPressed,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isActive ? activeIcon : inactiveIcon,
        color: isActive ? activeColor : inactiveColor,
      ),
      onPressed: onPressed,
      iconSize: 30.0,
    );
  }
}
