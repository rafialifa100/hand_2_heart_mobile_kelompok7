class User {
  final String uid;
  final String username;
  final String email;
  final String role;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
  });

  // Membuat User dari data Firestore
  factory User.fromFirestore(Map<String, dynamic> firestoreData) {
    return User(
      uid: firestoreData['uid'],
      username: firestoreData['username'],
      email: firestoreData['email'],
      role: firestoreData['role'],
    );
  }
}