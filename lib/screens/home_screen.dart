import 'package:flutter/material.dart';
import 'mood_selection_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoodSwing')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MoodSelectionScreen()),
              );
            },
            child: const Text('Choose Your Mood'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen()),
              );
            },
            child: const Text('View Favorites'),
          ),
        ],
      ),
    );
  }
}
