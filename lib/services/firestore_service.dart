import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch user preferences
  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? doc.data()! : {};
  }

  // Save user preferences
  Future<void> saveUserPreferences(
      String userId, Map<String, dynamic> preferences) async {
    await _db
        .collection('users')
        .doc(userId)
        .set(preferences, SetOptions(merge: true));
  }

  // Save a movie to the favorites collection
  Future<void> saveFavoriteMovie(Map<String, dynamic> movie) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _db.collection('favorites').add({
        ...movie,
        'userId': userId, // Add the userId to the document
        'createdAt':
            FieldValue.serverTimestamp(), // Add a timestamp for sorting
      });
    } catch (e) {
      throw Exception('Failed to save favorite movie: $e');
    }
  }

  // Fetch all favorite movies from Firestore
  Stream<QuerySnapshot> fetchFavoriteMovies() {
    return _db.collection('favorites').snapshots();
  }

  // Delete a movie from the favorites collection
  Future<void> deleteFavoriteMovie(String id) async {
    try {
      await _db.collection('favorites').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete favorite movie: $e');
    }
  }
}
