import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
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
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

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
            _buildCustomSnackBar("Registrasi berhasil. Silakan login."),
          );
        } else {
          setState(() => _errorMessage = "Gagal mendaftar. Coba lagi.");
        }
      } catch (e) {
        setState(() => _errorMessage = "Terjadi kesalahan. Coba lagi nanti.");
      } finally {
        setState(() => _isLoading = false);
      }
    } else if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildCustomSnackBar("Silakan pilih peran Anda terlebih dahulu"),
      );
    }
  }

  SnackBar _buildCustomSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[700],
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword
                  ? (isConfirm ? !_showConfirmPassword : !_showPassword)
                  : false,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.blue.shade600),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          (isConfirm ? _showConfirmPassword : _showPassword)
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          color: Colors.grey.shade600,
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
                filled: true,
                fillColor: Colors.white,
                hintText: 'Masukkan $label',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue.shade200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue.shade400,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red.shade300,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red.shade400,
                    width: 2,
                  ),
                ),
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
          ),
        ],
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

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.userCog,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Pilih Peran Anda",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedRole != null ? Colors.green.shade100 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _selectedRole != null ? "Peran Terpilih" : "Belum Dipilih",
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedRole != null ? Colors.green.shade700 : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
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
                        border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300),
                        color: selected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selected ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selected ? Colors.blue.withOpacity(0.2) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(role['icon'] as IconData,
                                color: selected ? Colors.blue : Colors.grey,
                                size: 30),
                          ),
                          const SizedBox(height: 12),
                          Text(role['label'] as String,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.blue : Colors.black)),
                          const SizedBox(height: 8),
                          Text(role['desc'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? Colors.blue.shade700 : Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // App Logo and Header
                FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.heart, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text("Daftar Akun Baru",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700
                          )),
                      const SizedBox(height: 8),
                      Text("Bergabunglah untuk mulai berdonasi",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          )),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Personal Information Section
                      FadeTransition(
                        opacity: _animation,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.userSquare,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Informasi Pribadi",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Nama Lengkap',
                                controller: _fullNameController,
                                icon: LucideIcons.user,
                              ),
                              _buildInputField(
                                label: 'Email',
                                controller: _emailController,
                                icon: LucideIcons.mail,
                              ),
                              _buildInputField(
                                label: 'Nomor HP',
                                controller: _phoneController,
                                icon: LucideIcons.phone,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Role Selector
                      _buildRoleSelector(),

                      // Security Information Section
                      FadeTransition(
                        opacity: _animation,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.shield,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Informasi Keamanan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Password',
                                controller: _passwordController,
                                icon: LucideIcons.lock,
                                isPassword: true,
                              ),
                              _buildInputField(
                                label: 'Konfirmasi Password',
                                controller: _confirmPasswordController,
                                icon: LucideIcons.lock,
                                isPassword: true,
                                isConfirm: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Error Message
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.alertTriangle, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.userPlus),
                                    SizedBox(width: 10),
                                    Text("Daftar Sekarang",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                        ),
                      ),

                      // Login Link
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sudah punya akun?",
                              style: TextStyle(color: Colors.grey.shade700)),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                            child: Text("Masuk",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      ),

                      // Back to Home Link
                      TextButton.icon(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                        icon: Icon(Icons.arrow_back, size: 16, color: Colors.grey.shade600),
                        label: Text("Kembali ke Beranda",
                            style: TextStyle(color: Colors.grey.shade600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}