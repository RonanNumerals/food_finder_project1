import '../data/database_helper.dart';
import '../models/restaurant.dart';
import 'embedding_service.dart';

/// Orchestration layer that ties together [EmbeddingService] and
/// [DatabaseHelper] to provide mood-based restaurant recommendations.
class VibeService {
  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------
  static final VibeService instance = VibeService._();
  VibeService._();

  final _db = DatabaseHelper.instance;
  final _matcher = EmbeddingService.instance;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns restaurants ranked by keyword similarity to [mood].
  Future<List<Restaurant>> getVibeMatches(String mood, {int limit = 10}) async {
    // 1. Fetch all restaurants from the database.
    final restaurants = await _db.getRestaurants();

    // 2. Score each restaurant against the mood.
    final scored = <_ScoredRestaurant>[];
    for (final r in restaurants) {
      final score = _matcher.score(
        mood,
        r.tags,
        r.cuisine ?? '',
        r.description,
      );
      scored.add(_ScoredRestaurant(r, score));
    }

    // 3. Sort descending by score and return the top N (only non-zero matches).
    scored.sort((a, b) => b.score.compareTo(a.score));

    return scored
        .where((s) => s.score > 0)
        .take(limit)
        .map((s) => s.restaurant)
        .toList();
  }
}

/// Internal helper to pair a restaurant with its similarity score.
class _ScoredRestaurant {
  final Restaurant restaurant;
  final double score;
  _ScoredRestaurant(this.restaurant, this.score);
}
