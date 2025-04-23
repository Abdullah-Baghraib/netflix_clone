import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieCategoryList extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;
  final Function(Movie) onFavoriteToggle;

  const MovieCategoryList({
    Key? key,
    required this.title,
    required this.movies,
    this.isLoading = false,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(title, style: AppConstants.headingStyle),
        ),

        // Movie list
        SizedBox(
          height: 200,
          child:
              isLoading
                  ? _buildLoadingList()
                  : movies.isEmpty
                  ? _buildEmptyList()
                  : _buildMovieList(),
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4, // Show 4 shimmer placeholders
      itemBuilder: (context, index) {
        return Container(
          width: 130,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: CircularProgressIndicator(color: AppConstants.primaryColor),
          ),
        );
      },
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Text('No movies available', style: AppConstants.bodyStyle),
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(
          movie: movies[index],
          onFavoriteToggle: onFavoriteToggle,
        );
      },
    );
  }
}
