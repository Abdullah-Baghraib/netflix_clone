import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../constants/app_constants.dart';
import '../screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double height;
  final double width;
  final Function? onFavoriteToggle;

  const MovieCard({
    Key? key,
    required this.movie,
    this.height = 200,
    this.width = 130,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    MovieDetailsScreen(movie: movie, autoPlayTrailer: false),
          ),
        );
      },
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppConstants.secondaryColor,
        ),
        child: Stack(
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  movie.posterPath != null
                      ? CachedNetworkImage(
                        imageUrl: movie.fullPosterPath,
                        fit: BoxFit.cover,
                        height: height,
                        width: width,
                        placeholder:
                            (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: AppConstants.primaryColor,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Center(
                              child: Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                      )
                      : Container(
                        color: AppConstants.secondaryColor,
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.film,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
            ),

            // Rating indicator
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.star_fill,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // Favorite button (if callback provided)
            if (onFavoriteToggle != null)
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    onFavoriteToggle?.call(movie);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      movie.isFavorite
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color:
                          movie.isFavorite
                              ? AppConstants.primaryColor
                              : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
