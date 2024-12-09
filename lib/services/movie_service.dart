import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = 'aad751ebf88e2efc6153dc30a93b624e';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // Fetch movies by mood (genre)
  Future<List> fetchMoviesByMood(String genreId) async {
    final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId&sort_by=popularity.desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
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
}
