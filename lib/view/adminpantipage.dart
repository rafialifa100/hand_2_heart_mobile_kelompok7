import 'package:flutter/material.dart';

class AdminPantiPage extends StatefulWidget {
  const AdminPantiPage({Key? key}) : super(key: key);

  @override
  _AdminPantiPageState createState() => _AdminPantiPageState();
}

class _AdminPantiPageState extends State<AdminPantiPage> {
  final TextEditingController _namaPantiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> pantiList = [
    {
      'nama': 'Panti Asuhan Kasih Ibu',
      'alamat': 'Jl. Melati No.12, Jakarta Selatan',
      'telp': '021-55667788',
      'deskripsi': 'Panti asuhan untuk anak-anak yatim piatu usia 5-15 tahun',
      'icon': Icons.home_outlined,
      'color': Color(0xFF5C6BC0),
      'image': 'building_1.jpg'
    },
    {
      'nama': 'Panti Yatim Mandiri',
      'alamat': 'Jl. Kenanga No.34, Bandung',
      'telp': '022-11223344',
      'deskripsi': 'Panti yang berfokus pada pendidikan dan keterampilan',
      'icon': Icons.child_care,
      'color': Color(0xFFEF5350),
      'image': 'building_2.jpg'
    },
    {
      'nama': 'Panti Asuhan Pelita Hati',
      'alamat': 'Jl. Anggrek No.78, Surabaya',
      'telp': '031-99887766',
      'deskripsi': 'Panti khusus untuk balita dan anak-anak dengan kebutuhan khusus',
      'icon': Icons.favorite_outline,
      'color': Color(0xFF26A69A),
      'image': 'building_3.jpg'
    },
  ];
  
  List<Map<String, dynamic>> filteredPantiList = [];
  bool isAdding = false;
  
  @override
  void initState() {
    super.initState();
    filteredPantiList = List.from(pantiList);
  }

  void filterPanti(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPantiList = List.from(pantiList);
      });
    } else {
      setState(() {
        filteredPantiList = pantiList
            .where((item) => item['nama'].toLowerCase().contains(query.toLowerCase()) ||
                             item['alamat'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void tambahPanti() {
    final nama = _namaPantiController.text.trim();
    final alamat = _alamatController.text.trim();
    final telp = _nomorTeleponController.text.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (nama.isNotEmpty && alamat.isNotEmpty) {
      // Assign a color and icon from predefined list
      final List<IconData> icons = [
        Icons.home_outlined, Icons.child_care, Icons.favorite_outline, 
        Icons.volunteer_activism, Icons.group_outlined
      ];
      
      final List<Color> colors = [
        Color(0xFF5C6BC0), Color(0xFFEF5350), Color(0xFF26A69A),
        Color(0xFFFFB74D), Color(0xFF9CCC65)
      ];
      
      final List<String> images = [
        'building_1.jpg', 'building_2.jpg', 'building_3.jpg'
      ];
      
      setState(() {
        pantiList.add({
          'nama': nama,
          'alamat': alamat,
          'telp': telp.isNotEmpty ? telp : '-',
          'deskripsi': deskripsi.isNotEmpty ? deskripsi : 'Tidak ada deskripsi',
          'icon': icons[pantiList.length % icons.length],
          'color': colors[pantiList.length % colors.length],
          'image': images[pantiList.length % images.length]
        });
        filteredPantiList = List.from(pantiList);
        _namaPantiController.clear();
        _alamatController.clear();
        _nomorTeleponController.clear();
        _deskripsiController.clear();
        isAdding = false;
      });
    }
  }

  void hapusPanti(int index) {
    final int realIndex = pantiList.indexOf(filteredPantiList[index]);
    setState(() {
      pantiList.removeAt(realIndex);
      filteredPantiList = List.from(pantiList.where((item) => 
        item['nama'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        item['alamat'].toLowerCase().contains(_searchController.text.toLowerCase())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
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
                        _namaPantiController.clear();
                        _alamatController.clear();
                        _nomorTeleponController.clear();
                        _deskripsiController.clear();
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: tambahPanti,
                    backgroundColor: const Color(0xFF1976D2),
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
                backgroundColor: const Color(0xFF1976D2),
                icon: const Icon(Icons.add_home),
                label: const Text("Tambah Panti"),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manajemen Panti',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelola data panti asuhan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
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
              Icons.info_outline,
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
                    onChanged: filterPanti,
                    decoration: InputDecoration(
                      hintText: 'Cari panti asuhan...',
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
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: const Icon(Icons.sort, color: Colors.white),
                  onPressed: () {
                    // Implementasi sort
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sortir belum diimplementasikan')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildPantiSummary(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Panti Asuhan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              Text(
                '${filteredPantiList.length} panti',
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
          child: isAdding ? _buildAddPantiForm() : _buildPantiList(),
        ),
      ],
    );
  }

  Widget _buildPantiSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Panti Terdaftar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${pantiList.length} Panti Asuhan',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPantiList() {
    if (filteredPantiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.home_work_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada panti asuhan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan panti baru dengan tombol di bawah',
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
      itemCount: filteredPantiList.length,
      itemBuilder: (context, index) {
        final panti = filteredPantiList[index];
        return Dismissible(
          key: Key(panti['nama'] + index.toString()),
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
            hapusPanti(index);
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
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: panti['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  panti['icon'],
                  color: panti['color'],
                  size: 24,
                ),
              ),
              title: Text(
                panti['nama'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                panti['alamat'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                    onPressed: () => hapusPanti(index),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(panti['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: panti['color'].withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Lihat Detail',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 8),
                          Text(
                            panti['telp'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        panti['deskripsi'],
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              // Navigasi ke halaman kelola donasi
                              Navigator.pushNamed(context, '/admin/donasi');
                            },
                            icon: const Icon(Icons.inventory_2_outlined),
                            label: const Text('Kelola Donasi'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: panti['color']),
                              foregroundColor: panti['color'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddPantiForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Panti Baru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                    // Form untuk upload foto
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.grey[500], size: 36),
                          const SizedBox(height: 8),
                          Text(
                            'Unggah Foto Panti',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _namaPantiController,
                      decoration: InputDecoration(
                        labelText: 'Nama Panti',
                        prefixIcon: const Icon(Icons.home_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat Lengkap',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomorTeleponController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 64),
                          child: Icon(Icons.description_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dropdown kategori atau input tambahan bisa ditambahkan di sini
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}