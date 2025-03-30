import 'package:flutter/material.dart';
import 'tambahbarang_hapusbarang.dart'; // Import halaman Tambah & Hapus Barang
import 'profile.dart'; // Import profile
import 'donasibarang.dart'; // Import halaman Donasi ke Panti
import 'login.dart'; // Import halaman Login

void main() {
  runApp(const MyApp());
}

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false; // Simulasi status login

  void checkLogin(Function onSuccess) {
    if (isLoggedIn) {
      onSuccess();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
          setState(() => isLoggedIn = true);
        })),
      );
    }
  }

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
                checkLogin(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                });
              },
              child: const Text('Lihat Profil'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                checkLogin(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DonationFlowPage()),
                  );
                });
              },
              child: const Text('Donasi ke Panti'),
            ),
          ],
        ),
      ),
    );
  }
}
