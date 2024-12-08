import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import 'movie_details_screen.dart';

class MoodSelectionScreen extends StatelessWidget {
  final Map<String, String> moods = {
    'Happy': '35', // Comedy
    'Sad': '18', // Drama
    'Excited': '28', // Action
    'Romantic': '10749', // Romance
    'Scared': '27', // Horror
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Mood')),
      body: ListView.builder(
        itemCount: moods.keys.length,
        itemBuilder: (context, index) {
          final mood = moods.keys.elementAt(index);
          final genreId = moods[mood]!;
          return ListTile(
            title: Text(mood),
            onTap: () async {
              final movies = await MovieService().fetchMoviesByMood(genreId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MoviesListScreen(mood: mood, movies: movies),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MoviesListScreen extends StatelessWidget {
  final String mood;
  final List movies;

  const MoviesListScreen({required this.mood, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$mood Movies')),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            title: Text(movie['title']),
            subtitle: Text('Rating: ${movie['vote_average']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movie['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
