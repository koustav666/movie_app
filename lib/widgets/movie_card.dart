import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: _buildPosterImage(),
                  ),
                ),
                // Bookmark Button
                if (onBookmark != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onBookmark,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          movie.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: movie.isBookmarked
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                // Rating Badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Movie Title
            Container(
              width: double.infinity,
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 15, // Slightly reduced font size
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 4),
            // Release Date
            Container(
              width: double.infinity,
              child: Text(
                _formatReleaseDate(movie.releaseDate),
                style: TextStyle(
                  fontSize: 11, // Slightly reduced font size
                  color: Colors.grey[400],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    return CachedNetworkImage(
      imageUrl: movie.thumbnailUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => _buildFallbackImage(),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[800],
      child: const Icon(
        Icons.movie,
        color: Colors.white54,
        size: 50,
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    if (releaseDate.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }
} 