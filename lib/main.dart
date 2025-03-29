import 'package:flutter/material.dart';
import 'tambahbarang_hapusbarang.dart'; // Import halaman Tambah & Hapus Barang
import 'riwayat_donasi.dart'; // Import komponen Riwayat Donasi

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

/// Halaman utama sederhana dengan tombol untuk navigasi ke Tambah & Hapus Barang
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand2Heart'),
      ),
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}
