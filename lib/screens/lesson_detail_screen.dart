import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:truck_eng_app/constants/app_colors.dart';
import 'package:truck_eng_app/models/lesson.dart';
import 'package:truck_eng_app/models/word.dart';
import 'package:truck_eng_app/providers/user_provider.dart';
import 'package:truck_eng_app/providers/lesson_provider.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final String lessonType;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.lessonType,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentWordIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _lessonCompleted = false;
  bool _isPlaying = false;

  Word get _currentWord => widget.lesson.words[_currentWordIndex];
  bool get _isFirstWord => _currentWordIndex == 0;
  bool get _isLastWord => _currentWordIndex == widget.lesson.words.length - 1;

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

    // Mark lesson as completed in lesson provider
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    lessonProvider.markLessonAsCompleted(widget.lesson.id);

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
                'You\'ve successfully completed the "${widget.lesson.title}" lesson!',
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
                      'Words learned: ${widget.lesson.words.length}',
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
                    Navigator.of(context).pop(); // Go back to lesson list
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
            content: Text('No audio available for: ${_currentWord.text}'),
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
          widget.lesson.title,
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
              '${_currentWordIndex + 1}/${widget.lesson.words.length}',
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
                widthFactor:
                    (_currentWordIndex + 1) / widget.lesson.words.length,
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
                          Container(
                            width: 150,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            child: Image.network(
                              _currentWord.imageUrl,
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

                          const SizedBox(height: 20),

                          // Word display
                          Text(
                            _currentWord.text,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Word explanation
                          if (_currentWord.explanation != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                _currentWord.explanation!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.text.withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Word type indicator
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
                              widget.lessonType == 'Words'
                                  ? 'Vocabulary'
                                  : 'Phrase',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
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
                          icon:
                              _isPlaying
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
                          icon: Icon(Icons.translate),
                          label: 'Translate',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon:
                              userProvider.isWordFavorite(_currentWord)
                                  ? Icon(Icons.bookmark)
                                  : Icon(Icons.bookmark_border),
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
                                      ? '${_currentWord.text} saved to favorites'
                                      : '${_currentWord.text} removed from favorites',
                                ),
                                backgroundColor: AppColors.primary,
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
                        backgroundColor:
                            _isFirstWord
                                ? AppColors.text.withValues(alpha: 0.1)
                                : AppColors.background,
                        foregroundColor:
                            _isFirstWord
                                ? AppColors.text.withValues(alpha: 0.4)
                                : AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                _isFirstWord
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
                      onPressed:
                          _isLastWord && !_lessonCompleted
                              ? _nextWord
                              : (_isLastWord ? null : _nextWord),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isLastWord && !_lessonCompleted
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
