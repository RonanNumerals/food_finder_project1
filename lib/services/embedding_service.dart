/// Keyword-based similarity service that matches a user's mood string
/// against restaurant tags, cuisine, and description.
///
/// Replaces the previous TFLite-based embedding approach with a lightweight
/// text-matching strategy that needs no native dependencies.
class EmbeddingService {
  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------
  static final EmbeddingService instance = EmbeddingService._();
  EmbeddingService._();

  // ---------------------------------------------------------------------------
  // Synonym / mood → keyword expansion
  // ---------------------------------------------------------------------------

  /// Maps common mood words to tags and keywords that should boost a match.
  static const Map<String, List<String>> _synonyms = {
    // hunger-related
    'hangry': ['hangry', 'filling', 'comfort food', 'quick bite', 'fast food'],
    'hungry': ['hangry', 'filling', 'comfort food', 'quick bite'],
    'starving': [
      'hangry',
      'filling',
      'comfort food',
      'quick bite',
      'fast food',
    ],
    'famished': ['hangry', 'filling', 'comfort food'],

    // chill / relaxed
    'chill': ['chill', 'relaxed', 'cozy', 'calm', 'coffee', 'study spot'],
    'relaxed': ['chill', 'relaxed', 'cozy', 'calm', 'coffee'],
    'calm': ['calm', 'chill', 'relaxed', 'cozy', 'study spot'],
    'cozy': ['cozy', 'chill', 'relaxed', 'calm', 'coffee'],
    'tired': ['chill', 'coffee', 'calm', 'relaxed', 'cozy'],

    // bored / adventurous
    'bored': ['bored', 'adventurous', 'international', 'flavorful', 'social'],
    'adventurous': ['adventurous', 'international', 'flavorful', 'spicy'],
    'curious': ['adventurous', 'international', 'flavorful'],

    // social / fun
    'social': ['social', 'game day', 'late night', 'comfort food'],
    'fun': ['social', 'game day', 'late night'],
    'party': ['social', 'late night', 'game day'],

    // healthy
    'healthy': ['healthy', 'light', 'fresh', 'clean eating', 'bowls'],
    'light': ['light', 'healthy', 'fresh', 'clean eating'],
    'fresh': ['fresh', 'healthy', 'light', 'clean eating'],
    'energized': ['energized', 'healthy', 'fresh', 'light'],
    'gym': ['healthy', 'light', 'fresh', 'clean eating', 'energized'],

    // late night
    'late': ['late night', 'comfort food', 'pizza', 'affordable'],
    'late night': ['late night', 'comfort food', 'pizza'],
    'midnight': ['late night', 'comfort food', 'pizza'],

    // date / aesthetic
    'date': ['date', 'aesthetic', 'cozy', 'brunch'],
    'romantic': ['date', 'aesthetic', 'cozy'],
    'aesthetic': ['aesthetic', 'cozy', 'date', 'coffee'],
    'fancy': ['date', 'aesthetic'],

    // cheap
    'cheap': ['affordable', 'quick bite'],
    'broke': ['affordable', 'quick bite'],
    'affordable': ['affordable', 'quick bite'],

    // spicy
    'spicy': ['spicy', 'flavorful', 'adventurous'],

    // breakfast / brunch
    'brunch': ['brunch', 'breakfast', 'coffee', 'aesthetic'],
    'breakfast': ['breakfast', 'brunch', 'coffee'],

    // comfort
    'comfort': ['comfort food', 'filling', 'cozy'],
    'nostalgic': ['comfort food', 'classic', 'filling'],

    // coffee / study
    'coffee': ['coffee', 'study spot', 'chill', 'calm'],
    'study': ['study spot', 'coffee', 'chill', 'calm', 'work'],
    'productive': ['study spot', 'coffee', 'work', 'calm'],
    'work': ['work', 'study spot', 'coffee', 'chill'],
  };

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Scores a restaurant against [mood] and returns a value between 0 and 1.
  ///
  /// The score is derived from keyword overlap between the mood (expanded via
  /// synonyms) and the restaurant's tags, cuisine, and description.
  double score(
    String mood,
    List<String> tags,
    String cuisine,
    String description,
  ) {
    final moodWords = _tokenise(mood);

    // Expand mood words using synonym map.
    final expandedKeywords = <String>{};
    for (final word in moodWords) {
      expandedKeywords.add(word);
      final synonyms = _synonyms[word];
      if (synonyms != null) {
        expandedKeywords.addAll(synonyms);
      }
    }

    // Build the restaurant's searchable text tokens.
    final restaurantTokens = <String>{
      ...tags.map((t) => t.toLowerCase()),
      cuisine.toLowerCase(),
      ..._tokenise(description),
    };

    // Count matches.
    int matches = 0;
    for (final keyword in expandedKeywords) {
      // Check exact tag match first.
      if (restaurantTokens.contains(keyword)) {
        matches += 2; // exact tag match is worth more
        continue;
      }
      // Check partial / substring match.
      if (restaurantTokens.any(
        (t) => t.contains(keyword) || keyword.contains(t),
      )) {
        matches += 1;
      }
    }

    if (expandedKeywords.isEmpty) return 0.0;

    // Normalise to 0–1 range (cap at 1.0).
    final raw = matches / (expandedKeywords.length * 2);
    return raw.clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Lowercase + split on whitespace & punctuation.
  List<String> _tokenise(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'[\s,.\-!?;:]+'))
        .where((w) => w.length > 1)
        .toList();
  }

  void dispose() {
    // Nothing to clean up in the keyword-based approach.
  }
}
