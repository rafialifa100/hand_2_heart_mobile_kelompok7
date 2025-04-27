import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({Key? key}) : super(key: key);

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  List<Map<String, dynamic>> donationHistory = [];
  bool _isLoading = true;

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
    
    // Get donation history
    getDonationHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void getDonationHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // In a real app, you would fetch this from Firestore
      // For now, we're using sample data
      donationHistory = [
        {
          'amount': '1',
          'item': 'Baju Bekas Layak Pakai',
          'orphanageName': 'Panti Asuhan Kasih Ibu',
          'date': '10 Apr 2025',
          'message': 'Semoga berkah',
        },
        {
          'amount': '10',
          'item': 'Buku Pelajaran SD',
          'orphanageName': 'Rumah Yatim Piatu Nur Iman',
          'date': '28 Mar 2025',
          'message': 'Semoga bermanfaat untuk pendidikan',
        },
        {
          'amount': '5',
          'item': 'Paket Sembako',
          'orphanageName': 'Panti Asuhan Cahaya Kasih',
          'date': '2 Mar 2025',
          'message': 'Untuk kebutuhan sehari-hari',
        },
        {
          'amount': '3',
          'item': 'Mainan Anak',
          'orphanageName': 'Panti Asuhan Kasih Ibu',
          'date': '15 Feb 2025',
          'message': 'Semoga anak-anak senang',
        },
        {
          'amount': '2',
          'item': 'Set Alat Tulis',
          'orphanageName': 'Panti Asuhan Harapan Baru',
          'date': '5 Feb 2025',
          'message': 'Untuk menunjang kegiatan belajar',
        },
      ];
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching donation history: $e');
      showCustomSnackBar('Gagal mengambil riwayat donasi: $e');
      setState(() {
        _isLoading = false;
      });
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

  Widget buildDonationHistorySection() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Text(
                "Riwayat Donasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            if (donationHistory.isEmpty)
              _buildEmptyDonationHistory()
            else
              _buildDonationHistoryList(donationHistory),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDonationHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/donation_options');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonationHistoryList(List<Map<String, dynamic>> donations) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: donations.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade200,
        thickness: 1,
        indent: 24,
        endIndent: 24,
      ),
      itemBuilder: (context, index) {
        final donation = donations[index];
        
        return InkWell(
          onTap: () {
            // Show donation details
            _showDonationDetailsDialog(donation);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Donation icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.packageOpen,
                    color: Colors.amber.shade500,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation['orphanageName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${donation['amount']} ${donation['item']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            donation['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDonationDetailsDialog(Map<String, dynamic> donation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Detail Donasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow("Panti Asuhan", donation['orphanageName']),
                _buildDetailRow("Barang", "${donation['amount']} ${donation['item']}"),
                _buildDetailRow("Tanggal", donation['date']),
                _buildDetailRow("Pesan", donation['message']),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade600,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Donasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  buildDonationHistorySection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}