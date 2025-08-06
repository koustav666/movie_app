import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'api_response.g.dart';

@JsonSerializable()
class MovieListResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}

@JsonSerializable()
class NowPlayingResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;
  final MovieDates? dates;

  NowPlayingResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
    this.dates,
  });

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) =>
      _$NowPlayingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NowPlayingResponseToJson(this);
}

@JsonSerializable()
class MovieDates {
  final String maximum;
  final String minimum;

  MovieDates({
    required this.maximum,
    required this.minimum,
  });

  factory MovieDates.fromJson(Map<String, dynamic> json) =>
      _$MovieDatesFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDatesToJson(this);
}

@JsonSerializable()
class SearchResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  SearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class GenreListResponse {
  final List<Genre> genres;

  GenreListResponse({
    required this.genres,
  });

  factory GenreListResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreListResponseToJson(this);
}

@JsonSerializable()
class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) =>
      _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class MovieImagesResponse {
  final List<MovieImage> backdrops;
  final List<MovieImage> logos;
  final List<MovieImage> posters;

  MovieImagesResponse({
    required this.backdrops,
    required this.logos,
    required this.posters,
  });

  factory MovieImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieImagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieImagesResponseToJson(this);
}

@JsonSerializable()
class MovieImage {
  @JsonKey(name: 'aspect_ratio')
  final double aspectRatio;
  final int height;
  @JsonKey(name: 'iso_639_1')
  final String? iso6391;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  final int width;
  final int id;

  MovieImage({
    required this.aspectRatio,
    required this.height,
    this.iso6391,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
    required this.id,
  });

  factory MovieImage.fromJson(Map<String, dynamic> json) =>
      _$MovieImageFromJson(json);

  Map<String, dynamic> toJson() => _$MovieImageToJson(this);

  String get imageUrl => 'https://image.tmdb.org/t/p/w500$filePath';
  String get thumbnailUrl => 'https://image.tmdb.org/t/p/w185$filePath';
}

@JsonSerializable()
class MovieReviewsResponse {
  final int id;
  final int page;
  final List<MovieReview> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MovieReviewsResponse({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieReviewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieReviewsResponseToJson(this);
}

@JsonSerializable()
class MovieReview {
  final String author;
  @JsonKey(name: 'author_details')
  final AuthorDetails authorDetails;
  final String content;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String id;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final String url;

  MovieReview({
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.url,
  });

  factory MovieReview.fromJson(Map<String, dynamic> json) =>
      _$MovieReviewFromJson(json);

  Map<String, dynamic> toJson() => _$MovieReviewToJson(this);
}

@JsonSerializable()
class AuthorDetails {
  final String? name;
  final String? username;
  @JsonKey(name: 'avatar_path')
  final String? avatarPath;
  final double? rating;

  AuthorDetails({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) =>
      _$AuthorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDetailsToJson(this);

  String get avatarUrl {
    if (avatarPath == null || avatarPath!.isEmpty) {
      return 'https://via.placeholder.com/40x40?text=User';
    }
    if (avatarPath!.startsWith('http')) {
      return avatarPath!;
    }
    return 'https://image.tmdb.org/t/p/w45$avatarPath';
  }
} 