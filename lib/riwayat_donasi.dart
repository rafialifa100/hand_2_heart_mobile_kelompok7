import 'package:flutter/material.dart';

/// Komponen untuk Riwayat Donasi
class RiwayatDonasi extends StatelessWidget {
  const RiwayatDonasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat donasi (update sesuai struktur di donasibarang.dart)
    final List<Map<String, String>> donationHistory = [
      {
        'panti': 'Panti Fesnuk (Ngawi)',
        'barang': 'Kursi Cukur',
        'jumlah': '5',
        'tanggal': '28-03-2025',
        'pesan': 'Semoga berkah!',
      },
      {
        'panti': 'Panti Asuhan Dharma (Bandung)',
        'barang': 'Alat Cukur',
        'jumlah': '10',
        'tanggal': '20-03-2025',
        'pesan': 'Untuk masa depan lebih cerah!',
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
            'Riwayat Donasi (contoh sementara)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Gunakan Expanded agar tidak error pada ListView
          Expanded(
            child: ListView.builder(
              itemCount: donationHistory.length,
              itemBuilder: (context, index) {
                final history = donationHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('${history['barang']} untuk ${history['panti']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah: ${history['jumlah']} buah'),
                        Text('Tanggal: ${history['tanggal']}'),
                        Text('Pesan: ${history['pesan']}'),
                      ],
                    ),
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
