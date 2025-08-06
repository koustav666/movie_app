import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/api_response.dart';
import '../services/movie_repository.dart';

class MovieProvider with ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _bookmarkedMovies = [];
  List<MovieReview> _movieReviews = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get bookmarkedMovies => _bookmarkedMovies;
  List<MovieReview> get movieReviews => _movieReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load now playing movies
  Future<void> loadNowPlayingMovies() async {
    _setLoading(true);
    try {
      _nowPlayingMovies = await _repository.getNowPlayingMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load now playing movies: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load popular movies
  Future<void> loadPopularMovies() async {
    _setLoading(true);
    try {
      _popularMovies = await _repository.getPopularMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load popular movies: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load top rated movies
  Future<void> loadTopRatedMovies() async {
    _setLoading(true);
    try {
      _topRatedMovies = await _repository.getTopRatedMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load top rated movies: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load upcoming movies
  Future<void> loadUpcomingMovies() async {
    _setLoading(true);
    try {
      _upcomingMovies = await _repository.getUpcomingMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load upcoming movies: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Search movies
  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults = await _repository.searchMovies(query);
      _error = null;
    } catch (e) {
      _error = 'Failed to search movies: $e';
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  // Load bookmarked movies
  Future<void> loadBookmarkedMovies() async {
    _setLoading(true);
    try {
      _bookmarkedMovies = await _repository.getBookmarkedMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load bookmarked movies: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Load movie reviews
  Future<void> loadMovieReviews(int movieId, {int page = 1}) async {
    _setLoading(true);
    try {
      final response = await _repository.getMovieReviews(movieId, page: page);
      if (response != null) {
        if (page == 1) {
          _movieReviews = response.results;
        } else {
          _movieReviews.addAll(response.results);
        }
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to load movie reviews: $e';
      _movieReviews = [];
    } finally {
      _setLoading(false);
    }
  }

  // Clear movie reviews
  void clearMovieReviews() {
    _movieReviews = [];
    notifyListeners();
  }

  // Toggle bookmark
  Future<void> toggleBookmark(int movieId) async {
    try {
      await _repository.toggleBookmark(movieId);
      
      // Update the movie in all lists
      _updateMovieBookmarkStatus(movieId);
      
      // Reload bookmarked movies
      await loadBookmarkedMovies();
      
      _error = null;
    } catch (e) {
      _error = 'Failed to toggle bookmark: $e';
    }
  }

  // Update bookmark status in all movie lists
  void _updateMovieBookmarkStatus(int movieId) {
    // Update in now playing movies
    final nowPlayingIndex = _nowPlayingMovies.indexWhere((m) => m.id == movieId);
    if (nowPlayingIndex != -1) {
      final movie = _nowPlayingMovies[nowPlayingIndex];
      _nowPlayingMovies[nowPlayingIndex] = movie.copyWith(isBookmarked: !movie.isBookmarked);
    }

    // Update in popular movies
    final popularIndex = _popularMovies.indexWhere((m) => m.id == movieId);
    if (popularIndex != -1) {
      final movie = _popularMovies[popularIndex];
      _popularMovies[popularIndex] = movie.copyWith(isBookmarked: !movie.isBookmarked);
    }

    // Update in top rated movies
    final topRatedIndex = _topRatedMovies.indexWhere((m) => m.id == movieId);
    if (topRatedIndex != -1) {
      final movie = _topRatedMovies[topRatedIndex];
      _topRatedMovies[topRatedIndex] = movie.copyWith(isBookmarked: !movie.isBookmarked);
    }

    // Update in upcoming movies
    final upcomingIndex = _upcomingMovies.indexWhere((m) => m.id == movieId);
    if (upcomingIndex != -1) {
      final movie = _upcomingMovies[upcomingIndex];
      _upcomingMovies[upcomingIndex] = movie.copyWith(isBookmarked: !movie.isBookmarked);
    }

    // Update in search results
    final searchIndex = _searchResults.indexWhere((m) => m.id == movieId);
    if (searchIndex != -1) {
      final movie = _searchResults[searchIndex];
      _searchResults[searchIndex] = movie.copyWith(isBookmarked: !movie.isBookmarked);
    }

    notifyListeners();
  }

  // Check if movie is bookmarked
  Future<bool> isMovieBookmarked(int movieId) async {
    return await _repository.isMovieBookmarked(movieId);
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Load genres
  Future<void> loadGenres() async {
    try {
      await _repository.loadGenres();
      _error = null;
    } catch (e) {
      _error = 'Failed to load genres: $e';
    }
  }

  // Initialize app data
  Future<void> initializeApp() async {
    // Load genres first
    await loadGenres();
    
    // Then load movies
    await Future.wait([
      loadPopularMovies(),
      loadUpcomingMovies(),
      loadNowPlayingMovies(),
      loadTopRatedMovies(),
      loadBookmarkedMovies(),
    ]);
  }
} 