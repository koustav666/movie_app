import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/movie_reviews_widget.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  int _currentReviewPage = 1;
  bool _hasMoreReviews = true;

  @override
  void initState() {
    super.initState();
    // Load reviews when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovieReviews(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Backdrop
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  
                  final currentMovie = movieProvider.getMovieById(
                    widget.movie.id,
                  );

                  final movieToDisplay = currentMovie ?? widget.movie;

                  return IconButton(
                    icon: Icon(
                      movieToDisplay.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color:
                          movieToDisplay.isBookmarked
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                    ),
                    onPressed: () {
                      movieProvider.toggleBookmark(widget.movie.id);
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  _shareMovie();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop Image
                  widget.movie.backdropPath != null
                      ? Image.network(
                        widget.movie.backdropUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white54,
                              size: 100,
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.movie,
                          color: Colors.white54,
                          size: 100,
                        ),
                      ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Movie Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          height: 180,
                          child: Image.network(
                            widget.movie.posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.movie,
                                  color: Colors.white54,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Released: ${_formatReleaseDate(widget.movie.releaseDate)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${widget.movie.voteCount} votes)',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Overview
                  if (widget.movie.overview.isNotEmpty) ...[
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Additional Info
                  _buildInfoRow(
                    'Popularity',
                    widget.movie.popularity.toStringAsFixed(1),
                  ),
                  if (widget.movie.genres != null &&
                      widget.movie.genres!.isNotEmpty)
                    _buildInfoRow('Genres', widget.movie.genres!.join(', ')),
                  const SizedBox(height: 24),
                  // Reviews Section
                  Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                      return MovieReviewsWidget(
                        reviews: movieProvider.movieReviews,
                        isLoading: movieProvider.isLoading,
                        hasMoreReviews: _hasMoreReviews,
                        onLoadMore:
                            _hasMoreReviews ? () => _loadMoreReviews() : null,
                      );
                    },
                  ),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatReleaseDate(String? dateString) {
    if (dateString == null) return 'N/A';
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;
    return '${date.month}/${date.day}/${date.year}';
  }

  void _shareMovie() {
    final shareText =
        'Check out "${widget.movie.title}" on MovieDB!\n\n'
        'Rating: ${widget.movie.voteAverage.toStringAsFixed(1)}\n'
        'Release Date: ${_formatReleaseDate(widget.movie.releaseDate)}\n\n'
        '${widget.movie.overview}\n\n'
        'Shared from MovieDB App';

    Share.share(shareText, subject: 'Movie: ${widget.movie.title}');
  }

  void _loadMoreReviews() {
    _currentReviewPage++;
    context
        .read<MovieProvider>()
        .loadMovieReviews(widget.movie.id, page: _currentReviewPage)
        .then((_) {
          // Check if we have more reviews to load
          final movieProvider = context.read<MovieProvider>();
          if (movieProvider.movieReviews.length < _currentReviewPage * 20) {
            setState(() {
              _hasMoreReviews = false;
            });
          }
        });
  }
}
