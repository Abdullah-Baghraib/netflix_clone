import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import 'featured_banner.dart';

class FeaturedBannerSlider extends StatefulWidget {
  final List<Movie> movies;
  final bool isLoading;

  const FeaturedBannerSlider({
    Key? key,
    required this.movies,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FeaturedBannerSlider> createState() => _FeaturedBannerSliderState();
}

class _FeaturedBannerSliderState extends State<FeaturedBannerSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.movies.isEmpty) {
      return _buildLoadingBanner();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.movies.length,
          itemBuilder: (context, index, realIndex) {
            return FeaturedBanner(
              movie: widget.movies[index],
              isLoading: false,
            );
          },
          options: CarouselOptions(
            height: 500,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.movies.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == entry.key
                              ? AppConstants.primaryColor
                              : Colors.white.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
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
