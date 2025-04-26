import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Admin menambahkan barang yang dibutuhkan oleh panti
  Future<void> addBarangToPanti({
    required String pantiId,
    required String namaBarang,
    required int jumlah,
  }) async {
    await _firestore.collection('barang').add({
      'namaBarang': namaBarang,
      'jumlah': jumlah,
      'pantiId': pantiId,
    });
  }

  // Admin menambahkan panti asuhan baru
  Future<void> addPantiAsuhan({
    required String namaPanti,
    required String kota,
  }) async {
    await _firestore.collection('panti_asuhan').add({
      'namaPanti': namaPanti,
      'kota': kota,
    });
  }
}