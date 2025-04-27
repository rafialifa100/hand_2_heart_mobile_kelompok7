import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/admindonasipage.dart';
import 'view/register_page.dart';
import 'view/homepage.dart';
import 'view/donasipage.dart'; 
import 'view/profilpage.dart'; 
import 'view/adminpage.dart';
import 'view/admindonasipage.dart';
import 'view/adminpantipage.dart';
import 'view/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hand2Heart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/donation': (context) => DonasiBarangPage(),
        '/admin': (context) => const AdminPage(),
        '/admin/panti': (context) => const AdminPantiPage(),
        '/profile': (context) => ProfilePage(
          isAdmin: false,
          userProfile: {
            'username': 'John Doe',
            'email': 'john@example.com',
          },
          donationHistory: [
            {
              'type': 'barang',
              'amount': '1',
              'item': 'Baju Bekas Layak Pakai',
              'orphanageName': 'Panti Asuhan Kasih Ibu',
              'date': '10 Apr 2025',
              'message': 'Semoga berkah',
            },
            {
              'type': 'uang',
              'amount': '50000',
              'orphanageName': 'Panti Asuhan Pelita Hati',
              'date': '08 Apr 2025',
              'message': 'Semoga amanah'
            }
          ],
        ),
      },
      // Tambahan: agar bisa navigasi ke halaman yang membutuhkan argumen
      onGenerateRoute: (settings) {
        if (settings.name == '/admin/donasi') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AdminDonasiPage(namaPanti: args['namaPanti']),
          );
        }

        return null; // default fallback jika route tidak ditemukan
      },
    );
  }
}
