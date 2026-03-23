import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../screens/restaurant_details_screen.dart';
import '../utils/app_theme.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ext = theme.extension<AppThemeExtension>()!;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RestaurantDetailsScreen(restaurant: restaurant),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                restaurant.imagePath.isEmpty
                    ? 'assets/images/chick_fil_a.jpg'
                    : restaurant.imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Information container on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Hours
                  Text(
                    restaurant.hours,
                    style: TextStyle(fontSize: 12, color: ext.subtitleText),
                  ),
                  const SizedBox(height: 4),
                  // Star rating
                  _buildStarRating(restaurant.rating, ext),
                  const SizedBox(height: 4),
                  // Price level
                  Text(
                    restaurant.priceLabelString,
                    style: TextStyle(
                      fontSize: 14,
                      color: ext.priceText,
                      fontWeight: FontWeight.w600,
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

  Widget _buildStarRating(double rating, AppThemeExtension ext) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          fullStars,
          (_) => const Icon(Icons.star, color: Colors.amber, size: 18),
        ),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 18),
        ...List.generate(
          emptyStars,
          (_) => Icon(Icons.star, color: ext.starEmpty, size: 18),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(fontSize: 12, color: ext.subtitleText),
        ),
      ],
    );
  }
}
