import '../models/restaurant.dart';
import '../models/menu.dart';
/*
class RestaurantData {
  static final List<Map<String, dynamic>> restaurants = [
    {
      'name': 'Baraka Shawarma',
      'image_path': 'assets/images/baraka_shawarma.jpg',
      'description':
          'Welcome to Baraka Shawarma, where tradition meets freshness! We bring you the rich and authentic flavors of Mediterranean cuisine, made with only the finest ingredients. Our goal is simple—to serve delicious, high-quality food that keeps our customers coming back for more.',
      'location': '68 Walton Street Northwest, Atlanta, GA, 30303',
      'rating': 4.6,
      'hours':
          'Sunday - Thursday: 11:00 AM - 10:00 PM; Friday - Saturday: Closed',
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
        },
      ],
    },
    {
      'name': 'Chick-fil-A',
      'image_path': 'assets/images/chick_fil_a.jpg',
      'description':
          'Whether you\'re hungry for a Chick-fil-A® Chicken Sandwich or salads made fresh daily, we\'re here to serve you delicious food made with quality ingredients every day (except Sunday).',
      'location': '100 Piedmont Avenue SE Atlanta, GA 30303',
      'rating': 4.6,
      'hours': 'Monday - Saturday: 8:00 AM - 3:00 PM',
      'menu': [
        {
          'name': 'Chick-fil-A Chicken Sandwich',
          'description':
              'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.',
          'price': [4.29],
        },
        {
          'name': 'Chick-fil-A Nuggets',
          'description':
              'Bite-sized pieces of boneless chicken breast, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.',
          'price': [4.39, 6.15],
        },
        {
          'name': 'Chick-fil-A Cool Wrap',
          'description':
              'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.',
          'price': [7.29],
        },
      ],
    },
    {
      'name': 'NaanStop',
      'image_path': 'assets/images/naanstop.jpg',
      'description':
          'At NaanStop, we want to make Indian food accessible to everyone. All of our recipes have been passed down from our grandmother to our mom to us.',
      'location': '64 Broad St NW, Atlanta, GA 30303',
      'rating': 4.5,
      'hours': 'Monday - Friday 10:30 AM - 5:00 PM, Saturday - Sunday: Closed',
      'menu': [
        {
          'name': 'Chicken Tikka Masala Bowl',
          'description':
              'Our most popular meal! Grilled, marinated chicken in tomato cream sauce over Basmati rice with your choice of toppings.',
          'price': [12.00],
        },
        {
          'name': 'Naan',
          'description':
              'Fresh baked, charred flatbread. Choose Plain, Garlic, Bullet (Spicy) or Cheese-stuffed',
          'price': [2.99],
        },
        {
          'name': 'Rice Bowl (Small)',
          'description':
              'Build your own Rice Bowl. Start with Basmati Rice, choose your proteins and as many garnishes and chutneys as you like!',
          'price': [9.99],
        },
      ],
    },
  ];
}
*/

// Typed Restaurant objects for use in UI widgets.
// Replace with database queries later.
final List<Restaurant> sampleRestaurants = [
  Restaurant(
    name: 'Baraka Shawarma',
    imagePath: 'assets/images/baraka_shawarma.jpg',
    menuItems: [
      MenuItem(name: 'Gyro Shawarma', description: '', price: [8.49, 10.49]),
      MenuItem(name: 'Falafel', description: '', price: [7.99, 9.99]),
      MenuItem(name: 'Chicken Shawarma Plate', description: '', price: [13.99]),
    ],
    description:
        'Welcome to Baraka Shawarma, where tradition meets freshness! We bring you the rich and authentic flavors of Mediterranean cuisine, made with only the finest ingredients. Our goal is simple—to serve delicious, high-quality food that keeps our customers coming back for more.',
    hours: 'Sunday - Thursday: 11:00 AM - 10:00 PM',
    rating: 4.6,
    location: '68 Walton Street Northwest, Atlanta, GA, 30303',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'Chick-fil-A',
    imagePath: 'assets/images/chick_fil_a.jpg',
    menuItems: [
      MenuItem( name: 'Chick-fil-A Chicken Sandwich', description: 'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.', price: [4.29]),
      MenuItem(name: 'Chick-fil-A Nuggets', description: 'Bite-sized pieces of boneless chicken breast, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.', price: [4.39, 6.15]),
      MenuItem(name: 'Chick-fil-A Cool Wrap', description: 'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.', price: [7.29]),
    ],
    description: 'Whether you\'re hungry for a Chick-fil-A® Chicken Sandwich or salads made fresh daily, we\'re here to serve you delicious food made with quality ingredients every day (except Sunday).',
    hours: 'Monday - Saturday: 8:00 AM - 3:00 PM',
    rating: 4.6,
    location: '100 Piedmont Avenue SE Atlanta, GA 30303',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'NaanStop',
    imagePath: 'assets/images/naanstop.jpg',
    menuItems: [
      MenuItem(name: 'Chicken Tikka Masala Bowl', description: 'Our most popular meal! Grilled, marinated chicken in tomato cream sauce over Basmati rice with your choice of toppings.', price: [12.00]),
      MenuItem(name: 'Naan', description: 'Fresh baked, charred flatbread. Choose Plain, Garlic, Bullet (Spicy) or Cheese-stuffed', price: [2.99]),
      MenuItem(name: 'Rice Bowl (Small)', description: 'Build your own Rice Bowl. Start with Basmati Rice, choose your proteins and as many garnishes and chutneys as you like!', price: [9.99]),
    ],
    description:
        'At NaanStop, we want to make Indian food accessible to everyone. All of our recipes have been passed down from our grandmother to our mom to us.',
    hours: 'Monday - Friday 10:30 AM - 5:00 PM',
    rating: 4.2,
    location: '64 Broad St NW, Atlanta, GA 30303',
    priceLevel: 2,
  ),
  Restaurant(
    name: 'Land of a Thousand Hills Coffee',
    imagePath: 'assets/images/land_of_a_thousand_hills.jpg',
    menuItems: [
      MenuItem(name: 'Bombo Chill', description: '"Bombo" in Kinyarwanda means sweet. Chocolate, caramel, and espresso. Add whipped topping for extra sweetness.', price: [7.00, 8.00]),
      MenuItem(name: 'Rwandan Chill', description: 'Vanilla, caramel, and espresso. Add whipped topping for extra sweetness.', price: [7.00, 8.00]),
      MenuItem(name: 'Drip Coffee', description: '12oz and 16oz', price: [3.50, 4.00]),
      MenuItem(name: 'Cold Brew', description: 'Slowed brewed over 12 hours.', price: [5.50, 6.50]),
      MenuItem(name: 'Americano', description: 'Served in sizes ranging 6-16oz. (180-500mL). In general, 2-3 shots per 8 ounces (240mL) of beverage. The hot water fills the cup about 3/4 full then is topped with espresso for preservation of the crema.', price: [4.00, 5.50, 6.00]),
      MenuItem(name: 'Cappuccino', description: '5-6oz. (150-180mL), a cappuccino is a coffee and milk beverage served as a harmonious balance of rich, sweet milk and espresso. It is prepared with a double shot of espresso, textured milk, and foam.', price: [4.50]),
      MenuItem(name: 'Caramanilla Latte', description: 'Espresso', price: [6.25]),
      MenuItem(name: 'CinnaHoney Latte', description: 'Espresso', price: [6.25]),
      MenuItem(name: 'Dirty Chai Latte', description: '12oz. drink of black tea infused with cinnamon, clove, and other warming spices combined with a double shot of espresso for an extra caffeine kick. Topped with steamed milk for the perfect balance of sweet and spicy.', price: [6.55]),
      MenuItem(name: 'Latte', description: 'Served using one or two shots of espresso, topped-up with steamed milk, and finished with a small layer of foam on top.', price: [5.50]),
      MenuItem(name: 'Snickerdoodle Latte', description: 'Season Drinks/Spring Menu.', price: [7.00]),
      MenuItem(name: 'Leather&Lace', description: 'Season Drinks/Spring Menu.', price: [6.50]),
      MenuItem(name: 'Earl Grey (black)', description: 'Tea.', price: [4.25]),
      MenuItem(name: 'English Breakfast (black)', description: 'Tea.', price: [4.25]),
      MenuItem(name: 'Cherry Rose Sencha (green)', description: 'Tea.', price: [4.25]),
    ],
    description: 'The cafe is located inside the iconic wedge-shaped building constructed in 1897 commonly referred to as the Flatiron building. Bring your computer, enjoy the open workspaces, and a hot cup of Rwandan coffee.',
    hours: 'Monday - Friday: 8:15 AM - 3:45 PM',
    rating: 4.0,
    location: '84 Peachtree St NW, Atlanta, GA 30303',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'Café Lucia',
    imagePath: 'assets/images/cafe_lucia.jpg',
    menuItems: [
      MenuItem(name: 'The Harrison', description: 'Bacon, Egg, Provolone, Siracha, Honey Mayo, Bagel', price: [7.00]),
      MenuItem(name: 'The Bigwhich', description: 'Bacon, Sausage, Ham, Chedder, BBQ Mayo, Everything Bagel', price: [7.50]),
      MenuItem(name: 'Avacado Toast', description: 'Avacado, Tomato, Lime Juice, Onion, Goat Cheese', price: [8.00]),
      MenuItem(name: 'The Reg', description: 'Bacon, Egg, Chedder, Croissant', price: [6.50]),
      MenuItem(name: 'The Classic', description: 'Egg, Chedder, Croissant', price: [6.00]),
      MenuItem(name: 'Deli Ham or Turkey + Cheese', description: 'Spinach, Tomato, Provolone, Mild Mayo, Ciabatta', price: [8.00]),
      MenuItem(name: 'Avacado Veg', description: 'Avacado, Tomato, Onion, Pepper, Goat Cheese, Naan Bread', price: [8.50]),
      MenuItem(name: 'Dark Roast', description: 'Drip Coffee', price: [2.50, 2.75, 2.90]),
      MenuItem(name: 'Light Roast', description: 'Drip Coffee', price: [2.50, 2.75, 2.90]),
      MenuItem(name: 'Americano', description: 'Espresso', price: [3.95, 4.00, 4.30]),
      MenuItem(name: 'Latte', description: 'Espresso', price: [4.40, 4.85, 5.35]),
      MenuItem(name: 'Cappuccino', description: 'Espresso', price: [4.40, 4.85, 5.35]),
      MenuItem(name: 'Cade Au Lait', description: 'Espresso', price: [3.80, 4.10, 4.40]),
      MenuItem(name: 'Hot Chocolate', description: 'Hot Traditional', price: [3.45, 3.75, 4.25]),
      MenuItem(name: 'Chai Latte', description: 'Hot Traditional', price: [4.60, 5.05, 5.45]),
      MenuItem(name: 'Herbal Tea', description: 'Hot Traditional', price: [3.25, 3.45, 3.75]),
      MenuItem(name: 'London Fog', description: 'Hot Traditional', price: [3.90, 4.30, 4.75]),
      MenuItem(name: 'Black tea', description: 'Iced Tea', price: [3.80, 4.10]),
      MenuItem(name: 'Ginger Tea', description: 'Iced Tea', price: [3.60, 4.30]),
      MenuItem(name: 'Peach Tea', description: 'Iced Tea', price: [3.20, 4.70]),
    ],
    description: 'The ambiance embraces a neo-gothic style, offering a unique setting to enjoy your meals. While the service may occasionally be slow, many customers appreciate its relaxing vibe, making it a perfect spot to unwind.',
    hours: 'Tuesday - Friday: 7:00 AM - 6:00 PM, Saturday - Sunday: 8:00 AM - 4:00 PM',
    rating: 4.4,
    location: '57 Forsyth St NW, Atlanta, GA 30303',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'Sensational Subs',
    imagePath: '',
    menuItems: [
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
    ],
    description: '',
    hours: 'Monday - Friday 10:30 AM - 5:00 PM',
    rating: 0,
    location: '',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'Mr. Hibachi',
    imagePath: '',
    menuItems: [
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
    ],
    description: '',
    hours: '',
    rating: 0,
    location: '',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'StrikeOut Wingz ATL',
    imagePath: '',
    menuItems: [
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
    ],
    description: '',
    hours: '',
    rating: 0,
    location: '',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'gusto!',
    imagePath: '',
    menuItems: [
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
    ],
    description: '',
    hours: '',
    rating: 0,
    location: '',
    priceLevel: 1,
  ),
  Restaurant(
    name: 'Stoner\'s Pizza',
    imagePath: '',
    menuItems: [
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
      MenuItem(name: '', description: '', price: []),
    ],
    description: '',
    hours: '',
    rating: 0,
    location: '',
    priceLevel: 1,
  ),
];