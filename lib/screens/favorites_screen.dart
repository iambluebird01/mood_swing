import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().fetchFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorites yet!'));
          }

          final movies = snapshot.data!.docs;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              // Explicitly cast to Map<String, dynamic>
              final movie = movies[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(movie['title'] ?? 'No Title'),
                subtitle: Text('Rating: ${movie['vote_average'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}
