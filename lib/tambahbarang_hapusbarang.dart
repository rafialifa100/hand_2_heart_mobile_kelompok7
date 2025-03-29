import 'package:flutter/material.dart';

class TambahBarangHapusBarangPage extends StatefulWidget {
  const TambahBarangHapusBarangPage({Key? key}) : super(key: key);

  @override
  _TambahBarangHapusBarangPageState createState() =>
      _TambahBarangHapusBarangPageState();
}

class _TambahBarangHapusBarangPageState
    extends State<TambahBarangHapusBarangPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  // List untuk menyimpan item donasi, masing-masing item merupakan map
  final List<Map<String, String>> _donationItems = [];

  void _addItem() {
    final nama = _namaBarangController.text.trim();
    final jumlah = _jumlahController.text.trim();

    if (nama.isNotEmpty && jumlah.isNotEmpty) {
      setState(() {
        _donationItems.add({'nama': nama, 'jumlah': jumlah});
      });
      // Kosongkan field setelah menambah item
      _namaBarangController.clear();
      _jumlahController.clear();
    }
  }

  void _removeItem(int index) {
    setState(() {
      _donationItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah & Hapus Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form untuk menambah item donasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah Item Donasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaBarangController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jumlahController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Tambah Item'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tampilan daftar item donasi
            Expanded(
              child: Container(
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
                      'Daftar Kebutuhan Donasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _donationItems.length,
                        itemBuilder: (context, index) {
                          final item = _donationItems[index];
                          final nama = item['nama'] ?? '';
                          final jumlah = item['jumlah'] ?? '';
                          return ListTile(
                            title: Text(nama),
                            subtitle: Text('Jumlah: $jumlah buah'),
                            trailing: TextButton(
                              onPressed: () => _removeItem(index),
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol untuk kembali ke halaman sebelumnya
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
