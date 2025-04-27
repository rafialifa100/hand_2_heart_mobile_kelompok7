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
  bool _isLoading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller and animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animation
    _animationController.forward();
    
    // Initialize controllers with empty strings
    nameController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
    phoneController = TextEditingController(text: '');
    
    // Get user data and donation history
    getUserData();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Current user ID: ${user.uid}');
        print('Current user email: ${user.email}');
        
        // First try to get the user profile from Firestore
        userProfile = await getUserProfile(user.uid);
        
        // If userProfile is empty or some critical fields are missing,
        // use data from FirebaseAuth.currentUser as fallback
        if (userProfile == null || userProfile!.isEmpty || 
            (userProfile!['email'] == null && user.email != null)) {
          
          // Create basic profile from auth data
          userProfile = {
            'email': user.email,
            'username': user.displayName ?? user.email?.split('@')[0],
            'phone': user.phoneNumber,
            'photoUrl': user.photoURL,
          };
          
          // Save this basic profile to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            userProfile!,
            SetOptions(merge: true),
          );
          
          print('Created basic profile from auth data: $userProfile');
        }
        
        // Get donation history
        donationHistory = await getDonationHistory(user.uid);
        
        // Update text controllers
        setState(() {
          nameController.text = userProfile?['username'] ?? '';
          emailController.text = userProfile?['email'] ?? '';
          phoneController.text = userProfile?['phone'] ?? '';
          _isLoading = false;
        });
        
        print('Updated controllers: name=${nameController.text}, email=${emailController.text}');
      } else {
        print('No user is currently signed in');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error in getUserData: $e');
      showCustomSnackBar('Gagal mengambil data pengguna: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      print('Fetching user profile for ID: $userId');
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        print('User document found: $userData');
        return userData;
      } else {
        print('User document not found in Firestore');
        return {};
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
      
      List<Map<String, dynamic>> donations = donationSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      
      print('Found ${donations.length} donations for user $userId');
      return donations;
    } catch (e) {
      print('Error getting donation history: $e');
      return [];
    }
  }

  void toggleEdit() {
    if (isEditing) {
      // Save changes
      saveUserData();
    }
    setState(() => isEditing = !isEditing);
  }

  Future<void> saveUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update display name in Firebase Auth if it has changed
        if (user.displayName != nameController.text && nameController.text.isNotEmpty) {
          await user.updateDisplayName(nameController.text);
        }
        
        // Update user profile in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        // Update local state
        setState(() {
          userProfile = {
            ...userProfile!,
            'username': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
          };
        });
        
        showCustomSnackBar("Profil berhasil diperbarui");
      }
    } catch (e) {
      print('Error saving user data: $e');
      showCustomSnackBar("Gagal memperbarui profil: $e");
    }
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
                      // Implementation for changing profile photo
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
                      userProfile?['pantiBantuan']?.toString() ?? "0",
                      "Panti Terbantu",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Profile Information Fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 12, bottom: 8),
                  child: Text(
                    "Informasi Profil",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                buildProfileField("Nama", nameController, LucideIcons.user),
                buildProfileField("Email", emailController, LucideIcons.mail),
                buildProfileField("Nomor Telepon", phoneController, LucideIcons.phone),
              ],
            ),
            const SizedBox(height: 20),
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
                  } catch (e) {
                    showCustomSnackBar("Gagal keluar dari akun: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Keluar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
            style: const TextStyle(
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
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "Memuat data profil...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
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
                            // Add a refresh button for debugging
                            Center(
                              child: TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text("Refresh Data"),
                                onPressed: () {
                                  getUserData();
                                  showCustomSnackBar("Menyegarkan data...");
                                },
                              ),
                            ),
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