// recommendation_service.dart
import 'package:flutter/material.dart';
import 'mood_genre_mapper.dart';
import 'firestore_service.dart';

class RecommendationService {
  final FirestoreService _firestoreService = FirestoreService();

  // Fetch recommendations based on mood and user preferences
  Future<List<Map<String, dynamic>>> getRecommendedMovies(
      String mood, String userId) async {
    final userPreferences = await _firestoreService.getUserPreferences(userId);
    final moodGenres = MoodGenreMapper.getGenresForMood(mood);

    // Fetch movies by genre
    final movies = await _fetchMoviesByGenres(moodGenres);

    // Filter based on user preferences (favorite genres and watch history)
    final filteredMovies = movies.where((movie) {
      final genreMatch =
          userPreferences['favoriteGenres'].contains(movie['genre']);
      final watchedBefore =
          userPreferences['watchedMovies'].contains(movie['id']);
      return genreMatch && !watchedBefore;
    }).toList();

    return filteredMovies.take(10).toList(); // Return top 10 recommended movies
  }

  // Mock method to fetch movies by genres (replace with real DB or API call)
  Future<List<Map<String, dynamic>>> _fetchMoviesByGenres(
      List<String> genres) async {
    // Simulate fetching movies based on genres
    return [
      {
        'id': '1',
        'title': 'Movie 1',
        'genre': 'Drama',
        'moodCategory': 'Sadness'
      },
      {
        'id': '2',
        'title': 'Movie 2',
        'genre': 'Comedy',
        'moodCategory': 'Happiness'
      },
      {
        'id': '3',
        'title': 'Movie 3',
        'genre': 'Action',
        'moodCategory': 'Excitement'
      },
    ];
  }
}
