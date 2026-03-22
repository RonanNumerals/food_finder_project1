import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'restaurant_data.dart';
import '../models/review.dart';
import '../models/favorite.dart';
import '../models/user.dart';

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
      version: 2,
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
      cuisine TEXT
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

  // Migrate existing database from version 1 to 2
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to restaurants
      await db.execute(
        'ALTER TABLE restaurants ADD COLUMN price_level INTEGER',
      );
      await db.execute('ALTER TABLE restaurants ADD COLUMN cuisine TEXT');

      // Replace old favorites table with the redesigned one
      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('''
        CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id INTEGER NOT NULL UNIQUE,
        created_at TEXT NOT NULL,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
        )
      ''');

      // Create users table
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
  }

  Future<void> _seedRestaurantData(Database db) async {
    for (var restaurant in sampleRestaurants) {
      // Insert restaurant
      final restaurantId = await db.insert('restaurants', {
        'name': restaurant.name,
        'image_path': restaurant.imagePath,
        'description': restaurant.description,
        'location': restaurant.location,
        'rating': restaurant.rating,
        'hours': restaurant.hours,
        'price_level': restaurant.priceLevel,
        'cuisine': restaurant.cuisine,
      });

      final menuItem = restaurant.menuItems;

      final batch = db.batch();

      for (var item in menuItem) {
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
  // REVIEWS
  // -------------------------------------------------------------------------

  // CREATE - Insert new review
  Future<int> createReview(Review review) async {
    final db = await database;
    return await db.insert('reviews', review.toMap());
  }

  // READ - Get all reviews (across all restaurants)
  Future<List<Review>> getAllReviews() async {
    final db = await database;
    final results = await db.query('reviews', orderBy: 'created_at DESC');
    return results.map((map) => Review.fromMap(map)).toList();
  }

  // READ - Get reviews scoped to a single restaurant
  Future<List<Review>> getReviewsByRestaurant(int restaurantId) async {
    final db = await database;
    final results = await db.query(
      'reviews',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      orderBy: 'created_at DESC',
    );
    return results.map((map) => Review.fromMap(map)).toList();
  }

  // READ - Get single review by ID
  Future<Review?> getReview(int id) async {
    final db = await database;
    final results = await db.query('reviews', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? Review.fromMap(results.first) : null;
  }

  // UPDATE - Update existing review
  Future<int> updateReview(Review review) async {
    final db = await database;
    return await db.update(
      'reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  // DELETE - Remove review by ID
  Future<int> deleteReview(int id) async {
    final db = await database;
    return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------------------
  // FAVORITES
  // -------------------------------------------------------------------------

  // ADD - Mark restaurant as favorite
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

  // REMOVE - Unmark restaurant as favorite
  Future<int> removeFavorite(int restaurantId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
  }

  // READ - Check if a restaurant is favorited
  Future<bool> isFavorite(int restaurantId) async {
    final db = await database;
    final results = await db.query(
      'favorites',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  // READ - Get all favorited restaurant IDs
  Future<List<Favorite>> getAllFavorites() async {
    final db = await database;
    final results = await db.query('favorites', orderBy: 'created_at DESC');
    return results.map((map) => Favorite.fromMap(map)).toList();
  }

  // -------------------------------------------------------------------------
  // USERS
  // -------------------------------------------------------------------------

  // READ - Get the local user profile (always row with lowest id)
  Future<User?> getUser() async {
    final db = await database;
    final results = await db.query('users', limit: 1, orderBy: 'id ASC');
    return results.isNotEmpty ? User.fromMap(results.first) : null;
  }

  // UPDATE - Persist changes to the local user profile
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
  // RESTAURANTS & MENU ITEMS (unchanged read helpers)
  // -------------------------------------------------------------------------

  // READ - Get single menu item by ID
  Future<Map<String, dynamic>?> getMenuItem(int id) async {
    final db = await database;
    final results = await db.query(
      'menu_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // READ - Get single restaurant by ID
  Future<Map<String, dynamic>?> getRestaurant(int id) async {
    final db = await database;
    final results = await db.query(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Close database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}
