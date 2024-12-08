import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../services/firestore_service.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MovieService().fetchMovieDetails(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movie = snapshot.data as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(title: Text(movie['title'])),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Rating: ${movie['vote_average']}'),
                const SizedBox(height: 10),
                Text(movie['overview']),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirestoreService().saveFavoriteMovie(movie);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Favorites')),
                    );
                  },
                  child: const Text('Add to Favorites'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
