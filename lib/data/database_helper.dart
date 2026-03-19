import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
      FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    await _seedRestaurantData(db);
  }
  
  Future<void> _seedRestaurantData(Database db) async {
    final restaurants = [
      {
        'name': 'Baraka Shawarma',
        'image_path': 'assets/images/baraka_shawarma.jpg',
        'description': 'Welcome to Baraka Shawarma, where tradition meets freshness! We bring you the rich and authentic flavors of Mediterranean cuisine, made with only the finest ingredients. Our goal is simple—to serve delicious, high-quality food that keeps our customers coming back for more.',
        'location': '68 Walton Street Northwest, Atlanta, GA, 30303',
        'rating': 4.6,
        'hours': 'Sunday - Thursday: 11:00 AM - 10:00 PM; Friday - Saturday: Closed',
        'menu': [
          {
            'name': 'Gyro Shawarma',
            'description': '',
            'price': [8.49, 10.49],
          },
          {
            'name': 'Falafel',
            'description': '',
            'price': [7.99, 9.99],
          },
          {
            'name': 'Chicken Shawarma Plate',
            'description': '',
            'price': [13.99],
          }
        ]
      },
      {
        'name': 'Chick-fil-A',
        'image_path': 'assets/images/chick_fil_a.jpg',
        'description': 'Whether you\'re hungry for a Chick-fil-A® Chicken Sandwich or salads made fresh daily, we\'re here to serve you delicious food made with quality ingredients every day (except Sunday).',
        'location': '100 Piedmont Avenue SE Atlanta, GA 30303',
        'rating': 4.6,
        'hours': 'Monday - Saturday: 8:00 AM - 3:00 PM',
        'menu': [
          {
            'name': 'Chick-fil-A Chicken Sandwich',
            'description': 'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.',
            'price': [4.29],
          },
          {
            'name': 'Chick-fil-A Nuggets',
            'description': 'Bite-sized pieces of boneless chicken breast, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.',
            'price': [4.39, 6.15],
          },
          {
            'name': 'Chick-fil-A Cool Wrap',
            'description': 'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.',
            'price': [7.29],
          }
        ]
      },
      {
        'name': 'NaanStop',
        'image_path': 'assets/images/naanstop.jpg',
        'description': 'At NaanStop, we want to make Indian food accessible to everyone. All of our recipes have been passed down from our grandmother to our mom to us.',
        'location': '64 Broad St NW, Atlanta, GA 30303',
        'rating': 4.5,
        'hours': 'Monday - Friday 10:30 AM - 5:00 PM, Saturday - Sunday: Closed',
        'menu': [
          {
            'name': 'Chicken Tikka Masala Bowl',
            'description': 'Our most popular meal! Grilled, marinated chicken in tomato cream sauce over Basmati rice with your choice of toppings.',
            'price': [12.00],
          },
          {
            'name': 'Naan',
            'description': 'Fresh baked, charred flatbread. Choose Plain, Garlic, Bullet (Spicy) or Cheese-stuffed',
            'price': [2.99],
          },
          {
            'name': 'Rice Bowl (Small)',
            'description': 'Build your own Rice Bowl. Start with Basmati Rice, choose your proteins and as many garnishes and chutneys as you like!',
            'price': [9.99],
          }
        ]
      }
    ];

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
  Future<int> createItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('menu_items', item);
  }
  
  // READ - Get all items
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query('menu_items', orderBy: 'created_at DESC');
  }
  
  // READ - Get single item by ID
  Future<Map<String, dynamic>?> getItem(int id) async {
    final db = await database;
    final results = await db.query(
      'menu_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  // UPDATE - Update existing item
  Future<int> updateItem(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'menu_items',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // DELETE - Remove item
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'menu_items',
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