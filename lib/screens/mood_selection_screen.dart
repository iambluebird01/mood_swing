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

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  final movies =
                      await MovieService().fetchMoviesByMood(genreId);

                  if (movies.isEmpty) {
                    throw Exception('No movies found for this mood.');
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoviesListScreen(
                        mood: mood,
                        movies: movies,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade100, Colors.teal.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      mood,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MoviesListScreen extends StatelessWidget {
  final String mood;
  final List<Map<String, dynamic>> movies;

  const MoviesListScreen({required this.mood, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$mood Movies')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movie['id']),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie['title'] ?? 'No Title',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
