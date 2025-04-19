import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _selectedRole;
  String? _errorMessage;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final body = {
        "fullName": _fullNameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
        "role": _selectedRole!,
      };

      try {
        final response = await http.post(
          Uri.parse("http://localhost:8080/api/user/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacementNamed(context, '/login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrasi berhasil. Silakan login.")),
          );
        } else {
          setState(() => _errorMessage = "Gagal mendaftar. Coba lagi.");
        }
      } catch (e) {
        setState(() => _errorMessage = "Terjadi kesalahan. Coba lagi nanti.");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword
            ? (isConfirm ? !_showConfirmPassword : !_showPassword)
            : false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    (isConfirm ? _showConfirmPassword : _showPassword)
                        ? LucideIcons.eyeOff
                        : LucideIcons.eye,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isConfirm) {
                        _showConfirmPassword = !_showConfirmPassword;
                      } else {
                        _showPassword = !_showPassword;
                      }
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label harus diisi';
          }
          if (label == 'Email' &&
              !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Format email tidak valid';
          }
          if (label == 'Password' && value.length < 8) {
            return 'Password minimal 8 karakter';
          }
          if (label == 'Konfirmasi Password' &&
              value != _passwordController.text) {
            return 'Password tidak cocok';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRoleSelector() {
    final List<Map<String, dynamic>> roles = [
      {
        'label': 'Donatur',
        'value': 'donatur',
        'icon': LucideIcons.heartHandshake,
        'desc': 'Saya ingin berdonasi dan membantu'
      },
      {
        'label': 'PJ Panti',
        'value': 'pj_panti',
        'icon': LucideIcons.building,
        'desc': 'Saya mengelola sebuah panti'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pilih Peran Anda", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: roles.map((role) {
            final bool selected = _selectedRole == role['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = role['value'] as String),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: selected ? Colors.blue : Colors.grey),
                    color: selected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(role['icon'] as IconData,
                          color: selected ? Colors.blue : Colors.grey,
                          size: 30),
                      const SizedBox(height: 6),
                      Text(role['label'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.blue : Colors.black)),
                      const SizedBox(height: 4),
                      Text(role['desc'] as String,
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedRole == null)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 8),
            child: Text('Pilih peran Anda', style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 32,
                child: Icon(LucideIcons.heart, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 12),
              const Text("Daftar Akun Baru",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 6),
              const Text("Bergabunglah untuk mulai berdonasi",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextInput(
                        label: 'Nama Lengkap',
                        controller: _fullNameController,
                        icon: LucideIcons.user),
                    _buildTextInput(
                        label: 'Email',
                        controller: _emailController,
                        icon: LucideIcons.mail),
                    _buildTextInput(
                        label: 'Nomor HP',
                        controller: _phoneController,
                        icon: LucideIcons.phone),
                    _buildRoleSelector(),
                    _buildTextInput(
                        label: 'Password',
                        controller: _passwordController,
                        icon: LucideIcons.lock,
                        isPassword: true),
                    _buildTextInput(
                        label: 'Konfirmasi Password',
                        controller: _confirmPasswordController,
                        icon: LucideIcons.lock,
                        isPassword: true,
                        isConfirm: true),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Daftar Sekarang",
                              style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun?",
                            style: TextStyle(fontSize: 14)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text("Masuk",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text("Kembali ke Beranda"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
