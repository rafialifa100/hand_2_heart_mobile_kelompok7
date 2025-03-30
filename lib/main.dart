import 'package:flutter/material.dart';
import 'tambahbarang_hapusbarang.dart'; // Import halaman Tambah & Hapus Barang
import 'profile.dart'; // Import profile
import 'donasibarang.dart'; // Import halaman Donasi ke Panti

void main() {
  runApp(const MyApp());
}

/// Aplikasi utama
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand2Heart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

/// Halaman utama sederhana dengan tombol untuk navigasi ke Tambah & Hapus Barang dan Profil
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hand2Heart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahBarangHapusBarangPage(),
                  ),
                );
              },
              child: const Text('Menu Tambah & Hapus Barang'),
            ),
            const SizedBox(height: 16), // Jarak antar tombol
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const Text('Lihat Profil'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonationFlowPage(),
                  ),
                );
              },
              child: const Text('Donasi ke Panti'),
            ),
          ],
        ),
      ),
    );
  }
}
