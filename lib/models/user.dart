class User {
  final String fullname;
  final String email;
  final String nomorhp;
  final String role;
  final String password;

  User({
    required this.fullname,
    required this.email,
    required this.nomorhp,
    required this.role,
    required this.password
  });

  // Membuat User dari data Firestore
  factory User.fromFirestore(Map<String, dynamic> firestoreData) {
    return User(
      fullname: firestoreData['fullname'],
      email: firestoreData['email'],
      nomorhp: firestoreData['nomorhp'],
      role: firestoreData['role'],
      password: firestoreData['password'],
    );
  }
}