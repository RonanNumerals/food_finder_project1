import '../models/restaurant.dart';
import '../models/menu.dart';

final List<Restaurant> sampleRestaurants = [
  Restaurant(
    name: 'Baraka Shawarma',
    imagePath: 'assets/images/baraka_shawarma.jpg',
    menuItems: [
      MenuItem(
        name: 'Gyro Shawarma',
        description: '',
        price: [8.49, 10.49],
      ),
      MenuItem(
        name: 'Falafel',
        description: '',
        price: [7.99, 9.99],
      ),
      MenuItem(
        name: 'Chicken Shawarma Plate',
        description: '',
        price: [13.99],
      ),
    ],
    description: 'Welcome to Baraka Shawarma, where tradition meets freshness! We bring you the rich and authentic flavors of Mediterranean cuisine, made with only the finest ingredients. Our goal is simple—to serve delicious, high-quality food that keeps our customers coming back for more.',
    hours: ['Sunday - Thursday: 11:00 AM - 10:00 PM', 'Friday - Saturday: Closed'],
    rating: 4.6,
    location: '68 Walton Street Northwest, Atlanta, GA, 30303'
  ),

  Restaurant(
    name: 'Chick-fil-A',
    imagePath: 'assets/images/chick_fil_a.jpg',
    menuItems: [
      MenuItem(
        name: 'Chick-fil-A Chicken Sandwich',
        description: 'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.',
        price: [4.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Nuggets',
        description: 'Bite-sized pieces of boneless chicken breast, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.',
        price: [4.39, 6.15],
      ),
      MenuItem(
        name: 'Chick-fil-A Cool Wrap',
        description: 'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.',
        price: [7.29],
      ),
    ],
    description: 'Whether you\'re hungry for a Chick-fil-A® Chicken Sandwich or salads made fresh daily, we\'re here to serve you delicious food made with quality ingredients every day (except Sunday).',
    hours: ['Monday - Saturday: 8:00 AM - 3:00 PM'],
    rating: 4.6,
    location: '100 Piedmont Avenue SE Atlanta, GA 30303'
  ),

  Restaurant(
    name: 'NaanStop',
    imagePath: 'assets/images/naanstop.jpg',
    menuItems: [
      MenuItem(
        name: 'Chicken Tikka Masala Bowl',
        description: 'Our most popular meal! Grilled, marinated chicken in tomato cream sauce over Basmati rice with your choice of toppings.',
        price: [12.00],
      ),
      MenuItem(
        name: 'Naan',
        description: 'Fresh baked, charred flatbread. Choose Plain, Garlic, Bullet (Spicy) or Cheese-stuffed',
        price: [2.99],
      ),
      MenuItem(
        name: 'Rice Bowl (Small)',
        description: 'Build your own Rice Bowl. Start with Basmati Rice, choose your proteins and as many garnishes and chutneys as you like!',
        price: [9.99],
      ),
    ],
    description: 'At NaanStop, we want to make Indian food accessible to everyone. All of our recipes have been passed down from our grandmother to our mom to us.',
    hours: ['Monday - Friday 10:30 AM - 5:00 PM', 'Saturday - Sunday: Closed'],
    rating: 4.2,
    location: '64 Broad St NW, Atlanta, GA 30303'
  ),
];