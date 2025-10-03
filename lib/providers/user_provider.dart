import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<String> savedCategoryIds;
  final List<String> alreadyKnownWordIds;
  final Language language;

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
    this.savedCategoryIds = const [],
    this.alreadyKnownWordIds = const [],
    this.language = Language.english,
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
    List<String>? savedCategoryIds,
    List<String>? alreadyKnownWordIds,
    Language? language,
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
      savedCategoryIds: savedCategoryIds ?? this.savedCategoryIds,
      alreadyKnownWordIds: alreadyKnownWordIds ?? this.alreadyKnownWordIds,
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

  Language get selectedLanguage {
    return _currentUser?.language ?? Language.english;
  }

  void updateLanguage(Language language) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(language: language);
    notifyListeners();

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_language', language.value);
  }

  Future<void> loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageValue = prefs.getInt('selected_language');

    if (languageValue != null && _currentUser != null) {
      final language = Language.fromValue(languageValue);
      _currentUser = _currentUser!.copyWith(language: language);
      notifyListeners();
    }
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
    if (!currentFavorites.any((w) => w.id == word.id)) {
      currentFavorites.add(word);
      _currentUser = _currentUser!.copyWith(favoriteWords: currentFavorites);
      notifyListeners();
    }
  }

  void removeWordFromFavorites(Word word) {
    if (_currentUser == null) return;
    
    final currentFavorites = List<Word>.from(_currentUser!.favoriteWords);
    currentFavorites.removeWhere((w) => w.id == word.id);
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
    return _currentUser!.favoriteWords.any((w) => w.id == word.id);
  }

  List<Word> get favoriteWords {
    return _currentUser?.favoriteWords ?? [];
  }

  // Saved categories management
  void addCategoryToSaved(String categoryId) {
    if (_currentUser == null) return;

    final currentSaved = List<String>.from(_currentUser!.savedCategoryIds);
    if (!currentSaved.contains(categoryId)) {
      currentSaved.add(categoryId);
      _currentUser = _currentUser!.copyWith(savedCategoryIds: currentSaved);
      notifyListeners();
    }
  }

  void removeCategoryFromSaved(String categoryId) {
    if (_currentUser == null) return;

    final currentSaved = List<String>.from(_currentUser!.savedCategoryIds);
    currentSaved.remove(categoryId);
    _currentUser = _currentUser!.copyWith(savedCategoryIds: currentSaved);
    notifyListeners();
  }

  void toggleCategorySaved(String categoryId) {
    if (_currentUser == null) return;

    if (isCategorySaved(categoryId)) {
      removeCategoryFromSaved(categoryId);
    } else {
      addCategoryToSaved(categoryId);
    }
  }

  bool isCategorySaved(String categoryId) {
    if (_currentUser == null) return false;
    return _currentUser!.savedCategoryIds.contains(categoryId);
  }

  List<String> get savedCategoryIds {
    return _currentUser?.savedCategoryIds ?? [];
  }

  // Already known words management
  void addWordToAlreadyKnown(String wordId) {
    if (_currentUser == null) return;

    final currentKnown = List<String>.from(_currentUser!.alreadyKnownWordIds);
    if (!currentKnown.contains(wordId)) {
      currentKnown.add(wordId);
      _currentUser = _currentUser!.copyWith(alreadyKnownWordIds: currentKnown);
      notifyListeners();
    }
  }

  void removeWordFromAlreadyKnown(String wordId) {
    if (_currentUser == null) return;

    final currentKnown = List<String>.from(_currentUser!.alreadyKnownWordIds);
    currentKnown.remove(wordId);
    _currentUser = _currentUser!.copyWith(alreadyKnownWordIds: currentKnown);
    notifyListeners();
  }

  void toggleWordAlreadyKnown(String wordId) {
    if (_currentUser == null) return;

    if (isWordAlreadyKnown(wordId)) {
      removeWordFromAlreadyKnown(wordId);
    } else {
      addWordToAlreadyKnown(wordId);
    }
  }

  bool isWordAlreadyKnown(String wordId) {
    if (_currentUser == null) return false;
    return _currentUser!.alreadyKnownWordIds.contains(wordId);
  }

  List<String> get alreadyKnownWordIds {
    return _currentUser?.alreadyKnownWordIds ?? [];
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void initializeDefaultUser() async {
    _currentUser = User(
      id: 'default_user',
      name: 'Driver',
      email: 'john.driver@example.com',
      jobTitle: 'Professional Truck Driver',
      daysLearning: 28,
      wordsLearned: 247,
      currentStreak: 7,
    );

    // Load saved language preference
    await loadLanguagePreference();
    notifyListeners();
  }
}