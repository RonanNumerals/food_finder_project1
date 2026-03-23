import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/restaurant.dart';
import '../models/user.dart';
import '../widgets/restaurant_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _db = DatabaseHelper.instance;

  User? _user;
  List<Restaurant> _favorites = [];
  int _reviewsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Called by MainScreen via GlobalKey whenever the Profile tab is selected.
  Future<void> refresh() => _loadData();

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      _db.getUser(),
      _db.getFavoriteRestaurants(),
      _db.getAllReviews(),
    ]);

    if (mounted) {
      setState(() {
        _user = results[0] as User?;
        _favorites = results[1] as List<Restaurant>;
        _reviewsCount = (results[2] as List).length;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _user?.profileImage ?? 'assets/images/default_pfp.jpg';
    final userName = _user?.name ?? 'Your Name';
    final location = _user?.location ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Profile info row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile picture
                      ClipOval(
                        child: Image.asset(
                          profileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Name
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Location
                          if (location.isNotEmpty)
                            Text(
                              '📍 $location',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          const SizedBox(height: 4),
                          // Counts
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${_favorites.length}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' Favorites',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$_reviewsCount',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' Reviews',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Section title
                  const Text(
                    'Favorites',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Favorites list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _favorites.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorites yet.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        itemCount: _favorites.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return RestaurantCard(restaurant: _favorites[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
