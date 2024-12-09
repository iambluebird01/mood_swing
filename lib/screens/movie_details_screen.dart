import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/movie_service.dart';
import '../services/firestore_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Map<String, dynamic>? movieDetails;
  String? trailerKey;
  Map<String, dynamic>? watchProviders;

  @override
  void initState() {
    super.initState();
    fetchMovieData();
  }

  Future<void> fetchMovieData() async {
    try {
      final movieService = MovieService();
      final details = await movieService.fetchMovieDetails(widget.movieId);
      final trailer = await movieService.fetchMovieTrailer(widget.movieId);
      final providers = await movieService.fetchWatchProviders(widget.movieId);

      setState(() {
        movieDetails = details;
        trailerKey = trailer;
        watchProviders = providers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movie details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movieDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Movie Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(movieDetails!['title'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movieDetails!['poster_path']}',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              movieDetails!['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Rating
            Text('Rating: ${movieDetails!['vote_average']} / 10'),
            const SizedBox(height: 10),
            // Overview
            Text(movieDetails!['overview'] ?? 'No description available'),
            const SizedBox(height: 20),
            // YouTube Trailer
            if (trailerKey != null) ...[
              const Text(
                'Watch Trailer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: trailerKey!,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
              ),
              const SizedBox(height: 20),
            ],
            // Watch Providers
            if (watchProviders != null &&
                (watchProviders!['flatrate'] ?? []).isNotEmpty) ...[
              const Text(
                'Available On',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: (watchProviders!['flatrate'] as List)
                    .map((provider) => Chip(
                          label: Text(provider['provider_name']),
                          avatar: Image.network(
                            'https://image.tmdb.org/t/p/w92${provider['logo_path']}',
                            width: 30,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
            // Add to Favorites
            ElevatedButton.icon(
              icon: const Icon(Icons.favorite),
              label: const Text('Add to Favorites'),
              onPressed: () async {
                await FirestoreService().saveFavoriteMovie(movieDetails!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Favorites')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
