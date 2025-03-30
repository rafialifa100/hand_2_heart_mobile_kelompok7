import 'package:flutter/material.dart';

/// Komponen untuk Riwayat Donasi
class RiwayatDonasi extends StatelessWidget {
  const RiwayatDonasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat donasi
    final List<Map<String, String>> donationHistory = [
      {
        'nama': 'Susu Bubuk',
        'jumlah': '3',
        'tanggal': '29-03-2025',
        'pesan': 'Terima kasih atas donasi ini!',
      },
      {
        'nama': 'Beras',
        'jumlah': '5',
        'tanggal': '28-03-2025',
        'pesan': 'Semoga berkah!',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Donasi (contoh tampilan sementara)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: donationHistory.length,
              itemBuilder: (context, index) {
                final history = donationHistory[index];
                return ListTile(
                  title: Text(history['nama'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah: ${history['jumlah']} buah'),
                      Text('Tanggal: ${history['tanggal']}'),
                      Text('Pesan: ${history['pesan']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
