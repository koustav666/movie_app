import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/api_response.dart';
import '../constants/app_constants.dart';
import 'tmdb_api_service.dart';
import 'database_service.dart';
import 'image_service.dart';

class MovieRepository {
  final TMDBApiService _apiService;
  final DatabaseService _databaseService;

  MovieRepository()
      : _apiService = TMDBApiService(
          Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Authorization': 'Bearer ${AppConstants.apiKey}',
              'accept': 'application/json',
            },
          )),
        ),
        _databaseService = DatabaseService();

  // Fetch genres from API and update the genre map
  Future<void> loadGenres() async {
    try {
      final response = await _apiService.getGenres(AppConstants.language);
      final Map<int, String> genreMap = {
        for (var genre in response.genres) genre.id: genre.name
      };
      ImageService.setGenreMap(genreMap);
    } catch (e) {
      print('Error loading genres: $e');
      // Keep using hardcoded genres as fallback
    }
  }

  // Fetch now playing movies from API and cache them
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _apiService.getNowPlayingMovies(page, AppConstants.language);
      
      // Process movies to add genres
      final processedMovies = await _processMovies(response.results);
      
      // Cache movies in local database
      await _databaseService.insertMovies(processedMovies);
      
      return processedMovies;
    } catch (e) {
      // If API fails, try to get from local database
      return await _databaseService.getAllMovies();
    }
  }

  // Fetch popular movies from API and cache them
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _apiService.getPopularMovies(page, AppConstants.language);
      
      // Process movies to add genres
      final processedMovies = await _processMovies(response.results);
      
      // Cache movies in local database
      await _databaseService.insertMovies(processedMovies);
      
      return processedMovies;
    } catch (e) {
      // If API fails, try to get from local database
      return await _databaseService.getAllMovies();
    }
  }

  // Fetch top rated movies from API and cache them
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _apiService.getTopRatedMovies(page, AppConstants.language);
      
      // Process movies to add genres
      final processedMovies = await _processMovies(response.results);
      
      // Cache movies in local database
      await _databaseService.insertMovies(processedMovies);
      
      return processedMovies;
    } catch (e) {
      // If API fails, try to get from local database
      return await _databaseService.getAllMovies();
    }
  }

  // Fetch upcoming movies from API and cache them
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _apiService.getUpcomingMovies(page, AppConstants.language);
      
      // Process movies to add genres
      final processedMovies = await _processMovies(response.results);
      
      // Cache movies in local database
      await _databaseService.insertMovies(processedMovies);
      
      return processedMovies;
    } catch (e) {
      // If API fails, try to get from local database
      return await _databaseService.getAllMovies();
    }
  }

  // Search movies from API
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _apiService.searchMovies(query, page, AppConstants.language);
      
      // Process movies to add genres
      final processedMovies = await _processMovies(response.results);
      
      // Cache search results in local database
      await _databaseService.insertMovies(processedMovies);
      
      return processedMovies;
    } catch (e) {
      // If API fails, try to search in local database
      final allMovies = await _databaseService.getAllMovies();
      return allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Get movie details from API
  Future<Movie?> getMovieDetails(int movieId) async {
    try {
      final movie = await _apiService.getMovieDetails(movieId, AppConstants.language);
      
      // Process movie to add genres
      final processedMovie = await _processMovie(movie);
      
      // Update in database
      await _databaseService.insertMovies([processedMovie]);
      
      return processedMovie;
    } catch (e) {
      // If API fails, try to get from local database
      final allMovies = await _databaseService.getAllMovies();
      return allMovies.firstWhere(
        (movie) => movie.id == movieId,
        orElse: () => throw Exception('Movie not found'),
      );
    }
  }

  // Get movie images from API
  Future<MovieImagesResponse?> getMovieImages(int movieId) async {
    try {
      return await _apiService.getMovieImages(movieId);
    } catch (e) {
      print('Error loading movie images: $e');
      return null;
    }
  }

  // Get movie reviews from API
  Future<MovieReviewsResponse?> getMovieReviews(int movieId, {int page = 1}) async {
    try {
      return await _apiService.getMovieReviews(movieId, AppConstants.language, page);
    } catch (e) {
      print('Error loading movie reviews: $e');
      return null;
    }
  }

  // Process movies to add genres
  Future<List<Movie>> _processMovies(List<Movie> movies) async {
    final List<Movie> processedMovies = [];
    
    for (final movie in movies) {
      final processedMovie = await _processMovie(movie);
      processedMovies.add(processedMovie);
    }
    
    return processedMovies;
  }

  // Process a single movie to add genres
  Future<Movie> _processMovie(Movie movie) async {
    List<String>? genres;
    
    // Get genres from genre IDs
    if (movie.genreIds != null && movie.genreIds!.isNotEmpty) {
      genres = ImageService.getGenreNames(movie.genreIds!);
    }
    
    return movie.copyWith(
      genres: genres ?? movie.genres,
    );
  }

  // Get bookmarked movies from local database
  Future<List<Movie>> getBookmarkedMovies() async {
    return await _databaseService.getBookmarkedMovies();
  }

  // Toggle bookmark status
  Future<void> toggleBookmark(int movieId) async {
    final isBookmarked = await _databaseService.isMovieBookmarked(movieId);
    await _databaseService.toggleBookmark(movieId, !isBookmarked);
  }

  // Check if movie is bookmarked
  Future<bool> isMovieBookmarked(int movieId) async {
    return await _databaseService.isMovieBookmarked(movieId);
  }

  // Get movies from local database (offline mode)
  Future<List<Movie>> getLocalMovies() async {
    return await _databaseService.getAllMovies();
  }

  // Clear local database
  Future<void> clearLocalData() async {
    await _databaseService.clearMovies();
  }
} 