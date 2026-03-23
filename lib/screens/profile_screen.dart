import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/restaurant.dart';
import '../models/user.dart';
import '../utils/app_theme.dart';
import '../widgets/restaurant_card.dart';
import 'review_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

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

  Future<void> _editName() async {
    final controller = TextEditingController(text: _user?.name ?? '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || _user == null) return;

    final newName = controller.text.trim();
    if (newName.isEmpty || newName == _user!.name) return;

    final updated = _user!.copyWith(name: newName);
    await _db.updateUser(updated);
    if (mounted) setState(() => _user = updated);
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ext = theme.extension<AppThemeExtension>()!;

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
                  // Title row with dark mode toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // Dark mode toggle
                      Row(
                        children: [
                          Icon(
                            widget.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Switch(
                            value: widget.isDarkMode,
                            onChanged: widget.onThemeToggle,
                            activeTrackColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
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
                          // Name + edit button
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: _editName,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Location
                          if (location.isNotEmpty)
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: colorScheme.onSurface,
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Favorites',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReviewsScreen(),
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$_reviewsCount',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' Reviews',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
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
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
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
                  ? Center(
                      child: Text(
                        'No favorites yet.',
                        style: TextStyle(fontSize: 16, color: ext.subtitleText),
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
