import 'package:flutter/material.dart';

class DonasiBarangPage extends StatefulWidget {
  const DonasiBarangPage({super.key});

  @override
  _DonasiBarangPageState createState() => _DonasiBarangPageState();
}

class _DonasiBarangPageState extends State<DonasiBarangPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> donations = [];
  Map<String, dynamic>? selectedOrphanage;
  Map<String, dynamic>? selectedRequest;
  TextEditingController donationAmountController = TextEditingController();
  TextEditingController donationMessageController = TextEditingController();
  bool showSuccessPopup = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    fetchDonations();
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
    _animationController.dispose();
    donationAmountController.dispose();
    donationMessageController.dispose();
    super.dispose();
  }

  void fetchDonations() {
    setState(() {
      donations = [
        {
          'id': 1,
          'orphanageName': 'Panti Harapan',
          'city': 'Bandung',
          'image': 'assets/images/panti1.jpg',
          'description': 'Panti asuhan yang fokus pada pendidikan dan pengembangan keterampilan anak-anak.',
          'requests': [
            {'item': 'Baju', 'quantity': 10, 'icon': Icons.checkroom},
            {'item': 'Buku', 'quantity': 15, 'icon': Icons.book},
          ],
        },
        {
          'id': 2,
          'orphanageName': 'Panti Sejahtera',
          'city': 'Jakarta',
          'image': 'assets/images/panti2.jpg',
          'description': 'Panti asuhan yang menyediakan tempat tinggal dan pendidikan untuk anak-anak yatim piatu.',
          'requests': [
            {'item': 'Tas', 'quantity': 5, 'icon': Icons.shopping_bag},
          ],
        },
        {
          'id': 3,
          'orphanageName': 'Panti Kasih',
          'city': 'Surabaya',
          'image': 'assets/images/panti3.jpg',
          'description': 'Panti asuhan yang fokus pada pengembangan bakat dan kreativitas anak-anak.',
          'requests': [
            {'item': 'Mainan Edukasi', 'quantity': 12, 'icon': Icons.toys},
            {'item': 'Pakaian', 'quantity': 20, 'icon': Icons.checkroom},
            {'item': 'Makanan', 'quantity': 30, 'icon': Icons.fastfood},
          ],
        },
      ];
    });
  }

  void handleSubmitDonation() {
    final int? amount = int.tryParse(donationAmountController.text);
    if (amount == null ||
        amount <= 0 ||
        amount > (selectedRequest?['quantity'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Jumlah donasi tidak valid'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() {
      showSuccessPopup = true;
      selectedRequest!['quantity'] -= amount;
      donationAmountController.clear();
    });
  }

  Widget _buildOrphanageCard(Map<String, dynamic> orphanage) {
    bool isSelected = selectedOrphanage == orphanage;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOrphanage = orphanage;
          selectedRequest = null;
          donationAmountController.clear();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.blue.shade300, width: 2)
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orphanage['orphanageName'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              orphanage['city'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.arrow_forward_ios_rounded,
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
                    size: isSelected ? 28 : 18,
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(height: 12),
                Text(
                  orphanage['description'] ?? 'Tidak ada deskripsi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    bool isSelected = selectedRequest == request;
    final IconData iconData = request['icon'] ?? Icons.card_giftcard;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRequest = request;
          donationAmountController.clear();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.green.shade300, width: 2)
              : Border.all(color: Colors.grey.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  color: isSelected ? Colors.green : Colors.grey.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['item'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isSelected ? Colors.green.shade700 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Dibutuhkan: ${request['quantity']} buah",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              isSelected
                  ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.volunteer_activism,
                color: Colors.green.shade600,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                "Jumlah Donasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: donationAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Maksimal ${selectedRequest!['quantity']} buah",
              prefixIcon: const Icon(Icons.edit, color: Colors.blueGrey),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: handleSubmitDonation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Donasi Sekarang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                "Ringkasan Donasi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Panti Asuhan:"),
              Text(
                selectedOrphanage!['orphanageName'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Barang:"),
              Text(
                selectedRequest!['item'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green.shade700,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Donasi Berhasil!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Terima kasih atas kebaikan Anda. Donasi Anda akan membantu banyak anak-anak yang membutuhkan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: donationMessageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tulis pesan untuk panti asuhan (opsional)",
                prefixIcon: const Icon(Icons.message, color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSuccessPopup = false;
                    selectedRequest = null;
                    donationMessageController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        "Donasi Barang",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue.shade100, Colors.blue.shade50],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              bottom: 0,
                              child: Opacity(
                                opacity: 0.2,
                                child: Icon(
                                  Icons.volunteer_activism,
                                  size: 120,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.person_outline, color: Colors.blue.shade700),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                    ],
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FadeTransition(
                        opacity: _animation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Intro Card
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.amber.shade800,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Donasi Barang",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Bantu panti asuhan dengan menyumbangkan barang yang mereka butuhkan",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Step 1: Pilih Panti Asuhan
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      "1",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Pilih Panti Asuhan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...donations.map((orphanage) => _buildOrphanageCard(orphanage)).toList(),

                            // Step 2: Pilih Kebutuhan
                            if (selectedOrphanage != null) ...[

                              const SizedBox(height: 24),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade600,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Text(
                                        "2",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Pilih Kebutuhan ${selectedOrphanage!['orphanageName']}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...selectedOrphanage!['requests'].map<Widget>((request) => _buildRequestItem(request)).toList(),
                            ],

                            // Step 3: Form Donasi
                            if (selectedRequest != null) ...[

                              const SizedBox(height: 24),
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade600,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Text(
                                        "3",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Detail Donasi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildSummary(),
                              _buildDonationForm(),
                            ],

                            const SizedBox(height: 100), // Extra space at bottom
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Popup sukses
              if (showSuccessPopup) _buildSuccessDialog(),
            ],
          ),
        ),
      ),
    );
  }
}
