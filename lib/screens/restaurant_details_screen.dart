import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/menu.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final _db = DatabaseHelper.instance;

  bool _isFavorite = false;
  bool _favoriteLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final id = widget.restaurant.id;
    if (id == null) {
      setState(() => _favoriteLoading = false);
      return;
    }
    final result = await _db.isFavorite(id);
    if (mounted) {
      setState(() {
        _isFavorite = result;
        _favoriteLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final id = widget.restaurant.id;
    if (id == null || _favoriteLoading) return;

    // Optimistic update
    final wasAdding = !_isFavorite;
    setState(() => _isFavorite = wasAdding);

    try {
      if (wasAdding) {
        await _db.addFavorite(id);
      } else {
        await _db.removeFavorite(id);
      }
    } catch (_) {
      // Roll back on failure
      if (mounted) setState(() => _isFavorite = !wasAdding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final infoHeight = screenHeight * 0.4;
    final imagePath = widget.restaurant.imagePath.isEmpty
        ? 'assets/images/chick_fil_a.jpg'
        : widget.restaurant.imagePath;

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
                  // Background image
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
                                widget.restaurant.name,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Hours
                              Text(
                                widget.restaurant.hours,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Star rating
                              _buildStarRating(widget.restaurant.rating),
                              const SizedBox(height: 4),
                              // Address
                              Text(
                                widget.restaurant.location,
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
                              _buildFavoriteButton(),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _showReviewModal,
                                child: _buildPillButton('write a review'),
                              ),
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
                  const Text(
                    'menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.restaurant.menuItems
                        .where((item) => item.name.isNotEmpty)
                        .length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final items = widget.restaurant.menuItems
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

  void _showReviewModal() {
    final restaurantId = widget.restaurant.id;
    if (restaurantId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        int selectedStars = 0;
        final reviewController = TextEditingController();
        bool submitting = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final canSubmit =
                selectedStars > 0 && reviewController.text.trim().isNotEmpty;

            Future<void> submit() async {
              if (!canSubmit || submitting) return;
              setModalState(() => submitting = true);

              try {
                final user = await DatabaseHelper.instance.getUser();
                final review = Review(
                  restaurantId: restaurantId,
                  writtenReview: reviewController.text.trim(),
                  rating: selectedStars.toDouble(),
                  name: user?.name ?? 'Anonymous',
                  createdAt: DateTime.now().toIso8601String(),
                );
                await DatabaseHelper.instance.createReview(review);

                if (context.mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Review submitted!')),
                  );
                }
              } catch (_) {
                setModalState(() => submitting = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Heading
                  const Text(
                    'Write a Review',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Star rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final filled = i < selectedStars;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedStars = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            filled ? Icons.star : Icons.star_border,
                            color: filled ? Colors.amber : Colors.grey[400],
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  // Review body
                  TextField(
                    controller: reviewController,
                    maxLines: 4,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      hintText: 'What did you think?',
                      filled: true,
                      fillColor: const Color(0xFFECECEC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Submit button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: canSubmit && !submitting ? submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoriteButton() {
    final active = !_favoriteLoading && _isFavorite;

    return GestureDetector(
      onTap: _favoriteLoading ? null : _toggleFavorite,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: active ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 6),
            Text(
              active ? 'favorited' : 'favorite',
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
