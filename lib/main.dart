import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'homepage.dart';
import 'donasipage.dart'; 
import 'profilpage.dart'; 
import 'login_page.dart';

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
        '/profile': (context) => ProfilePage(
        ),
      },
    );
  }
}