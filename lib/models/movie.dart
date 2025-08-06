import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  final double popularity;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isBookmarked;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String>? genres;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    this.genreIds,
    this.isBookmarked = false,
    this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    double? popularity,
    List<int>? genreIds,
    bool? isBookmarked,
    List<String>? genres,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      genreIds: genreIds ?? this.genreIds,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      genres: genres ?? this.genres,
    );
  }

  String get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return 'https://via.placeholder.com/300x450?text=No+Image';
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get backdropUrl {
    if (backdropPath == null || backdropPath!.isEmpty) {
      return 'https://via.placeholder.com/1200x675?text=No+Image';
    }
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  String get thumbnailUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return 'https://via.placeholder.com/185x278?text=No+Image';
    }
    return 'https://image.tmdb.org/t/p/w185$posterPath';
  }
} 