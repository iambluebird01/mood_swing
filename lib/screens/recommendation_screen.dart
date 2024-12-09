import 'package:flutter/material.dart';
import '../services/recommendations_service.dart';

class RecommendationScreen extends StatelessWidget {
  final String userId = "user123"; // Replace with actual user ID
  final String currentMood = "Happiness"; // Replace with the selected mood

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Recommendations"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            RecommendationService().getRecommendedMovies(currentMood, userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final movies = snapshot.data ?? [];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                title: Text(movie['title']),
                subtitle: Text(movie['genre']),
              );
            },
          );
        },
      ),
    );
  }
}
