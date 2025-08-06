class AppConstants {
  // TMDB API Configuration
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MmUwMGZmYzZkNmZkNzlhZjgzYzYzZmU0ZjMxYTI0NyIsIm5iZiI6MTc1NDM2NDkyNC43NzUsInN1YiI6IjY4OTE3YmZjMTU4NGJmNmM5ZjYxZjkxZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6eG70ObstDVucMYm5YnVKzNNbUqeUuHs99azJ-w_V1c'; // Replace with your actual API key
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';
  static const String language = 'en-US';
  
  // App Configuration
  static const String appName = 'MovieDB';
  static const String appVersion = '1.0.0';
  
  // Database Configuration
  static const String databaseName = 'movies_database.db';
  static const int databaseVersion = 1;
  
  // Search Configuration
  static const int searchDebounceTime = 500; // milliseconds
  
  // Deep Link Configuration
  static const String deepLinkScheme = 'moviedb';
  static const String deepLinkHost = 'movie';
} 