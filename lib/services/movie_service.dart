import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = 'aad751ebf88e2efc6153dc30a93b624e';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // Fetch movies by mood (genre)
  Future<List<Map<String, dynamic>>> fetchMoviesByMood(String genreId) async {
    final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId&sort_by=popularity.desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        throw Exception('No movies found for this mood.');
      }

      return results.cast<Map<String, dynamic>>(); // Safely cast results
    } else {
      throw Exception('Failed to fetch movies: ${response.reasonPhrase}');
    }
  }

  // Fetch movie details
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // Fetch movie trailers
  Future<String?> fetchMovieTrailer(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      final trailer = results.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      return trailer?['key']; // YouTube video key
    } else {
      throw Exception('Failed to load movie trailers');
    }
  }

  // Fetch watch providers
  Future<Map<String, dynamic>> fetchWatchProviders(int movieId) async {
    final url =
        Uri.parse('$_baseUrl/movie/$movieId/watch/providers?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']['US'] ?? {}; // Fetch providers for the US region
    } else {
      throw Exception('Failed to load watch providers');
    }
  }
}
