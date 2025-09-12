import 'package:flutter/material.dart';
import 'package:truck_eng_app/constants/app_colors.dart';
import 'package:truck_eng_app/models/category.dart';
import 'package:truck_eng_app/screens/lesson_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  String? _selectedLessonType;

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic stats
    final int lessonCount = widget.category.lessons.length;
    final int totalWords = widget.category.lessons.fold(0, (sum, lesson) => sum + lesson.words.length);
    final String estimatedTime = _calculateEstimatedTime(lessonCount, totalWords);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: IconThemeData(color: AppColors.background),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.category.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: Icon(
                          _getCategoryIcon(widget.category.title),
                          size: 80,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.category.title,
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  Text(
                    'About this Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.category.shortDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Quick Stats
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickStat('Lessons', '$lessonCount', Icons.school),
                        _buildDivider(),
                        _buildQuickStat('Words', '$totalWords', Icons.translate),
                        _buildDivider(),
                        _buildQuickStat('Time', estimatedTime, Icons.access_time),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Lesson Types Selection
                  Text(
                    'Choose Lesson Type',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildLessonTypeCard(
                          context: context,
                          icon: Icons.text_fields,
                          title: 'Words',
                          subtitle: 'Learn individual vocabulary',
                          color: AppColors.primary,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.8),
                              AppColors.primary,
                            ],
                          ),
                          isSelected: _selectedLessonType == 'Words',
                          onTap: () {
                            setState(() {
                              _selectedLessonType = 'Words';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildLessonTypeCard(
                          context: context,
                          icon: Icons.chat_bubble_outline,
                          title: 'Phrases',
                          subtitle: 'Practice common expressions',
                          color: Colors.purple,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.purple.withValues(alpha: 0.8),
                              Colors.purple,
                            ],
                          ),
                          isSelected: _selectedLessonType == 'Phrases',
                          onTap: () {
                            setState(() {
                              _selectedLessonType = 'Phrases';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Start Lesson Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _selectedLessonType != null ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LessonScreen(
                              category: widget.category,
                              lessonType: _selectedLessonType!,
                            ),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedLessonType != null 
                            ? AppColors.primary 
                            : AppColors.text.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: _selectedLessonType != null ? 2 : 0,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                      icon: Icon(
                        _selectedLessonType != null ? Icons.play_circle_filled : Icons.lock,
                        color: _selectedLessonType != null 
                            ? Colors.white 
                            : AppColors.text.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      label: Text(
                        _selectedLessonType != null 
                            ? 'Start Lesson'
                            : 'Select a Lesson Type',
                        style: TextStyle(
                          color: _selectedLessonType != null 
                              ? Colors.white 
                              : AppColors.text.withValues(alpha: 0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.text.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.primary.withValues(alpha: 0.2),
    );
  }

  Widget _buildLessonTypeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Gradient gradient,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bool hasSelection = _selectedLessonType != null;
    final double opacity = hasSelection ? (isSelected ? 1.0 : 0.4) : 0.6;
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(color: Colors.white, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? color.withValues(alpha: 0.4) 
                  : color.withValues(alpha: 0.2),
              blurRadius: isSelected ? 15 : 10,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  String _calculateEstimatedTime(int lessonCount, int totalWords) {
    if (lessonCount == 0) return '0m';
    
    // Estimate based on 15 minutes per lesson
    final int totalMinutes = lessonCount * 15;
    
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    } else if (totalMinutes < 120) {
      return '1-2h';
    } else {
      final int hours = (totalMinutes / 60).round();
      return '${hours}h';
    }
  }

  IconData _getCategoryIcon(String title) {
    switch (title) {
      case 'Road Safety':
        return Icons.security;
      case 'Truck Maintenance':
      case 'Truck Parts Glossary':
        return Icons.build;
      case 'Navigation & Directions':
        return Icons.navigation;
      case 'Loading & Delivery':
        return Icons.local_shipping;
      case 'Regulations & Documentation':
        return Icons.description;
      case 'Emergency Situations':
        return Icons.warning;
      case 'Truck Cab Exterior — Full Glossary':
        return Icons.directions_car;
      case 'Truck Cab Interior Glossary':
        return Icons.dashboard;
      case 'Wheels, Tires & Suspension — Full Glossary':
        return Icons.tire_repair;
      default:
        return Icons.school;
    }
  }
}
