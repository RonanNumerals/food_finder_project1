import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'restaurant_data.dart';

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
      version: 1,
      onCreate: _createDB,
    );
  }
  
  // Create database tables
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      image_path TEXT,
      description TEXT,
      location TEXT,
      rating REAL,
      hours TEXT
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
      restaurant_id INTEGER NOT NULL,
      favorite_bool INTEGER NOT NULL,
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

    await _seedRestaurantData(db);
  }
  
  Future<void> _seedRestaurantData(Database db) async {
    final restaurants = RestaurantData.restaurants;

    for (var restaurant in restaurants) {
      // Insert restaurant
      final restaurantId = await db.insert('restaurants', {
        'name': restaurant['name'],
        'image_path': restaurant['image_path'],
        'description': restaurant['description'],
        'location': restaurant['location'],
        'rating': restaurant['rating'],
        'hours': restaurant['hours'],
      });

      final menuItems = restaurant['menu'] as List;

      final batch = db.batch();

      for (var item in menuItems) {
        batch.insert('menu_items', {
          'restaurant_id': restaurantId,
          'name': item['name'],
          'description': item['description'],
          'price': jsonEncode(item['price']),
        });
      }

      await batch.commit(noResult: true);
    }
  }

  // CREATE - Insert new item
  Future<int> createReview(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('reviews', item);
  }
  
  // READ - Get all items
  Future<List<Map<String, dynamic>>> getAllReviews() async {
    final db = await database;
    return await db.query('reviews', orderBy: 'created_at DESC');
  }
  
  // READ - Get single item by ID
  Future<Map<String, dynamic>?> getReview(int id) async {
    final db = await database;
    final results = await db.query(
      'reviews',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  // UPDATE - Update existing item
  Future<int> updateReview(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'reviews',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // DELETE - Remove item
  Future<int> deleteReview(int id) async {
    final db = await database;
    return await db.delete(
      'reviews',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Close database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}