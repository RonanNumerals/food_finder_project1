import 'dart:async';

import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/restaurant.dart';
import '../utils/app_theme.dart';
import '../widgets/restaurant_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _db = DatabaseHelper.instance;
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<Restaurant> _restaurants = [];
  List<String> _cuisines = [];
  bool _isLoading = true;

  String? _selectedCuisine;
  String? _selectedPrice;
  bool _openNow = false;

  // Map price label -> DB price_level integer
  static const _priceToLevel = {'\$': 1, '\$\$': 2, '\$\$\$': 3};

  @override
  void initState() {
    super.initState();
    _loadCuisines();
    _fetchRestaurants();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCuisines() async {
    final cuisines = await _db.getDistinctCuisines();
    if (mounted) setState(() => _cuisines = cuisines);
  }

  Future<void> _fetchRestaurants() async {
    setState(() => _isLoading = true);

    final results = await _db.getRestaurants(
      name: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      cuisine: _selectedCuisine,
      priceLevel: _selectedPrice != null ? _priceToLevel[_selectedPrice] : null,
      openNow: _openNow,
    );

    if (mounted) {
      setState(() {
        _restaurants = results;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _fetchRestaurants);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ext = theme.extension<AppThemeExtension>()!;

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
                  // Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Munchies',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Search bar (uses InputDecorationTheme from AppTheme)
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(hintText: 'discover...'),
                  ),
                  // Filter buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      // Cuisine dropdown
                      _buildDropdownButton(
                        label: _selectedCuisine ?? 'cuisine',
                        isActive: _selectedCuisine != null,
                        items: _cuisines,
                        onSelected: (value) {
                          setState(() {
                            _selectedCuisine = _selectedCuisine == value
                                ? null
                                : value;
                          });
                          _fetchRestaurants();
                        },
                        ext: ext,
                      ),
                      // Price dropdown
                      _buildDropdownButton(
                        label: _selectedPrice ?? 'price',
                        isActive: _selectedPrice != null,
                        items: ['\$', '\$\$', '\$\$\$'],
                        onSelected: (value) {
                          setState(() {
                            _selectedPrice = _selectedPrice == value
                                ? null
                                : value;
                          });
                          _fetchRestaurants();
                        },
                        ext: ext,
                      ),
                      // Open Now toggle
                      GestureDetector(
                        onTap: () {
                          setState(() => _openNow = !_openNow);
                          _fetchRestaurants();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _openNow ? ext.activeChipFill : ext.chipFill,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'open now',
                            style: TextStyle(
                              color: _openNow
                                  ? ext.activeChipText
                                  : ext.chipText,
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _restaurants.isEmpty
                  ? Center(
                      child: Text(
                        'No restaurants found.',
                        style: TextStyle(fontSize: 16, color: ext.subtitleText),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: _restaurants.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return RestaurantCard(restaurant: _restaurants[index]);
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
    required AppThemeExtension ext,
    bool isActive = false,
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
          color: isActive ? ext.activeChipFill : ext.chipFill,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isActive ? ext.activeChipText : ext.chipText,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: isActive ? ext.activeChipText : ext.chipText,
            ),
          ],
        ),
      ),
    );
  }
}
