import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ImageService {
  static final Dio _dio = Dio();
  static Map<int, String> _genreMap = {};

  /// Download thumbnail image from TMDB
  static Future<List<int>?> downloadThumbnail(String posterPath) async {
    if (posterPath.isEmpty) return null;
    
    try {
      final url = 'https://image.tmdb.org/t/p/${AppConstants.profileSize}$posterPath';
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      if (response.statusCode == 200) {
        return response.data as List<int>;
      }
    } catch (e) {
      print('Error downloading thumbnail: $e');
    }
    
    return null;
  }

  /// Download thumbnail using http package as fallback
  static Future<List<int>?> downloadThumbnailHttp(String posterPath) async {
    if (posterPath.isEmpty) return null;
    
    try {
      final url = 'https://image.tmdb.org/t/p/${AppConstants.profileSize}$posterPath';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error downloading thumbnail with http: $e');
    }
    
    return null;
  }

  /// Set genre map from API response
  static void setGenreMap(Map<int, String> genreMap) {
    _genreMap = genreMap;
  }

  /// Get genre names from genre IDs
  static List<String> getGenreNames(List<int> genreIds) {
    if (_genreMap.isEmpty) {
      // Fallback to hardcoded genres if API hasn't been called yet
      _genreMap = {
        28: 'Action',
        12: 'Adventure',
        16: 'Animation',
        35: 'Comedy',
        80: 'Crime',
        99: 'Documentary',
        18: 'Drama',
        10751: 'Family',
        14: 'Fantasy',
        36: 'History',
        27: 'Horror',
        10402: 'Music',
        9648: 'Mystery',
        10749: 'Romance',
        878: 'Science Fiction',
        10770: 'TV Movie',
        53: 'Thriller',
        10752: 'War',
        37: 'Western',
      };
    }

    return genreIds.map((id) => _genreMap[id] ?? 'Unknown').toList();
  }
} 