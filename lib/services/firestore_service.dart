import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menyimpan Donasi ke Firestore
  Future<void> saveDonation({
    required String item,
    required int amount,
    required String userId,
    required String pantiId,
  }) async {
    await _firestore.collection('donations').add({
      'item': item,
      'amount': amount,
      'userId': userId,
      'pantiId': pantiId,
      'date': DateTime.now(),
      'status': 'pending', // Status donasi default
    });
  }
}
