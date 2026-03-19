import 'package:flutter/material.dart';
import '../data/restaurant_data.dart';
import '../widgets/restaurant_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Placeholder cuisine data — replace with database calls later
  final List<String> _cuisines = [
    'American',
    'Chinese',
    'Italian',
    'Japanese',
    'Mexican',
    'Thai',
    'Indian',
  ];

  String? _selectedCuisine;
  String? _selectedPrice;
  bool _openNow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      'Munchies',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'discover...',
                      filled: true,
                      fillColor: const Color(0xFFECECEC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  // Filter buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      // Cuisine dropdown
                      _buildDropdownButton(
                        label: _selectedCuisine ?? 'cuisine',
                        items: _cuisines,
                        onSelected: (value) {
                          setState(() => _selectedCuisine = value);
                        },
                      ),
                      // Price dropdown
                      _buildDropdownButton(
                        label: _selectedPrice ?? 'price',
                        items: ['\$', '\$\$', '\$\$\$'],
                        onSelected: (value) {
                          setState(() => _selectedPrice = value);
                        },
                      ),
                      // Open Now toggle
                      GestureDetector(
                        onTap: () {
                          setState(() => _openNow = !_openNow);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _openNow
                                ? Colors.green
                                : const Color(0xFFECECEC),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'open now',
                            style: TextStyle(
                              color: _openNow ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable restaurant list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: sampleRestaurants.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return RestaurantCard(restaurant: sampleRestaurants[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}
