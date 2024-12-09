import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'mood_selection_screen.dart';
import 'favorites_screen.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodSwing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Choose Your Mood',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MoodSelectionScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Favorites',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FavoritesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
