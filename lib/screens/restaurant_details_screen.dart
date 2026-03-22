import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/menu.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final infoHeight = screenHeight * 0.4;
    final imagePath = restaurant.imagePath.isEmpty
        ? 'assets/images/chick_fil_a.jpg'
        : restaurant.imagePath;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── INFO SECTION ───────────────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: infoHeight),
              child: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.hardEdge,
                children: [
                  // Background image — fills whatever height the Stack settles at
                  Positioned.fill(
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                  // Dark tint overlay
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  // Content: back button + detail + buttons
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(height: infoHeight * 0.25),
                          // Detail section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restaurant name
                              Text(
                                restaurant.name,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Hours
                              Text(
                                restaurant.hours,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Star rating
                              _buildStarRating(restaurant.rating),
                              const SizedBox(height: 4),
                              // Address
                              Text(
                                restaurant.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Buttons section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildPillButton('favorite'),
                              const SizedBox(width: 12),
                              _buildPillButton('write a review'),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── MENU SECTION ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // "menu" heading — centered, matches Suggestions section style
                  const Text(
                    'menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Menu items list — shrinkWrapped inside scroll view
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // Filter out placeholder empty items
                    itemCount: restaurant.menuItems
                        .where((item) => item.name.isNotEmpty)
                        .length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final items = restaurant.menuItems
                          .where((item) => item.name.isNotEmpty)
                          .toList();
                      return _MenuItemTile(item: items[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = (rating - fullStars) >= 0.5;
    final int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

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
          (_) => const Icon(Icons.star_border, color: Colors.white70, size: 18),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildPillButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── MenuItem tile widget ────────────────────────────────────────────────────
class _MenuItemTile extends StatelessWidget {
  final MenuItem item;

  const _MenuItemTile({required this.item});

  String _formatPrice(List<double> prices) {
    if (prices.isEmpty) return '';
    if (prices.length == 1) {
      return '\$${prices[0].toStringAsFixed(2)}';
    }
    final low = prices.reduce((a, b) => a < b ? a : b);
    final high = prices.reduce((a, b) => a > b ? a : b);
    return '\$${low.toStringAsFixed(2)} - \$${high.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + description on the left
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Price on the right
        Text(_formatPrice(item.price), style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
