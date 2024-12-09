// mood_genre_mapper.dart
class MoodGenreMapper {
  static Map<String, List<String>> moodToGenres = {
    'Sadness': ['Drama', 'Biography'],
    'Happiness': ['Comedy', 'Animation', 'Family'],
    'Excitement': ['Action', 'Adventure', 'Thriller'],
    'Romance': ['Romance', 'Drama'],
    'Fear': ['Horror', 'Mystery', 'Psychological Thriller'],
  };

  static List<String> getGenresForMood(String mood) {
    return moodToGenres[mood] ?? [];
  }
}
