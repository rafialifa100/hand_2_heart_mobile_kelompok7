import 'package:flutter/material.dart';

/// Model data untuk kebutuhan barang di panti asuhan
class NeededItem {
  final String name;
  int needed; // jumlah yang masih dibutuhkan

  NeededItem({required this.name, required this.needed});
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
  const DonationFlowPage({super.key});

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

  Orphanage? _selectedOrphanage;
  NeededItem? _selectedItem;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _messageController =
      TextEditingController(); // Controller untuk pesan

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
        'Jumlah donasi melebihi kebutuhan (${_selectedItem!.needed}).',
      );
      return;
    }

    // Pesan opsional, tidak wajib diisi
    final message = _messageController.text.trim();

    setState(() {
      _selectedItem!.needed -= quantity;
    });

    _showSuccessDialog();
  }

  /// Menampilkan error menggunakan SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  /// Menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Donasi Berhasil!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Terimakasih telah berdonasi untuk panti asuhan',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _quantityController.clear();
                  _messageController.clear(); // Kosongkan pesan
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Widget _buildOrphanageDropdown() {
    return DropdownButton<Orphanage>(
      hint: const Text('Pilih Panti Asuhan'),
      value: _selectedOrphanage,
      isExpanded: true,
      items:
          _orphanages.map((orphanage) {
            return DropdownMenuItem<Orphanage>(
              value: orphanage,
              child: Text('${orphanage.name} (${orphanage.location})'),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedOrphanage = value;
          _selectedItem = null;
        });
      },
    );
  }

  Widget _buildItemDropdown() {
    if (_selectedOrphanage == null) {
      return const SizedBox();
    }

    final neededItems = _selectedOrphanage!.neededItems;
    return DropdownButton<NeededItem>(
      hint: const Text('Pilih Barang'),
      value: _selectedItem,
      isExpanded: true,
      items:
          neededItems.map((item) {
            return DropdownMenuItem<NeededItem>(
              value: item,
              child: Text('${item.name} (Butuh: ${item.needed})'),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedItem = value;
        });
      },
    );
  }

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

  Widget _buildMessageField() {
    return TextField(
      controller: _messageController,
      decoration: const InputDecoration(
        labelText: 'Pesan untuk Panti Asuhan (Opsional)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
    );
  }

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
    return Scaffold(
      appBar: AppBar(title: const Text('Permintaan Donasi Panti Asuhan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOrphanageDropdown(),
            const SizedBox(height: 16),
            _buildItemDropdown(),
            const SizedBox(height: 16),
            _buildQuantityField(),
            const SizedBox(height: 16),
            _buildMessageField(),
            const SizedBox(height: 16),
            _buildDonateButton(),
            const SizedBox(height: 16),
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
