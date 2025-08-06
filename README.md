# MovieDB - Flutter Movies Application

A modern Flutter application that displays trending and now playing movies using the TMDB API. The app features offline functionality, bookmarking, search with debouncing, and a beautiful dark theme UI.

## Features

### ✅ Core Features
- **Home Screen**: Displays trending and now playing movies
- **Movie Details**: Detailed view of selected movies
- **Bookmarking**: Save and manage favorite movies
- **Search**: Search movies with debounced input
- **Offline Support**: Movies cached locally for offline viewing

### ✅ Bonus Features
- **Debounced Search**: Network calls made after user stops typing
- **Movie Sharing**: Share movies with deep link support
- **Modern UI**: Beautiful dark theme with Material Design 3
- **Responsive Design**: Works on both Android and iOS

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern with:

- **Models**: Data classes for movies and API responses
- **Views**: Flutter widgets and screens
- **ViewModels**: Provider classes for state management
- **Repository Pattern**: Abstraction layer for data operations
- **Services**: API and database services

## Tech Stack

- **Flutter**: UI framework
- **Provider**: State management
- **Retrofit**: API client with code generation
- **SQLite**: Local database for offline storage
- **Dio**: HTTP client
- **Cached Network Image**: Image caching
- **Share Plus**: Social sharing functionality

## Setup Instructions

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- TMDB API Key

### 1. Clone the Repository
```bash
git clone <repository-url>
cd movie_app
```

### 2. Get TMDB API Key
1. Visit [TMDB Developer Portal](https://developers.themoviedb.org/3/getting-started/introduction)
2. Create an account and request an API key
3. Copy your API key

### 3. Configure API Key
Open `lib/constants/app_constants.dart` and replace:
```dart
static const String apiKey = 'YOUR_TMDB_API_KEY';
```
with your actual API key.

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Generate Code
```bash
flutter packages pub run build_runner build
```

### 6. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── constants/
│   └── app_constants.dart          # App configuration
├── models/
│   ├── movie.dart                  # Movie data model
│   └── api_response.dart           # API response models
├── providers/
│   └── movie_provider.dart         # State management
├── screens/
│   ├── home_screen.dart            # Home screen
│   ├── search_screen.dart          # Search screen
│   ├── bookmarks_screen.dart       # Bookmarks screen
│   └── main_navigation_screen.dart # Main navigation
├── services/
│   ├── tmdb_api_service.dart       # API service
│   ├── database_service.dart       # Local database
│   └── movie_repository.dart       # Repository pattern
├── utils/
│   ├── app_theme.dart              # App theme
│   └── debouncer.dart              # Search debouncing
├── widgets/
│   ├── movie_card.dart             # Movie card widget
│   └── movie_list.dart             # Movie list widget
└── main.dart                       # App entry point
```

## API Endpoints Used

- `GET /trending/movie/week` - Trending movies
- `GET /movie/now_playing` - Now playing movies
- `GET /search/movie` - Search movies
- `GET /movie/{movie_id}` - Movie details

## Database Schema

### Movies Table
- `id` (PRIMARY KEY)
- `title`
- `overview`
- `posterPath`
- `backdropPath`
- `voteAverage`
- `voteCount`
- `releaseDate`
- `genreIds`
- `adult`
- `originalLanguage`
- `originalTitle`
- `popularity`
- `video`
- `isBookmarked`

## Features in Detail

### 1. Home Screen
- Displays trending movies in horizontal scroll
- Shows now playing movies
- Pull-to-refresh functionality
- Error handling with retry options

### 2. Search Screen
- Real-time search with 500ms debouncing
- Search results with movie posters
- Bookmark functionality in search results
- Empty state and loading indicators

### 3. Bookmarks Screen
- Grid layout of saved movies
- Bookmark count display
- Remove bookmarks functionality
- Empty state for no bookmarks

### 4. Offline Support
- Movies cached in SQLite database
- Offline-first approach
- Graceful degradation when API fails

### 5. Modern UI
- Dark theme with Material Design 3
- Smooth animations and transitions
- Responsive design for different screen sizes
- Loading states and error handling

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Acknowledgments

- [TMDB](https://www.themoviedb.org/) for providing the movie data API
- Flutter team for the amazing framework
- All the package authors whose work made this app possible

## Support

For support, please open an issue in the repository or contact the development team.
