import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  Map<String, dynamic>? userProfile;
  List<Map<String, dynamic>>? donationHistory;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Ambil data pengguna dan riwayat donasi
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userProfile = await getUserProfile(user.uid);
        donationHistory = await getDonationHistory(user.uid);
        setState(() {
          nameController = TextEditingController(text: userProfile?['username'] ?? '');
          emailController = TextEditingController(text: userProfile?['email'] ?? '');
          phoneController = TextEditingController(text: userProfile?['phone'] ?? '');
        });
      }
    } catch (e) {
      showCustomSnackBar('Gagal mengambil data pengguna');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw 'User not found';
      }
    } catch (e) {
      print('Error getting user profile: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getDonationHistory(String userId) async {
    try {
      QuerySnapshot donationSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('userId', isEqualTo: userId)
          .get();
      
      return donationSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting donation history: $e');
      return [];
    }
  }

  void toggleEdit() {
    if (isEditing) {
      // Simpan perubahan (di implementasi sebenarnya, Anda akan menyimpan ke database)
      showCustomSnackBar("Profil berhasil diperbarui");
    }
    setState(() => isEditing = !isEditing);
  }

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
              boxShadow: isEditing
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: controller,
              readOnly: !isEditing,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: isEditing ? Colors.blue : Colors.grey.shade600),
                filled: true,
                fillColor: isEditing ? Colors.white : Colors.grey.shade100,
                hintText: 'Masukkan $label',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isEditing ? Colors.blue.shade400 : Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isEditing ? Colors.blue.shade200 : Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue.shade400,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileSection() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: userProfile?['photoUrl'] != null
                        ? DecorationImage(
                            image: NetworkImage(userProfile?['photoUrl']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userProfile?['photoUrl'] == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade700,
                        )
                      : null,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade600,
                  child: IconButton(
                    icon: const Icon(
                      LucideIcons.camera,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      // Implementasi untuk mengubah foto profil
                      showCustomSnackBar("Fitur ganti foto profil akan segera hadir");
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              userProfile?['username'] ?? 'Nama Tidak Ditemukan',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.mail,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  userProfile?['email'] ?? 'Email Tidak Ditemukan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      LucideIcons.heart,
                      Colors.blue.shade600,
                      donationHistory?.length.toString() ?? '0',
                      "Total Donasi",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      LucideIcons.calendarDays,
                      Colors.green.shade600,
                      "5",  // Hardcoded for now. In reality, you would calculate this.
                      "Panti Terbantu",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, Color color, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: userProfile == null
          ? Center(child: CircularProgressIndicator()) // Tampilkan loading jika data belum tersedia
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 60,
                      floating: true,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.blue.shade600,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isEditing ? LucideIcons.checkCircle : LucideIcons.edit2,
                                color: isEditing ? Colors.green.shade600 : Colors.blue.shade600,
                                size: 18,
                              ),
                            ),
                            onPressed: toggleEdit,
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text(
                          "Profil",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        centerTitle: true,
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.blue.shade100, Colors.blue.shade50],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
