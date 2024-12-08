import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a movie to the favorites collection
  Future<void> saveFavoriteMovie(Map<String, dynamic> movie) async {
    try {
      await _db.collection('favorites').add(movie);
    } catch (e) {
      throw Exception('Failed to save favorite movie: $e');
    }
  }

  // Fetch all favorite movies from Firestore
  Stream<QuerySnapshot> fetchFavoriteMovies() {
    return _db.collection('favorites').snapshots();
  }
}
