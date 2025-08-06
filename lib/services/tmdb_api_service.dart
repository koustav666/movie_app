import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api_response.dart';
import '../models/movie.dart';
import '../constants/app_constants.dart';

part 'tmdb_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class TMDBApiService {
  factory TMDBApiService(Dio dio, {String baseUrl}) = _TMDBApiService;

  @GET('/movie/now_playing')
  Future<NowPlayingResponse> getNowPlayingMovies(
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/movie/popular')
  Future<MovieListResponse> getPopularMovies(
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/movie/top_rated')
  Future<MovieListResponse> getTopRatedMovies(
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/movie/upcoming')
  Future<MovieListResponse> getUpcomingMovies(
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/search/movie')
  Future<SearchResponse> searchMovies(
    @Query('query') String query,
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/movie/{movie_id}')
  Future<Movie> getMovieDetails(
    @Path('movie_id') int movieId,
    @Query('language') String language,
  );

  @GET('/movie/{movie_id}/images')
  Future<MovieImagesResponse> getMovieImages(
    @Path('movie_id') int movieId,
  );

  @GET('/movie/{movie_id}/reviews')
  Future<MovieReviewsResponse> getMovieReviews(
    @Path('movie_id') int movieId,
    @Query('language') String language,
    @Query('page') int page,
  );

  @GET('/genre/movie/list')
  Future<GenreListResponse> getGenres(
    @Query('language') String language,
  );
} 