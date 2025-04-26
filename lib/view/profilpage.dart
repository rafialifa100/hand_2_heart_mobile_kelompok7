import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'donasipage.dart';

class ProfilePage extends StatefulWidget {
  final bool isAdmin;
  final Map<String, dynamic> userProfile;
  final List<Map<String, dynamic>> donationHistory;

  const ProfilePage({
    super.key,
    required this.isAdmin,
    required this.userProfile,
    required this.donationHistory,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userProfile['username']);
    emailController = TextEditingController(text: widget.userProfile['email']);
    phoneController = TextEditingController(text: widget.userProfile['phone'] ?? '');
    addressController = TextEditingController(text: widget.userProfile['address'] ?? '');
    
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _animationController.dispose();
    super.dispose();
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
                    image: widget.userProfile['photoUrl'] != null
                        ? DecorationImage(
                            image: NetworkImage(widget.userProfile['photoUrl']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.userProfile['photoUrl'] == null
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
              widget.userProfile['username'],
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
                  widget.userProfile['email'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats Section
            if (!widget.isAdmin) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                 /*   Expanded(
                      child: _buildStatCard(

                        Colors.blue.shade600,
                        widget.donationHistory.length.toString(),
                        "Total Donasi",
                      ),
                    ), */
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
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData iconData, Color color, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
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

  Widget buildPersonalInformationSection() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.userSquare,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Informasi Pribadi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isEditing ? Colors.green.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isEditing ? "Sedang Mengedit" : "Lihat Saja",
                      style: TextStyle(
                        fontSize: 12,
                        color: isEditing ? Colors.green.shade700 : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 10),
            buildProfileField("Nama Lengkap", nameController, LucideIcons.user),
            buildProfileField("Email", emailController, LucideIcons.mail),
            buildProfileField("No. Telepon", phoneController, LucideIcons.phone),
            buildProfileField("Alamat", addressController, LucideIcons.mapPin),
            const SizedBox(height: 20),
            if (isEditing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(LucideIcons.save),
                        label: const Text("Simpan Perubahan"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: toggleEdit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildDonationCard(Map<String, dynamic> donation) {
    final isMoney = donation['type'] == 'uang';
    final color = isMoney ? Colors.blue : Colors.green;
    final statusColor = {
      'selesai': Colors.green,
      'pending': Colors.orange,
      'ditolak': Colors.red,
    }[donation['status']?.toLowerCase() ?? 'selesai'] ?? Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isMoney ? LucideIcons.wallet : LucideIcons.package2,
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donation['orphanageName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.calendar,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              donation['date'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      donation['status'] ?? 'Selesai',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jenis Donasi",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isMoney ? "Donasi Dana" : "Donasi Barang",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jumlah",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isMoney
                              ? "Rp ${donation['amount']}"
                              : "${donation['amount']} ${donation['item']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (donation['message'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  "Pesan",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  donation['message'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDonationHistorySection() {
    if (widget.donationHistory.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(20),
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
            Icon(
              LucideIcons.gift,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              "Belum Ada Riwayat Donasi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Donasi sekarang untuk membantu yang membutuhkan",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.heart),
              label: const Text("Donasi Sekarang"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DonasiBarangPage()),
                );
              },
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.history,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Riwayat Donasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: Icon(
                      LucideIcons.filter,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    label: Text(
                      "Filter",
                      style: TextStyle(
                        color: Colors.blue.shade600,
                      ),
                    ),
                    onPressed: () {
                      // Implementasi filter
                      showCustomSnackBar("Fitur filter akan segera hadir");
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.donationHistory.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemBuilder: (context, index) {
                return buildDonationCard(widget.donationHistory[index]);
              },
            ),
            if (widget.donationHistory.length > 3) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: TextButton.icon(
                    icon: const Icon(LucideIcons.arrowDown),
                    label: const Text("Lihat Semua Riwayat"),
                    onPressed: () {
                      // Implementasi untuk melihat semua riwayat
                      showCustomSnackBar("Fitur lihat semua riwayat akan segera hadir");
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DonasiBarangPage()),
                    );
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
                      buildPersonalInformationSection(),
                      if (!widget.isAdmin) buildDonationHistorySection(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: !widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DonasiBarangPage()),
                );
              },
              backgroundColor: Colors.blue.shade600,
              icon: const Icon(LucideIcons.heart),
              label: const Text("Donasi"),
            )
          : null,
    );
  }
}