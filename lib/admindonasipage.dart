import 'package:flutter/material.dart';

class AdminDonasiPage extends StatefulWidget {
  final String namaPanti;

  const AdminDonasiPage({Key? key, required this.namaPanti}) : super(key: key);

  @override
  _AdminDonasiPageState createState() => _AdminDonasiPageState();
}

class _AdminDonasiPageState extends State<AdminDonasiPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> donasiList = [
    {'nama': 'Baju Anak', 'jumlah': 10, 'icon': Icons.checkroom, 'color': Color(0xFF5C6BC0)},
    {'nama': 'Buku Cerita', 'jumlah': 5, 'icon': Icons.book, 'color': Color(0xFF26A69A)},
    {'nama': 'Mainan Edukasi', 'jumlah': 8, 'icon': Icons.toys, 'color': Color(0xFFEF5350)},
    {'nama': 'Selimut', 'jumlah': 12, 'icon': Icons.bed, 'color': Color(0xFF66BB6A)},
    {'nama': 'Tas Sekolah', 'jumlah': 6, 'icon': Icons.school, 'color': Color(0xFFFFB74D)},
  ];
  
  List<Map<String, dynamic>> filteredDonasiList = [];
  
  bool isAdding = false;
  
  @override
  void initState() {
    super.initState();
    filteredDonasiList = List.from(donasiList);
  }

  void filterDonasi(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDonasiList = List.from(donasiList);
      });
    } else {
      setState(() {
        filteredDonasiList = donasiList
            .where((item) => item['nama'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void tambahDonasi() {
    final nama = _namaBarangController.text.trim();
    final jumlah = int.tryParse(_jumlahController.text.trim());

    if (nama.isNotEmpty && jumlah != null && jumlah > 0) {
      // Assign a random icon and color from predefined list
      final List<IconData> icons = [
        Icons.checkroom, Icons.book, Icons.toys, Icons.bed, 
        Icons.school, Icons.fastfood, Icons.medical_services, 
        Icons.sports_soccer, Icons.headphones
      ];
      
      final List<Color> colors = [
        Color(0xFF5C6BC0), Color(0xFF26A69A), Color(0xFFEF5350),
        Color(0xFF66BB6A), Color(0xFFFFB74D), Color(0xFFBA68C8),
        Color(0xFF9CCC65), Color(0xFF42A5F5), Color(0xFFFFA726)
      ];
      
      setState(() {
        donasiList.add({
          'nama': nama, 
          'jumlah': jumlah,
          'icon': icons[donasiList.length % icons.length],
          'color': colors[donasiList.length % colors.length]
        });
        filteredDonasiList = List.from(donasiList);
        _namaBarangController.clear();
        _jumlahController.clear();
        isAdding = false;
      });
    }
  }

  void hapusDonasi(int index) {
    final int realIndex = donasiList.indexOf(filteredDonasiList[index]);
    setState(() {
      donasiList.removeAt(realIndex);
      filteredDonasiList = List.from(donasiList.where((item) => 
        item['nama'].toLowerCase().contains(_searchController.text.toLowerCase())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF26A69A), Color(0xFF00897B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(top: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: isAdding
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: Colors.red,
                    mini: true,
                    onPressed: () {
                      setState(() {
                        isAdding = false;
                        _namaBarangController.clear();
                        _jumlahController.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: tambahDonasi,
                    backgroundColor: const Color(0xFF00897B),
                    icon: const Icon(Icons.check),
                    label: const Text("Simpan"),
                  ),
                ],
              )
            : FloatingActionButton.extended(
                heroTag: "btn3",
                onPressed: () {
                  setState(() {
                    isAdding = true;
                  });
                },
                backgroundColor: const Color(0xFF00897B),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Donasi"),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Donasi',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.namaPanti,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.print_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: filterDonasi,
                    decoration: InputDecoration(
                      hintText: 'Cari donasi...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    // Implementasi filter
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter belum diimplementasikan')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDonasiSummary(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Donasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              Text(
                '${filteredDonasiList.length} item',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isAdding ? _buildAddDonasiForm() : _buildDonasiList(),
        ),
      ],
    );
  }

  Widget _buildDonasiSummary() {
    int totalItems = donasiList.fold(0, (sum, item) => sum + (item['jumlah'] as int));
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildSummaryCard(
            title: 'Total Jenis',
            value: '${donasiList.length}',
            icon: Icons.category,
            color: const Color(0xFF5C6BC0),
          ),
          const SizedBox(width: 15),
          _buildSummaryCard(
            title: 'Total Barang',
            value: '$totalItems',
            icon: Icons.inventory_2,
            color: const Color(0xFFEF5350),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDonasiList() {
    if (filteredDonasiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada donasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan donasi baru dengan tombol di bawah',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredDonasiList.length,
      itemBuilder: (context, index) {
        final item = filteredDonasiList[index];
        return Dismissible(
          key: Key(item['nama'] + index.toString()),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 26,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            hapusDonasi(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'],
                  color: item['color'],
                  size: 24,
                ),
              ),
              title: Text(
                item['nama'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Jumlah: ${item['jumlah']}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.blue[400]),
                    onPressed: () {
                      // Implementasi edit
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit belum diimplementasikan')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                    onPressed: () => hapusDonasi(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddDonasiForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Donasi Baru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _namaBarangController,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Kategori dropdown bisa ditambahkan di sini
              ],
            ),
          ),
        ],
      ),
    );
  }
}