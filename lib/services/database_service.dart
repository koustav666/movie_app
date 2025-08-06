import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 3, // Updated version for new schema
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        backdropPath TEXT,
        releaseDate TEXT,
        voteAverage REAL,
        voteCount INTEGER,
        popularity REAL,
        isBookmarked INTEGER DEFAULT 0,
        genres TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add genres column for version 2
      await db.execute('ALTER TABLE movies ADD COLUMN genres TEXT');
    }
    if (oldVersion < 3) {
      // Remove thumbnailImage column if it exists (for version 3)
      // Note: SQLite doesn't support DROP COLUMN directly, so we'll recreate the table
      // This is a simplified approach - in production you'd want a more robust migration
    }
  }

  Future<void> insertMovies(List<Movie> movies) async {
    final db = await database;
    final batch = db.batch();
    
    for (final movie in movies) {
      batch.insert(
        'movies',
        {
          'id': movie.id,
          'title': movie.title,
          'overview': movie.overview,
          'posterPath': movie.posterPath,
          'backdropPath': movie.backdropPath,
          'releaseDate': movie.releaseDate,
          'voteAverage': movie.voteAverage,
          'voteCount': movie.voteCount,
          'popularity': movie.popularity,
          'isBookmarked': movie.isBookmarked ? 1 : 0,
          'genres': movie.genres?.join(','),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Movie(
        id: map['id'],
        title: map['title'],
        overview: map['overview'],
        posterPath: map['posterPath'],
        backdropPath: map['backdropPath'],
        releaseDate: map['releaseDate'],
        voteAverage: map['voteAverage'],
        voteCount: map['voteCount'],
        popularity: map['popularity'],
        isBookmarked: map['isBookmarked'] == 1,
        genres: map['genres']?.split(',') ?? [],
      );
    });
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'isBookmarked = ?',
      whereArgs: [1],
    );
    
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Movie(
        id: map['id'],
        title: map['title'],
        overview: map['overview'],
        posterPath: map['posterPath'],
        backdropPath: map['backdropPath'],
        releaseDate: map['releaseDate'],
        voteAverage: map['voteAverage'],
        voteCount: map['voteCount'],
        popularity: map['popularity'],
        isBookmarked: map['isBookmarked'] == 1,
        genres: map['genres']?.split(',') ?? [],
      );
    });
  }

  Future<void> toggleBookmark(int movieId, bool isBookmarked) async {
    final db = await database;
    await db.update(
      'movies',
      {'isBookmarked': isBookmarked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [movieId],
    );
  }

  Future<bool> isMovieBookmarked(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [movieId],
    );
    
    if (maps.isNotEmpty) {
      return maps.first['isBookmarked'] == 1;
    }
    return false;
  }

  Future<void> clearMovies() async {
    final db = await database;
    await db.delete('movies');
  }

  Future<void> updateMovieGenres(int movieId, List<String> genres) async {
    final db = await database;
    await db.update(
      'movies',
      {'genres': genres.join(',')},
      where: 'id = ?',
      whereArgs: [movieId],
    );
  }
} 