import 'dart:math';
import 'package:flutter/material.dart';
import '../services/vibe_service.dart';
import '../models/restaurant.dart';
import '../utils/app_theme.dart';
import '../widgets/restaurant_card.dart';

class VibeScreen extends StatefulWidget {
  const VibeScreen({super.key});

  @override
  State<VibeScreen> createState() => _VibeScreenState();
}

class _VibeScreenState extends State<VibeScreen> {
  static const List<String> _placeholders = [
    'hangry',
    'chill',
    'bored',
    'starving',
  ];

  late final String _placeholder;
  final TextEditingController _controller = TextEditingController();

  List<Restaurant> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false; // true once the user has submitted at least once

  @override
  void initState() {
    super.initState();
    _placeholder = _placeholders[Random().nextInt(_placeholders.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmitted(String mood) async {
    final trimmed = mood.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final matches = await VibeService.instance.getVibeMatches(trimmed);
      if (!mounted) return;
      setState(() {
        _results = matches;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vibe search failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ext = theme.extension<AppThemeExtension>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // -- Top half: prompt + text field --
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "I'm feeling...",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Uses InputDecorationTheme from AppTheme
                    TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSubmitted,
                      decoration: InputDecoration(hintText: _placeholder),
                    ),
                  ],
                ),
              ),
            ),

            // -- Bottom half: results --
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggestions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _buildBody(ext)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppThemeExtension ext) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return Center(
        child: Text(
          'Type a mood and press enter to discover restaurants.',
          textAlign: TextAlign.center,
          style: TextStyle(color: ext.subtitleText),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No matches found. Try a different vibe!',
          textAlign: TextAlign.center,
          style: TextStyle(color: ext.subtitleText),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return RestaurantCard(restaurant: _results[index]);
      },
    );
  }
}
