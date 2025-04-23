import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/movie_card.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  final bool autoPlayTrailer;

  const MovieDetailsScreen({
    Key? key,
    required this.movie,
    this.autoPlayTrailer = false,
  }) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isFavorite = false;
  String? _videoKey;
  List<Movie> _recommendedMovies = [];
  bool _isLaunchingTrailer = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Check if movie is in favorites
      _isFavorite = await _favoritesService.isFavorite(widget.movie.id);

      // Load video key for trailer
      _videoKey = await _apiService.getVideoKey(widget.movie.id);

      // Load recommended movies
      _recommendedMovies = await _apiService.getRecommendedMovies(
        widget.movie.id,
      );

      if (_videoKey != null) {
        await _initializePlayer();

        // Auto-play trailer if requested
        if (widget.autoPlayTrailer) {
          setState(() {
            _isPlaying = true;
          });
        }
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initializePlayer() async {
    // YouTube videos need a special handling in Flutter
    // For now, our approach will be to open YouTube when requested
    // or use platform-specific plugins in a more complete implementation
  }

  // Function to handle playing the trailer
  Future<void> _playTrailer() async {
    if (_videoKey == null) return;

    setState(() {
      _isLaunchingTrailer = true;
    });

    final youtubeUrl = 'https://www.youtube.com/watch?v=$_videoKey';

    try {
      // Open YouTube in browser or YouTube app
      if (await canLaunchUrlString(youtubeUrl)) {
        await launchUrlString(youtubeUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch YouTube URL';
      }
    } catch (e) {
      print('Could not launch YouTube URL: $e');
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open YouTube. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLaunchingTrailer = false;
        });
      }
    }
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await _favoritesService.removeFromFavorites(widget.movie.id);
    } else {
      await _favoritesService.addToFavorites(widget.movie);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Backdrop with back button and title
                    Stack(
                      children: [
                        // Movie backdrop
                        widget.movie.backdropPath != null
                            ? CachedNetworkImage(
                              imageUrl: widget.movie.fullBackdropPath,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    height: 250,
                                    color: AppConstants.secondaryColor,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppConstants.primaryColor,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    height: 250,
                                    color: AppConstants.secondaryColor,
                                    child: const Icon(
                                      Icons.error,
                                      color: AppConstants.primaryColor,
                                      size: 50,
                                    ),
                                  ),
                            )
                            : Container(
                              height: 250,
                              color: AppConstants.secondaryColor,
                              width: double.infinity,
                            ),

                        // Gradient overlay for better text visibility
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppConstants.backgroundColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),

                        // Back button
                        Positioned(
                          top: 40,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        // Movie title at bottom of backdrop
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Movie poster
                              if (widget.movie.posterPath != null)
                                Container(
                                  height: 80,
                                  width: 55,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.movie.fullPosterPath,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const Center(
                                            child: CircularProgressIndicator(
                                              color: AppConstants.primaryColor,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => const Icon(
                                            CupertinoIcons.photo,
                                            color: Colors.white54,
                                          ),
                                    ),
                                  ),
                                ),

                              // Title and favorite
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.movie.title,
                                        style: AppConstants.titleStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _isFavorite
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color:
                                            _isFavorite
                                                ? AppConstants.primaryColor
                                                : Colors.white,
                                      ),
                                      onPressed: _toggleFavorite,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Release date and rating
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            widget.movie.releaseDate.split('-')[0], // Year only
                            style: AppConstants.subtitleStyle,
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            CupertinoIcons.star_fill,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.voteAverage.toStringAsFixed(1),
                            style: AppConstants.subtitleStyle,
                          ),
                        ],
                      ),
                    ),

                    // Play button
                    if (_videoKey != null)
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.textColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: AppConstants.primaryColor,
                            ),
                            foregroundColor: AppConstants.primaryColor,
                          ),
                          onPressed: _isLaunchingTrailer ? null : _playTrailer,
                          icon:
                              _isLaunchingTrailer
                                  ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : const Icon(
                                    CupertinoIcons.play_fill,
                                    size: 28,
                                    color: AppConstants.primaryColor,
                                  ),
                          label: Text(
                            _isLaunchingTrailer ? 'Opening...' : 'Play Trailer',
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),

                    // Video player (visible when playing)
                    // Removed as we're using external YouTube playback

                    // Overview
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Overview', style: AppConstants.headingStyle),
                          const SizedBox(height: 8),
                          Text(
                            widget.movie.overview,
                            style: AppConstants.bodyStyle,
                          ),
                        ],
                      ),
                    ),

                    // Recommended Movies
                    if (_recommendedMovies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommended',
                              style: AppConstants.headingStyle,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _recommendedMovies.length,
                                itemBuilder: (context, index) {
                                  return MovieCard(
                                    movie: _recommendedMovies[index],
                                    height: 180,
                                    width: 120,
                                    onFavoriteToggle: (movie) async {
                                      final isFav = await _favoritesService
                                          .isFavorite(movie.id);
                                      if (isFav) {
                                        await _favoritesService
                                            .removeFromFavorites(movie.id);
                                      } else {
                                        await _favoritesService.addToFavorites(
                                          movie,
                                        );
                                      }
                                      _loadData(); // Refresh data
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
