import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:truck_eng_app/constants/app_colors.dart';
import 'package:truck_eng_app/models/word.dart';
import 'package:truck_eng_app/providers/user_provider.dart';

class QuizScreen extends StatefulWidget {
  final List<Word> words;
  final String title;

  const QuizScreen({
    super.key,
    required this.words,
    required this.title,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentWordIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _lessonCompleted = false;
  bool _isPlaying = false;

  Word get _currentWord => widget.words[_currentWordIndex];
  bool get _isFirstWord => _currentWordIndex == 0;
  bool get _isLastWord => _currentWordIndex == widget.words.length - 1;

  Translation _getTranslationForLanguage(Word word, Language language) {
    // Try to find translation for the selected language
    final translation = word.translations.firstWhere(
      (t) => t.language == language,
      orElse: () {
        // If not found, try to find English translation
        final englishTranslation = word.translations.firstWhere(
          (t) => t.language == Language.english,
          orElse: () {
            // If no English translation, return the first available
            return word.translations.isNotEmpty
                ? word.translations.first
                : Translation(
                    language: language,
                    translatedText: word.term,
                  );
          },
        );
        return englishTranslation;
      },
    );
    return translation;
  }

  void _previousWord() {
    if (!_isFirstWord) {
      setState(() {
        _currentWordIndex--;
      });
    }
  }

  void _nextWord() {
    if (!_isLastWord) {
      setState(() {
        _currentWordIndex++;
      });
    } else if (!_lessonCompleted) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    setState(() {
      _lessonCompleted = true;
    });

    // Update user progress
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.incrementWordsLearned();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColors.background,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success animation icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(Icons.celebration, color: Colors.green, size: 50),
              ),
              const SizedBox(height: 24),
              Text(
                '🎉 Congratulations!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You\'ve successfully completed this lesson!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.text.withValues(alpha: 0.7),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Words learned: ${widget.words.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue Learning',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _playAudio() async {
    if (_currentWord.audioUrl != null && _currentWord.audioUrl!.isNotEmpty) {
      try {
        setState(() {
          _isPlaying = true;
        });
        await _audioPlayer.play(UrlSource(_currentWord.audioUrl!));
        _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
          if (state == PlayerState.completed) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error playing audio: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No audio available for: ${_currentWord.term}'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentWordIndex + 1}/${widget.words.length}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_currentWordIndex + 1) / widget.words.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Word card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Word image
                          if (_currentWord.imageUrl != null)
                            Container(
                              width: 150,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _currentWord.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        size: 40,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Word display
                          Text(
                            _currentWord.term,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Part of speech
                          if (_currentWord.partOfSpeech != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentWord.partOfSpeech!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Translation
                          if (_currentWord.translations.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  final translation = _getTranslationForLanguage(
                                    _currentWord,
                                    userProvider.selectedLanguage,
                                  );

                                  return Column(
                                    children: [
                                      Text(
                                        translation.translatedText,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.text.withValues(alpha: 0.8),
                                          height: 1.4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (translation.definition != null) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          translation.definition!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.text.withValues(alpha: 0.6),
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      if (translation.usageExample != null) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '"${translation.usageExample}"',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.text.withValues(alpha: 0.7),
                                              fontStyle: FontStyle.italic,
                                              height: 1.4,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Practice actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: _isPlaying
                              ? Container(
                                  margin: EdgeInsets.all(15),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.volume_up,
                                  color: AppColors.primary,
                                  size: 25,
                                ),
                          label: 'Listen',
                          onTap: _playAudio,
                        ),
                        _buildActionButton(
                          icon: Icon(
                            userProvider.isWordFavorite(_currentWord)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: AppColors.primary,
                            size: 25,
                          ),
                          label: 'Save',
                          onTap: () {
                            userProvider.toggleWordFavorite(_currentWord);
                            final isNowFavorite = userProvider.isWordFavorite(
                              _currentWord,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isNowFavorite
                                      ? '${_currentWord.term} saved to favorites'
                                      : '${_currentWord.term} removed from favorites',
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icon(
                            userProvider.isWordAlreadyKnown(_currentWord.id)
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: userProvider.isWordAlreadyKnown(_currentWord.id)
                                ? Colors.green
                                : AppColors.primary,
                            size: 25,
                          ),
                          label: 'Know',
                          onTap: () {
                            userProvider.toggleWordAlreadyKnown(_currentWord.id);
                            final isNowKnown = userProvider.isWordAlreadyKnown(
                              _currentWord.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isNowKnown
                                      ? '${_currentWord.term} marked as already known'
                                      : '${_currentWord.term} unmarked as known',
                                ),
                                backgroundColor: isNowKnown
                                    ? Colors.green
                                    : AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Navigation controls
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Previous button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isFirstWord ? null : _previousWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFirstWord
                            ? AppColors.text.withValues(alpha: 0.1)
                            : AppColors.background,
                        foregroundColor: _isFirstWord
                            ? AppColors.text.withValues(alpha: 0.4)
                            : AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _isFirstWord
                                ? AppColors.text.withValues(alpha: 0.2)
                                : AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text(
                        'Previous',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Next/Finish button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLastWord && !_lessonCompleted
                          ? _nextWord
                          : (_isLastWord ? null : _nextWord),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLastWord && !_lessonCompleted
                            ? Colors.green
                            : (_isLastWord
                                ? AppColors.text.withValues(alpha: 0.3)
                                : AppColors.primary),
                        foregroundColor: Colors.white,
                        elevation: _isLastWord && _lessonCompleted ? 0 : 2,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        _isLastWord && !_lessonCompleted
                            ? Icons.flag
                            : Icons.arrow_forward,
                        size: 20,
                      ),
                      label: Text(
                        _isLastWord && !_lessonCompleted
                            ? 'Finish Lesson'
                            : (_lessonCompleted ? 'Completed' : 'Next'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: icon,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.text.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}