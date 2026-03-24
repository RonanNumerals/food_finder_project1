import '../models/restaurant.dart';
import '../models/menu.dart';

// Typed Restaurant objects for use in UI widgets.
// There are used to seed the database on first run, but also provide a convenient way to work with restaurant data in the app without needing to query the database for every operation.
final List<Restaurant> sampleRestaurants = [
  Restaurant(
    name: 'Baraka Shawarma',
    imagePath: 'assets/images/baraka_shawarma.webp',
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
    cuisine: 'Mediterranean',
    tags: [
      'quick bite',
      'filling',
      'hangry',
      'savory',
      'affordable',
      'halal',
      'lunch',
      'gyro',
      'shawarma',
    ],
  ),
  Restaurant(
    name: 'Chick-fil-A',
    imagePath: 'assets/images/chick_fil_a.jpg',
    menuItems: [
      MenuItem(
        name: 'Chick-fil-A Chicken Sandwich',
        description:
            'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.',
        price: [4.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Nuggets',
        description:
            'Bite-sized pieces of boneless chicken breast, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.',
        price: [4.39, 6.15],
      ),
      MenuItem(
        name: 'Chick-fil-A Cool Wrap',
        description:
            'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.',
        price: [7.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Chicken Biscuit',
        description:
            'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a warm, flaky buttermilk biscuit.',
        price: [3.75],
      ),
      MenuItem(
        name: 'Chick-fil-A Chicken Deluxe Sandwich',
        description:
            'Our original recipe for almost 60 years. A boneless breast of chicken seasoned to perfection, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips, green leaf lettuce, tomato and American cheese.',
        price: [4.79],
      ),
      MenuItem(
        name: 'Chick-fil-A Grilled Chicken Sandwich',
        description:
            'A boneless breast of chicken, marinated with a special blend of seasonings and grilled for a tender and juicy backyard-smoky taste. Served on a toasted, buttery bun with green leaf lettuce and tomato.',
        price: [5.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Grilled Nuggets',
        description:
            'Bite-sized pieces of boneless chicken breast, marinated with a special blend of seasonings and grilled for a tender and juicy backyard-smoky taste. Available with choice of dipping sauce.',
        price: [4.95, 6.95],
      ),
      MenuItem(
        name: 'Chick-fil-A Grilled Chicken Cool Wrap',
        description:
            'Sliced grilled chicken breast nestled in a fresh mix of green leaf lettuce with a blend of shredded Monterey Jack and Cheddar cheeses, tightly rolled in a flaxseed flour flat bread. Made fresh daily. Pairs well with Avocado Lime Ranch dressing.',
        price: [7.79],
      ),
      MenuItem(
        name: 'Chick-fil-A Chicken Strips',
        description:
            'Hand-breaded chicken breast strips, seasoned to perfection, freshly breaded and pressure cooked in 100% refined peanut oil. Available with choice of dipping sauce.',
        price: [4.95, 6.95],
      ),
      MenuItem(
        name: 'Chick-fil-A Grilled Chicken Strips',
        description:
            'Hand-breaded chicken breast strips, marinated with a special blend of seasonings and grilled for a tender and juicy backyard-smoky taste. Available with choice of dipping sauce.',
        price: [5.95, 7.95],
      ),
      MenuItem(
        name: 'Chick-fil-A Chicken Salad',
        description:
            'Chopped Chick-fil-A Nuggets, chopped eggs, celery and relish with a blend of seasonings and mayonnaise. Served on a bed of fresh greens.',
        price: [5.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Grilled Chicken Salad',
        description:
            'Sliced grilled chicken breast, chopped eggs, celery and relish with a blend of seasonings and mayonnaise. Served on a bed of fresh greens.',
        price: [6.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Cobb Salad',
        description:
            'Sliced grilled chicken breast, chopped eggs, green leaf lettuce, grape tomatoes, shredded Monterey Jack and Cheddar cheeses, crumbled bacon and charred corn with a blend of seasonings and mayonnaise. Served on a bed of fresh greens.',
        price: [7.29],
      ),
      MenuItem(
        name: 'Chick-fil-A Spicy Chicken Sandwich',
        description:
            'A boneless breast of chicken seasoned with a spicy blend of peppers, freshly breaded, pressure cooked in 100% refined peanut oil and served on a toasted, buttery bun with dill pickle chips.',
        price: [4.29],
      ),
    ],
    description:
        'Whether you\'re hungry for a Chick-fil-A® Chicken Sandwich or salads made fresh daily, we\'re here to serve you delicious food made with quality ingredients every day (except Sunday).',
    hours: 'Monday - Saturday: 8:00 AM - 3:00 PM',
    rating: 4.6,
    location: '100 Piedmont Avenue SE Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'American',
    tags: [
      'quick bite',
      'comfort food',
      'hangry',
      'affordable',
      'chicken',
      'fast food',
      'filling',
      'classic',
    ],
  ),
  Restaurant(
    name: 'NaanStop',
    imagePath: 'assets/images/naanstop.jpg',
    menuItems: [
      MenuItem(
        name: 'Chicken Tikka Masala Bowl',
        description:
            'Our most popular meal! Grilled, marinated chicken in tomato cream sauce over Basmati rice with your choice of toppings.',
        price: [12.00],
      ),
      MenuItem(
        name: 'Naan',
        description:
            'Fresh baked, charred flatbread. Choose Plain, Garlic, Bullet (Spicy) or Cheese-stuffed',
        price: [2.99],
      ),
      MenuItem(
        name: 'Rice Bowl (Small)',
        description:
            'Build your own Rice Bowl. Start with Basmati Rice, choose your proteins and as many garnishes and chutneys as you like!',
        price: [9.99],
      ),
    ],
    description:
        'At NaanStop, we want to make Indian food accessible to everyone. All of our recipes have been passed down from our grandmother to our mom to us.',
    hours: 'Monday - Friday 10:30 AM - 5:00 PM',
    rating: 4.2,
    location: '64 Broad St NW, Atlanta, GA 30303',
    priceLevel: 2,
    cuisine: 'Indian',
    tags: [
      'filling',
      'flavorful',
      'hangry',
      'adventurous',
      'spicy',
      'rice bowl',
      'lunch',
      'international',
    ],
  ),
  Restaurant(
    name: 'Land of a Thousand Hills Coffee',
    imagePath: 'assets/images/land_of_a_thousand_hills.jpg',
    menuItems: [
      MenuItem(
        name: 'Bombo Chill',
        description:
            '"Bombo" in Kinyarwanda means sweet. Chocolate, caramel, and espresso. Add whipped topping for extra sweetness.',
        price: [7.00, 8.00],
      ),
      MenuItem(
        name: 'Rwandan Chill',
        description:
            'Vanilla, caramel, and espresso. Add whipped topping for extra sweetness.',
        price: [7.00, 8.00],
      ),
      MenuItem(
        name: 'Drip Coffee',
        description: '12oz and 16oz',
        price: [3.50, 4.00],
      ),
      MenuItem(
        name: 'Cold Brew',
        description: 'Slowed brewed over 12 hours.',
        price: [5.50, 6.50],
      ),
      MenuItem(
        name: 'Americano',
        description:
            'Served in sizes ranging 6-16oz. (180-500mL). In general, 2-3 shots per 8 ounces (240mL) of beverage. The hot water fills the cup about 3/4 full then is topped with espresso for preservation of the crema.',
        price: [4.00, 5.50, 6.00],
      ),
      MenuItem(
        name: 'Cappuccino',
        description:
            '5-6oz. (150-180mL), a cappuccino is a coffee and milk beverage served as a harmonious balance of rich, sweet milk and espresso. It is prepared with a double shot of espresso, textured milk, and foam.',
        price: [4.50],
      ),
      MenuItem(
        name: 'Caramanilla Latte',
        description: 'Espresso',
        price: [6.25],
      ),
      MenuItem(
        name: 'CinnaHoney Latte',
        description: 'Espresso',
        price: [6.25],
      ),
      MenuItem(
        name: 'Dirty Chai Latte',
        description:
            '12oz. drink of black tea infused with cinnamon, clove, and other warming spices combined with a double shot of espresso for an extra caffeine kick. Topped with steamed milk for the perfect balance of sweet and spicy.',
        price: [6.55],
      ),
      MenuItem(
        name: 'Latte',
        description:
            'Served using one or two shots of espresso, topped-up with steamed milk, and finished with a small layer of foam on top.',
        price: [5.50],
      ),
      MenuItem(
        name: 'Snickerdoodle Latte',
        description: 'Season Drinks/Spring Menu.',
        price: [7.00],
      ),
      MenuItem(
        name: 'Leather&Lace',
        description: 'Season Drinks/Spring Menu.',
        price: [6.50],
      ),
      MenuItem(name: 'Earl Grey (black)', description: 'Tea.', price: [4.25]),
      MenuItem(
        name: 'English Breakfast (black)',
        description: 'Tea.',
        price: [4.25],
      ),
      MenuItem(
        name: 'Cherry Rose Sencha (green)',
        description: 'Tea.',
        price: [4.25],
      ),
    ],
    description:
        'The cafe is located inside the iconic wedge-shaped building constructed in 1897 commonly referred to as the Flatiron building. Bring your computer, enjoy the open workspaces, and a hot cup of Rwandan coffee.',
    hours: 'Monday - Friday: 8:15 AM - 3:45 PM',
    rating: 4.0,
    location: '84 Peachtree St NW, Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'Cafe',
    tags: [
      'chill',
      'study spot',
      'cozy',
      'coffee',
      'calm',
      'work',
      'aesthetic',
      'relaxed',
      'bored',
    ],
  ),
  Restaurant(
    name: 'Café Lucia',
    imagePath: 'assets/images/cafe_lucia.jpg',
    menuItems: [
      MenuItem(
        name: 'The Harrison',
        description: 'Bacon, Egg, Provolone, Siracha, Honey Mayo, Bagel',
        price: [7.00],
      ),
      MenuItem(
        name: 'The Bigwhich',
        description: 'Bacon, Sausage, Ham, Chedder, BBQ Mayo, Everything Bagel',
        price: [7.50],
      ),
      MenuItem(
        name: 'Avacado Toast',
        description: 'Avacado, Tomato, Lime Juice, Onion, Goat Cheese',
        price: [8.00],
      ),
      MenuItem(
        name: 'The Reg',
        description: 'Bacon, Egg, Chedder, Croissant',
        price: [6.50],
      ),
      MenuItem(
        name: 'The Classic',
        description: 'Egg, Chedder, Croissant',
        price: [6.00],
      ),
      MenuItem(
        name: 'Deli Ham or Turkey + Cheese',
        description: 'Spinach, Tomato, Provolone, Mild Mayo, Ciabatta',
        price: [8.00],
      ),
      MenuItem(
        name: 'Avacado Veg',
        description: 'Avacado, Tomato, Onion, Pepper, Goat Cheese, Naan Bread',
        price: [8.50],
      ),
      MenuItem(
        name: 'Dark Roast',
        description: 'Drip Coffee',
        price: [2.50, 2.75, 2.90],
      ),
      MenuItem(
        name: 'Light Roast',
        description: 'Drip Coffee',
        price: [2.50, 2.75, 2.90],
      ),
      MenuItem(
        name: 'Americano',
        description: 'Espresso',
        price: [3.95, 4.00, 4.30],
      ),
      MenuItem(
        name: 'Latte',
        description: 'Espresso',
        price: [4.40, 4.85, 5.35],
      ),
      MenuItem(
        name: 'Cappuccino',
        description: 'Espresso',
        price: [4.40, 4.85, 5.35],
      ),
      MenuItem(
        name: 'Cade Au Lait',
        description: 'Espresso',
        price: [3.80, 4.10, 4.40],
      ),
      MenuItem(
        name: 'Hot Chocolate',
        description: 'Hot Traditional',
        price: [3.45, 3.75, 4.25],
      ),
      MenuItem(
        name: 'Chai Latte',
        description: 'Hot Traditional',
        price: [4.60, 5.05, 5.45],
      ),
      MenuItem(
        name: 'Herbal Tea',
        description: 'Hot Traditional',
        price: [3.25, 3.45, 3.75],
      ),
      MenuItem(
        name: 'London Fog',
        description: 'Hot Traditional',
        price: [3.90, 4.30, 4.75],
      ),
      MenuItem(name: 'Black tea', description: 'Iced Tea', price: [3.80, 4.10]),
      MenuItem(
        name: 'Ginger Tea',
        description: 'Iced Tea',
        price: [3.60, 4.30],
      ),
      MenuItem(name: 'Peach Tea', description: 'Iced Tea', price: [3.20, 4.70]),
    ],
    description:
        'The ambiance embraces a neo-gothic style, offering a unique setting to enjoy your meals. While the service may occasionally be slow, many customers appreciate its relaxing vibe, making it a perfect spot to unwind.',
    hours:
        'Tuesday - Friday: 7:00 AM - 6:00 PM, Saturday - Sunday: 8:00 AM - 4:00 PM',
    rating: 4.4,
    location: '57 Forsyth St NW, Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'Cafe',
    tags: [
      'chill',
      'cozy',
      'aesthetic',
      'brunch',
      'coffee',
      'breakfast',
      'relaxed',
      'gothic',
      'study spot',
      'date',
    ],
  ),
  Restaurant(
    name: 'Sensational Subs',
    imagePath: 'assets/images/sensational_subs.jpg',
    menuItems: [
      MenuItem(
        name: 'Classic Italian Sub',
        description:
            'Genoa salami, ham, pepperoni, provolone, lettuce, tomato, onion, and Italian dressing on a hoagie roll.',
        price: [8.99, 11.99],
      ),
      MenuItem(
        name: 'Turkey Club',
        description:
            'Sliced turkey, bacon, Swiss cheese, lettuce, tomato, and mayo on toasted wheat bread.',
        price: [9.49, 12.49],
      ),
      MenuItem(
        name: 'Meatball Sub',
        description:
            'Homestyle beef meatballs smothered in marinara sauce and melted mozzarella on a toasted hoagie.',
        price: [8.49, 10.99],
      ),
    ],
    description:
        'A no-frills sub shop serving overstuffed sandwiches with fresh-baked bread and quality ingredients. Quick, filling, and easy on the wallet — perfect for a grab-and-go lunch.',
    hours: 'Monday, Wednesday, Thursday: 9:00 AM - 5:00 PM, Tuesday: 9:00 AM - 7:00 PM, Friday: 10:00 AM - 4:00 PM',
    rating: 4.5,
    location: '33 Edgewood Ave SE, Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'American',
    tags: [
      'quick bite',
      'filling',
      'hangry',
      'affordable',
      'lunch',
      'comfort food',
      'sandwiches',
    ],
  ),
  Restaurant(
    name: 'Mr. Hibachi',
    imagePath: 'assets/images/mr_hibachi.jpg',
    menuItems: [
      MenuItem(
        name: 'Hibachi Chicken',
        description:
            'Tender grilled chicken with fried rice, mixed vegetables, and house yum-yum sauce.',
        price: [13.99],
      ),
      MenuItem(
        name: 'Hibachi Steak',
        description:
            'Seasoned sirloin steak grilled to order, served with fried rice and vegetables.',
        price: [16.99],
      ),
      MenuItem(
        name: 'Shrimp Tempura',
        description:
            'Lightly battered shrimp, deep fried until golden, served with tentsuyu dipping sauce.',
        price: [10.99],
      ),
    ],
    description:
        'Bringing the hibachi grill experience to downtown Atlanta. Bold flavors, high heat, and generous portions — from sizzling steak to crispy tempura.',
    hours: 'Monday - Friday: 10:30 AM - 6:00 PM',
    rating: 3.8,
    location: '31 Edgewood Ave NE, Atlanta, GA 30303',
    priceLevel: 2,
    cuisine: 'Japanese',
    tags: [
      'filling',
      'flavorful',
      'hangry',
      'savory',
      'grilled',
      'dinner',
      'adventurous',
      'international',
    ],
  ),
  Restaurant(
    name: 'StrikeOut Wingz ATL',
    imagePath: 'assets/images/strikeout_wingz_atl.jpg',
    menuItems: [
      MenuItem(
        name: 'Classic Buffalo Wings',
        description:
            '8 crispy wings tossed in house buffalo sauce. Served with celery and ranch or bleu cheese.',
        price: [11.99],
      ),
      MenuItem(
        name: 'Honey Garlic Wings',
        description:
            '8 wings glazed in a sweet honey garlic sauce. Sticky, savory, and impossible to put down.',
        price: [11.99],
      ),
      MenuItem(
        name: 'Loaded Fries',
        description:
            'Seasoned fries topped with cheddar cheese sauce, bacon bits, and jalapeños.',
        price: [6.99],
      ),
    ],
    description:
        'ATL\'s go-to spot for saucy, crispy wings with a side of good vibes. Whether you\'re watching the game or just hanging out, StrikeOut Wingz has the flavor to match the moment.',
    hours: 'Monday - Thursday: 11:00 AM - 10:00 PM, Friday - Saturday: 11:00 AM - 12:00 AM, Sunday: 12:00 PM - 9:00 PM',
    rating: 4.5,
    location: '60 Peachtree St NW, Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'American',
    tags: [
      'hangry',
      'comfort food',
      'wings',
      'game day',
      'late night',
      'spicy',
      'social',
      'affordable',
    ],
  ),
  Restaurant(
    name: 'gusto!',
    imagePath: 'assets/images/gusto.jpg',
    menuItems: [
      MenuItem(
        name: 'Grilled Salmon Bowl',
        description:
            'Atlantic salmon over quinoa with roasted veggies, avocado, and lemon-herb vinaigrette.',
        price: [14.99],
      ),
      MenuItem(
        name: 'Veggie Wrap',
        description:
            'Grilled zucchini, bell peppers, hummus, spinach, and feta in a whole wheat wrap.',
        price: [10.49],
      ),
      MenuItem(
        name: 'Acai Bowl',
        description:
            'Thick acai base topped with granola, fresh berries, banana, and a drizzle of honey.',
        price: [9.99],
      ),
    ],
    description:
        'Fresh, feel-good food made with locally sourced ingredients. gusto! is for when you want something light, energizing, and actually good for you — without sacrificing taste.',
    hours: 'Monday - Friday: 10:30 AM - 8:00 PM',
    rating: 4.3,
    location: '2 Park Pl SE SE, Atlanta, GA 30303',
    priceLevel: 2,
    cuisine: 'American',
    tags: [
      'healthy',
      'light',
      'fresh',
      'energized',
      'brunch',
      'clean eating',
      'chill',
      'bowls',
    ],
  ),
  Restaurant(
    name: 'Stoner\'s Pizza',
    imagePath: 'assets/images/stoners_pizza.jpg',
    menuItems: [
      MenuItem(
        name: 'Classic Cheese Pizza',
        description:
            'Hand-tossed dough with house marinara and a generous blanket of mozzarella. Simple and perfect.',
        price: [8.99, 12.99],
      ),
      MenuItem(
        name: 'Pepperoni Overload',
        description:
            'Double pepperoni on house red sauce and mozzarella. No notes.',
        price: [10.99, 14.99],
      ),
      MenuItem(
        name: 'Garlic Knots',
        description:
            'Six buttery, garlicky knots baked fresh and served with marinara dipping sauce.',
        price: [4.99],
      ),
    ],
    description:
        'Late-night pizza done right. Thick slices, heavy toppings, and no judgment. Stoner\'s is the move when it\'s late, you\'re hungry, and nothing else will do.',
    hours: 'Monday - Thursday: 11:00 AM - 1:00 AM, Friday - Sunday: 11:00 AM - 2:00 AM',
    rating: 3.9,
    location: '120 Piedmont Ave NE, Atlanta, GA 30303',
    priceLevel: 1,
    cuisine: 'American',
    tags: [
      'late night',
      'hangry',
      'comfort food',
      'pizza',
      'affordable',
      'filling',
      'bored',
      'chill',
    ],
  ),
];
