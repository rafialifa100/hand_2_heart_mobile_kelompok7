import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String item;
  final int amount;
  final DateTime date;
  final String userId;
  final String pantiId;

  Donation({
    required this.item,
    required this.amount,
    required this.date,
    required this.userId,
    required this.pantiId,
  });

  // Membuat Donation dari data Firestore
  factory Donation.fromFirestore(Map<String, dynamic> firestoreData) {
    return Donation(
      item: firestoreData['item'],
      amount: firestoreData['amount'],
      date: (firestoreData['date'] as Timestamp).toDate(),
      userId: firestoreData['userId'],
      pantiId: firestoreData['pantiId'],
    );
  }
}