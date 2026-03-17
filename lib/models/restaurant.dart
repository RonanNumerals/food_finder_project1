class Restaurant {
  final String name;
  final String imagePath;
  final List<String> menuItems;
  final String description;
  final String hours;
  final String location;
  final int rating;

  Restaurant({
    required this.name,
    required this.imagePath,
    required this.menuItems,
    required this.description,
    required this.hours,
    required this.location,
    required this.rating,
  });
}