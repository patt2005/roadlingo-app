import 'package:flutter/foundation.dart';
import '../models/word.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String jobTitle;
  final int daysLearning;
  final int wordsLearned;
  final int currentStreak;
  final String? profileImageUrl;
  final List<Word> favoriteWords;
  final String language;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.jobTitle,
    this.daysLearning = 0,
    this.wordsLearned = 0,
    this.currentStreak = 0,
    this.profileImageUrl,
    this.favoriteWords = const [],
    this.language = 'en',
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? jobTitle,
    int? daysLearning,
    int? wordsLearned,
    int? currentStreak,
    String? profileImageUrl,
    List<Word>? favoriteWords,
    String? language,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      jobTitle: jobTitle ?? this.jobTitle,
      daysLearning: daysLearning ?? this.daysLearning,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      currentStreak: currentStreak ?? this.currentStreak,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      favoriteWords: favoriteWords ?? this.favoriteWords,
      language: language ?? this.language,
    );
  }
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  
  bool get isLoggedIn => _currentUser != null;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateUser({
    String? name,
    String? email,
    String? jobTitle,
    String? profileImageUrl,
  }) {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      jobTitle: jobTitle,
      profileImageUrl: profileImageUrl,
    );
    notifyListeners();
  }

  void updateLanguage(String languageCode) {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(language: languageCode);
    notifyListeners();
  }

  void updateProgress({
    int? daysLearning,
    int? wordsLearned,
    int? currentStreak,
  }) {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      daysLearning: daysLearning,
      wordsLearned: wordsLearned,
      currentStreak: currentStreak,
    );
    notifyListeners();
  }

  void incrementWordsLearned() {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      wordsLearned: _currentUser!.wordsLearned + 1,
    );
    notifyListeners();
  }

  void incrementCurrentStreak() {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      currentStreak: _currentUser!.currentStreak + 1,
    );
    notifyListeners();
  }

  void incrementDaysLearning() {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      daysLearning: _currentUser!.daysLearning + 1,
    );
    notifyListeners();
  }

  // Favorite words management
  void addWordToFavorites(Word word) {
    if (_currentUser == null) return;
    
    final currentFavorites = List<Word>.from(_currentUser!.favoriteWords);
    if (!currentFavorites.any((w) => w.text == word.text)) {
      currentFavorites.add(word);
      _currentUser = _currentUser!.copyWith(favoriteWords: currentFavorites);
      notifyListeners();
    }
  }

  void removeWordFromFavorites(Word word) {
    if (_currentUser == null) return;
    
    final currentFavorites = List<Word>.from(_currentUser!.favoriteWords);
    currentFavorites.removeWhere((w) => w.text == word.text);
    _currentUser = _currentUser!.copyWith(favoriteWords: currentFavorites);
    notifyListeners();
  }

  void toggleWordFavorite(Word word) {
    if (_currentUser == null) return;
    
    if (isWordFavorite(word)) {
      removeWordFromFavorites(word);
    } else {
      addWordToFavorites(word);
    }
  }

  bool isWordFavorite(Word word) {
    if (_currentUser == null) return false;
    return _currentUser!.favoriteWords.any((w) => w.text == word.text);
  }

  List<Word> get favoriteWords {
    return _currentUser?.favoriteWords ?? [];
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void initializeDefaultUser() {
    _currentUser = User(
      id: 'default_user',
      name: 'Driver',
      email: 'john.driver@example.com',
      jobTitle: 'Professional Truck Driver',
      daysLearning: 28,
      wordsLearned: 247,
      currentStreak: 7,
    );
    notifyListeners();
  }
}