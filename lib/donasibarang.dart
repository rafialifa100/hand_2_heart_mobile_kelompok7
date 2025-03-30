import 'package:flutter/material.dart';

/// Model data untuk kebutuhan barang di panti asuhan
class NeededItem {
  final String name;
  int needed; // jumlah yang masih dibutuhkan

  NeededItem({
    required this.name,
    required this.needed,
  });
}

/// Model data untuk panti asuhan
class Orphanage {
  final String name;
  final String location;
  final List<NeededItem> neededItems;

  Orphanage({
    required this.name,
    required this.location,
    required this.neededItems,
  });
}

/// Halaman untuk melakukan donasi
class DonationFlowPage extends StatefulWidget {
  const DonationFlowPage({Key? key}) : super(key: key);

  @override
  State<DonationFlowPage> createState() => _DonationFlowPageState();
}

class _DonationFlowPageState extends State<DonationFlowPage> {
  // Daftar panti asuhan (contoh data statis/dummy)
  final List<Orphanage> _orphanages = [
    Orphanage(
      name: 'Panti Asuhan Dharma',
      location: 'Bandung',
      neededItems: [
        NeededItem(name: 'Alat Cukur', needed: 100),
        NeededItem(name: 'Kursi Cukur', needed: 20),
      ],
    ),
    Orphanage(
      name: 'Panti Asuhan Darma Jaya',
      location: 'Jakarta',
      neededItems: [
        NeededItem(name: 'Alat Tulis', needed: 50),
        NeededItem(name: 'Buku Cerita', needed: 30),
      ],
    ),
    Orphanage(
      name: 'Panti Fesnuk',
      location: 'Ngawi',
      neededItems: [
        NeededItem(name: 'Alat Cukur', needed: 166),
        NeededItem(name: 'Kursi Cukur', needed: 99),
      ],
    ),
  ];

  // Panti asuhan yang dipilih
  Orphanage? _selectedOrphanage;
  // Barang yang dipilih
  NeededItem? _selectedItem;
  // Controller untuk jumlah donasi
  final TextEditingController _quantityController = TextEditingController();

  /// Validasi dan proses donasi
  void _donate() {
    if (_selectedOrphanage == null) {
      _showError('Pilih panti asuhan terlebih dahulu.');
      return;
    }
    if (_selectedItem == null) {
      _showError('Pilih barang yang ingin didonasikan.');
      return;
    }

    final rawQuantity = _quantityController.text.trim();
    if (rawQuantity.isEmpty) {
      _showError('Masukkan jumlah barang yang ingin didonasikan.');
      return;
    }

    final quantity = int.tryParse(rawQuantity);
    if (quantity == null || quantity <= 0) {
      _showError('Jumlah donasi harus lebih dari 0.');
      return;
    }

    // Pastikan jumlah tidak melebihi kebutuhan
    if (quantity > _selectedItem!.needed) {
      _showError(
          'Jumlah donasi melebihi kebutuhan (${_selectedItem!.needed}).');
      return;
    }

    // Jika lolos validasi, kurangi jumlah needed
    setState(() {
      _selectedItem!.needed -= quantity;
    });

    // Tampilkan dialog "Donasi Berhasil!"
    _showSuccessDialog();
  }

  /// Menampilkan error menggunakan SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tulisan "Donasi Berhasil!" berwarna hijau
            Text(
              'Donasi Berhasil!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Tulisan "Terimakasih telah berdonasi..."
            const Text(
              'Terimakasih telah berdonasi untuk panti asuhan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _quantityController.clear(); // Kosongkan jumlah
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Widget dropdown panti asuhan
  Widget _buildOrphanageDropdown() {
    return DropdownButton<Orphanage>(
      hint: const Text('Pilih Panti Asuhan'),
      value: _selectedOrphanage,
      isExpanded: true,
      items: _orphanages.map((orphanage) {
        return DropdownMenuItem<Orphanage>(
          value: orphanage,
          child: Text('${orphanage.name} (${orphanage.location})'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedOrphanage = value;
          // Reset item yang dipilih ketika berganti panti
          _selectedItem = null;
        });
      },
    );
  }

  /// Widget dropdown barang yang dibutuhkan oleh panti terpilih
  Widget _buildItemDropdown() {
    if (_selectedOrphanage == null) {
      return const SizedBox();
    }

    final neededItems = _selectedOrphanage!.neededItems;
    return DropdownButton<NeededItem>(
      hint: const Text('Pilih Barang'),
      value: _selectedItem,
      isExpanded: true,
      items: neededItems.map((item) {
        return DropdownMenuItem<NeededItem>(
          value: item,
          child: Text(
              '${item.name} (Butuh: ${item.needed})'), // Tampilkan sisa kebutuhan
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
        });
      },
    );
  }

  /// Form input jumlah donasi
  Widget _buildQuantityField() {
    return TextField(
      controller: _quantityController,
      decoration: const InputDecoration(
        labelText: 'Jumlah yang Didonasikan',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  /// Tombol Donasi
  Widget _buildDonateButton() {
    return ElevatedButton(
      onPressed: _donate,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text('Donasi'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Contoh tampilan sederhana (column)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Donasi Panti Asuhan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Panti Asuhan
            _buildOrphanageDropdown(),
            const SizedBox(height: 16),
            // Dropdown Barang
            _buildItemDropdown(),
            const SizedBox(height: 16),
            // Input jumlah
            _buildQuantityField(),
            const SizedBox(height: 16),
            // Tombol Donasi
            _buildDonateButton(),
            const SizedBox(height: 16),
            // Contoh tampilan sisa kebutuhan item yang dipilih (opsional)
            if (_selectedItem != null)
              Text(
                'Sisa kebutuhan untuk ${_selectedItem!.name}: ${_selectedItem!.needed}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
