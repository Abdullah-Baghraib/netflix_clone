import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../screens/movie_details_screen.dart';

class FeaturedBanner extends StatelessWidget {
  final Movie movie;
  final bool isLoading;

  const FeaturedBanner({Key? key, required this.movie, this.isLoading = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingBanner();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Container(
        height: 500,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop image
            CachedNetworkImage(
              imageUrl: movie.fullBackdropPath,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: AppConstants.secondaryColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: AppConstants.secondaryColor,
                    child: const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
            ),

            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),

            // Content (title, overview, buttons)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Rating and year
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        movie.releaseDate.isNotEmpty
                            ? movie.releaseDate.split('-')[0]
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Overview
                  Text(
                    movie.overview,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      // Play button
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.textColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: AppConstants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MovieDetailsScreen(
                                      movie: movie,
                                      autoPlayTrailer: true,
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(CupertinoIcons.play_fill),
                          label: const Text('Trailer'),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // More Info button
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MovieDetailsScreen(movie: movie),
                              ),
                            );
                          },
                          icon: const Icon(CupertinoIcons.info),
                          label: const Text('More Info'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBanner() {
    return Container(
      height: 500,
      width: double.infinity,
      color: AppConstants.secondaryColor,
      child: Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
    );
  }
}
