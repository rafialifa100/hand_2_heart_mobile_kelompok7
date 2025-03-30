import 'package:flutter/material.dart';
import 'riwayat_donasi.dart'; // Import file riwayat_donasi.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian kiri: Profil pengguna
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/profile_picture.png',
                    ), // Ganti dengan path gambar Anda
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nama Pengguna',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'email@example.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk tombol logout
                      Navigator.pop(context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Jarak antara profil dan riwayat donasi
            // Bagian kanan: Riwayat donasi
            Expanded(
              flex: 2,
              child: const RiwayatDonasi(), // Widget dari riwayat_donasi.dart
            ),
          ],
        ),
      ),
    );
  }
}
