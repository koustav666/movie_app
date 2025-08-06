import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_list.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'MovieDB',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Popular Movies
                    MovieList(
                      title: 'Popular Movies',
                      movies: movieProvider.popularMovies,
                      isLoading: movieProvider.isLoading,
                      onMovieTap: (movie) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      onBookmarkTap: (movie) {
                        movieProvider.toggleBookmark(movie.id);
                      },
                    ),
                    const SizedBox(height: 24),
                    // Upcoming Movies
                    MovieList(
                      title: 'Upcoming Movies',
                      movies: movieProvider.upcomingMovies,
                      isLoading: movieProvider.isLoading,
                      onMovieTap: (movie) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      onBookmarkTap: (movie) {
                        movieProvider.toggleBookmark(movie.id);
                      },
                    ),
                    const SizedBox(height: 24),
                    // Error Display
                    if (movieProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  movieProvider.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  movieProvider.clearError();
                                  movieProvider.initializeApp();
                                },
                                icon: const Icon(Icons.refresh, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 