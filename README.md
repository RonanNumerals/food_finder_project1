# Munchies - Food Finder App

A Flutter-based mobile application that helps users discover restaurants based on their preferences and "vibe" (mood/occasion). Users can browse restaurants, view details, save favorites, leave reviews, and filter by various criteria.

## Team Members
- **Eric Hoang**
- **Ronan Pelot**

## Features
- Restaurant browsing with filtering capabilities (name, cuisine, price level, open now)
- Detailed restaurant views including menu items, hours, and ratings
- Favorite restaurants functionality (save/unsave)
- User review system with ratings and comments
- Dark/Light theme toggle with persistent preference
- User profile management
- Vibe-based restaurant recommendations (mood/occasion matching)
- SQLite database for local data persistence
- Restaurant data seeding with sample establishments

## Technologies Used
- **Flutter**: 3.19.0 (stable channel)
- **Dart**: 3.3.0
- **Packages**:
  - `shared_preferences`: ^2.2.2 (for theme persistence)
  - `sqflite`: ^2.3.0 (for local SQLite database)
- **Tools**:
  - Flutter SDK
  - Android Studio / VS Code
  - Git for version control

## Installation Instructions

### Prerequisites
- Flutter SDK installed (version 3.19.0 or higher)
- Android Studio or Xcode (for mobile emulators/simulators)
- OR a physical Android/iOS device for testing

### Setup Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/RonanNumerals/food_finder_project1.git
   cd food_finder_project1
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Platform Support
- Android (minimum API 21)
- iOS (minimum version 11.0)

## Usage Guide

### Home Screen
Upon launching the app, you'll see the home screen with:
- Search bar to find restaurants by name
- Filter buttons for cuisine, price level, and open status
- List of restaurants matching your criteria

### Restaurant Details
Tap on any restaurant to view:
- Restaurant image and basic info
- Full menu with prices
- Operating hours
- User reviews
- "Add to Favorites" button

### Favorites
Access your saved restaurants via the bottom navigation bar:
- View all favorited restaurants
- Remove restaurants from favorites
- See when each was added

### Reviews
From any restaurant detail screen:
- Tap "Add Review" to leave feedback
- Rate the restaurant (1-5 stars)
- Write a written review
- View existing reviews from other users

### Profile & Settings
Access via the bottom navigation bar:
- View/edit your profile information
- Toggle dark/light mode
- See app version information

### Vibe Screen
Discover restaurants based on your current mood or occasion:
- Select from predefined vibes (casual, romantic, celebratory, etc.)
- Get restaurant recommendations matching that vibe

## Database Schema

The app uses SQLite with the following tables:

### Restaurants
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| name | TEXT NOT NULL | Restaurant name |
| image_path | TEXT | Path to restaurant image |
| description | TEXT | Restaurant description |
| location | TEXT | Restaurant location |
| rating | REAL | Average rating (0-5) |
| hours | TEXT | Operating hours string |
| price_level | INTEGER | Price level (1=$, 2=$$, 3=$$$) |
| cuisine | TEXT | Type of cuisine |
| tags | TEXT | JSON array of tags |

### Menu Items
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| restaurant_id | INTEGER NOT NULL | Foreign key to restaurants |
| name | TEXT NOT NULL | Menu item name |
| description | TEXT | Item description |
| price | TEXT | Price information |

### Favorites
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| restaurant_id | INTEGER NOT NULL UNIQUE | Foreign key to restaurants |
| created_at | TEXT NOT NULL | Timestamp when favorited |

### Reviews
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| restaurant_id | INTEGER NOT NULL | Foreign key to restaurants |
| written_review | TEXT NOT NULL | Review text |
| rating | REAL NOT NULL | Rating (1-5) |
| name | TEXT NOT NULL | Reviewer name |
| created_at | TEXT NOT NULL | Timestamp |

### Users
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| name | TEXT NOT NULL | User name |
| profile_image | TEXT | Path to profile image |
| location | TEXT | User location |

## Future Enhancements
1. **Online Synchronization**: Sync local data with a cloud backend for multi-device support
2. **Advanced Search**: Add more filtering options (dietary restrictions, specific amenities)
3. **Social Features**: Allow users to follow friends and see their reviews/favorites
4. **Notifications**: Push notifications for special deals or events at favorited restaurants
5. **Map Integration**: Show restaurant locations on maps and get directions
6. **Offline Caching**: Improve offline functionality with better data caching
7. **User Authentication**: Implement proper user accounts with email/password or social login
8. **Restaurant Owner Portal**: Allow restaurant owners to manage their listings and respond to reviews
