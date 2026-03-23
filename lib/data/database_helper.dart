import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'restaurant_data.dart';
import '../models/review.dart';
import '../models/favorite.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/menu.dart';
import '../utils/hours_parser.dart';

// DatabaseHelper class - Singleton pattern
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myapp.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Create database tables (fresh install)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      image_path TEXT,
      description TEXT,
      location TEXT,
      rating REAL,
      hours TEXT,
      price_level INTEGER,
      cuisine TEXT,
      tags TEXT,
      vibe_embedding TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE menu_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      restaurant_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      price TEXT,
      FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      restaurant_id INTEGER NOT NULL UNIQUE,
      created_at TEXT NOT NULL,
      FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      restaurant_id INTEGER NOT NULL,
      written_review TEXT NOT NULL,
      rating REAL NOT NULL,
      name TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      profile_image TEXT,
      location TEXT
      )
    ''');

    await _seedRestaurantData(db);
    await _seedDefaultUser(db);
  }

  // Migrate existing database
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE restaurants ADD COLUMN price_level INTEGER',
      );
      await db.execute('ALTER TABLE restaurants ADD COLUMN cuisine TEXT');

      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('''
        CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id INTEGER NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        profile_image TEXT,
        location TEXT
        )
      ''');

      await _seedDefaultUser(db);
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE restaurants ADD COLUMN tags TEXT');
      await db.execute(
        'ALTER TABLE restaurants ADD COLUMN vibe_embedding TEXT',
      );
    }
  }

  // -------------------------------------------------------------------------
  // Seeding
  // -------------------------------------------------------------------------

  Future<void> _seedRestaurantData(Database db) async {
    for (var restaurant in sampleRestaurants) {
      final restaurantId = await db.insert('restaurants', {
        'name': restaurant.name,
        'image_path': restaurant.imagePath,
        'description': restaurant.description,
        'location': restaurant.location,
        'rating': restaurant.rating,
        'hours': restaurant.hours,
        'price_level': restaurant.priceLevel,
        'cuisine': restaurant.cuisine,
        'tags': jsonEncode(restaurant.tags),
        // vibe_embedding intentionally omitted -- computed later by EmbeddingService
      });

      final batch = db.batch();
      for (var item in restaurant.menuItems) {
        batch.insert('menu_items', {
          'restaurant_id': restaurantId,
          'name': item.name,
          'description': item.description,
          'price': jsonEncode(item.price),
        });
      }
      await batch.commit(noResult: true);
    }
  }

  Future<void> _seedDefaultUser(Database db) async {
    await db.insert('users', {
      'name': 'Your Name',
      'profile_image': 'assets/images/default_pfp.jpg',
      'location': 'Georgia State University',
    });
  }

  // -------------------------------------------------------------------------
  // RESTAURANTS
  // -------------------------------------------------------------------------

  /// Fetches restaurants with optional filters.
  ///
  /// Any parameter that is null or empty is excluded from the WHERE clause
  /// entirely — so passing no arguments returns all restaurants.
  ///
  /// [name]       — substring match on the restaurant name (case-insensitive)
  /// [priceLevel] — exact match (1 = $, 2 = $$, 3 = $$$)
  /// [cuisine]    — substring match on the cuisine field
  /// [openNow]    — when true, only restaurants whose hours string covers the
  ///                current local time are returned; hours parsing is done in
  ///                Dart after the DB query because SQLite cannot parse the
  ///                free-text hours format
  Future<List<Restaurant>> getRestaurants({
    String? name,
    int? priceLevel,
    String? cuisine,
    bool openNow = false,
  }) async {
    final db = await database;

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (name != null && name.isNotEmpty) {
      whereClauses.add('name LIKE ?');
      whereArgs.add('%$name%');
    }

    if (priceLevel != null) {
      whereClauses.add('price_level = ?');
      whereArgs.add(priceLevel);
    }

    if (cuisine != null && cuisine.isNotEmpty) {
      whereClauses.add('cuisine LIKE ?');
      whereArgs.add('%$cuisine%');
    }

    final rows = await db.query(
      'restaurants',
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    final restaurants = await Future.wait(
      rows.map((row) => _hydrateRestaurant(db, row)),
    );

    if (!openNow) return restaurants;

    final now = DateTime.now();
    return restaurants
        .where((r) => HoursParser.isOpenAt(r.hours, now))
        .toList();
  }

  /// Returns the full [Restaurant] for every favorited entry, with menu items
  /// hydrated.
  Future<List<Restaurant>> getFavoriteRestaurants() async {
    final db = await database;

    // JOIN favorites → restaurants so we only make one round-trip to get rows
    final rows = await db.rawQuery('''
      SELECT r.*
      FROM restaurants r
      INNER JOIN favorites f ON f.restaurant_id = r.id
      ORDER BY f.created_at DESC
    ''');

    return Future.wait(rows.map((row) => _hydrateRestaurant(db, row)));
  }

  /// Returns a single restaurant by its primary key, with menu items hydrated.
  Future<Restaurant?> getRestaurant(int id) async {
    final db = await database;
    final rows = await db.query(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return _hydrateRestaurant(db, rows.first);
  }

  /// Loads menu items for [row] and constructs a fully hydrated [Restaurant].
  Future<Restaurant> _hydrateRestaurant(
    Database db,
    Map<String, dynamic> row,
  ) async {
    final restaurantId = row['id'] as int;
    final menuRows = await db.query(
      'menu_items',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
    final menuItems = menuRows.map(MenuItem.fromMap).toList();
    return Restaurant.fromMap(row, menuItems: menuItems);
  }

  // -------------------------------------------------------------------------
  // MENU ITEMS
  // -------------------------------------------------------------------------

  /// Returns all menu items for a given restaurant.
  Future<List<MenuItem>> getMenuItemsByRestaurant(int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'menu_items',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
    return rows.map(MenuItem.fromMap).toList();
  }

  /// Returns a single menu item by its primary key.
  Future<MenuItem?> getMenuItem(int id) async {
    final db = await database;
    final rows = await db.query('menu_items', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? MenuItem.fromMap(rows.first) : null;
  }

  // -------------------------------------------------------------------------
  // REVIEWS
  // -------------------------------------------------------------------------

  /// Inserts a new review. [review.id] should be null.
  Future<int> createReview(Review review) async {
    final db = await database;
    return await db.insert('reviews', review.toMap());
  }

  /// Returns all reviews across all restaurants, newest first.
  Future<List<Review>> getAllReviews() async {
    final db = await database;
    final rows = await db.query('reviews', orderBy: 'created_at DESC');
    return rows.map(Review.fromMap).toList();
  }

  /// Returns all reviews joined with the restaurant name, newest first.
  Future<List<Review>> getReviewsWithRestaurantName() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT rev.*, r.name AS restaurant_name
      FROM reviews rev
      INNER JOIN restaurants r ON r.id = rev.restaurant_id
      ORDER BY rev.created_at DESC
    ''');
    return rows.map(Review.fromMap).toList();
  }

  /// Returns reviews for a single restaurant, newest first.
  Future<List<Review>> getReviewsByRestaurant(int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'reviews',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Review.fromMap).toList();
  }

  /// Returns a single review by its primary key.
  Future<Review?> getReview(int id) async {
    final db = await database;
    final rows = await db.query('reviews', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? Review.fromMap(rows.first) : null;
  }

  /// Updates an existing review. [review.id] must not be null.
  Future<int> updateReview(Review review) async {
    final db = await database;
    return await db.update(
      'reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  /// Deletes a review by its primary key.
  Future<int> deleteReview(int id) async {
    final db = await database;
    return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------------------
  // FAVORITES
  // -------------------------------------------------------------------------

  /// Marks a restaurant as a favorite. A duplicate insert is silently ignored.
  Future<int> addFavorite(int restaurantId) async {
    final db = await database;
    return await db.insert(
      'favorites',
      Favorite(
        restaurantId: restaurantId,
        createdAt: DateTime.now().toIso8601String(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Removes a restaurant from favorites.
  Future<int> removeFavorite(int restaurantId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
  }

  /// Returns true if the restaurant is currently favorited.
  Future<bool> isFavorite(int restaurantId) async {
    final db = await database;
    final rows = await db.query(
      'favorites',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// Returns all favorite entries (IDs + timestamps), newest first.
  Future<List<Favorite>> getAllFavorites() async {
    final db = await database;
    final rows = await db.query('favorites', orderBy: 'created_at DESC');
    return rows.map(Favorite.fromMap).toList();
  }

  // -------------------------------------------------------------------------
  // RESTAURANTS – UTILITIES
  // -------------------------------------------------------------------------

  /// Returns the sorted list of distinct cuisine values stored in the database.
  Future<List<String>> getDistinctCuisines() async {
    final db = await database;
    final rows = await db.rawQuery(
      'SELECT DISTINCT cuisine FROM restaurants '
      'WHERE cuisine IS NOT NULL AND cuisine != "" '
      'ORDER BY cuisine ASC',
    );
    return rows.map((row) => row['cuisine'] as String).toList();
  }

  // -------------------------------------------------------------------------
  // USERS
  // -------------------------------------------------------------------------

  /// Returns the single local user profile.
  Future<User?> getUser() async {
    final db = await database;
    final rows = await db.query('users', limit: 1, orderBy: 'id ASC');
    return rows.isNotEmpty ? User.fromMap(rows.first) : null;
  }

  /// Persists changes to the local user profile. [user.id] must not be null.
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  Future close() async {
    final db = await database;
    db.close();
  }
}
