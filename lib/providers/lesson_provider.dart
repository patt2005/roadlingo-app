import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../models/lesson.dart';
import '../models/word.dart';

class LessonProvider extends ChangeNotifier {
  List<models.Category> _categories = [];
  
  List<models.Category> get categories => _categories;
  
  List<Lesson> get allLessons {
    List<Lesson> lessons = [];
    for (models.Category category in _categories) {
      lessons.addAll(category.lessons);
    }
    return lessons;
  }
  
  void initializeCategories() {
    _categories = [
      models.Category(
        id: '1',
        title: 'Truck Parts Glossary',
        shortDescription: 'Essential safety terms and phrases for the road',
        imageUrl:
            'https://blog.torqueusa.com/wp-content/uploads/2023/12/Truck-Parts-Blog1.jpg',
        lessons: [
          Lesson(
            id: '1-1',
            title: 'Engine Components',
            words: [
              Word(
                text: 'Engine',
                imageUrl:
                    'https://t3.ftcdn.net/jpg/14/63/15/70/360_F_1463157032_EYIIqcgfGbZ2MwrO7ypMg5eg9OCdXCmk.jpg',
                explanation:
                    'The main power source of the truck that converts fuel into motion.',
                audioUrl:
                    "https://storage.googleapis.com/ai-assistant-backend-bucket/images%20for%20parks2/imagepath/ElevenLabs_2025-09-12T10_29_53_Rachel_pre_sp100_s50_sb75_se0_b_m2.mp3",
              ),
              Word(
                text: 'Radiator',
                imageUrl:
                    'https://www.becool.com/sites/default/files/products/60013.jpg',
                explanation:
                    'Cools the engine by dissipating heat from the coolant.',
                audioUrl:
                    "https://storage.googleapis.com/ai-assistant-backend-bucket/images%20for%20parks2/imagepath/ElevenLabs_2025-09-12T10_29_53_Rachel_pre_sp100_s50_sb75_se0_b_m2.mp3",
              ),
              Word(
                text: 'Battery',
                imageUrl:
                    'https://image.made-in-china.com/2f0j00upWUVNlhYzgy/Good-Performance-N170-24V-170ah-Lead-Acid-Mf-Heavy-Duty-Truck-Battery.webp',
                explanation:
                    'Provides electrical power to start the engine and run electrical systems.',
                audioUrl:
                    "https://storage.googleapis.com/ai-assistant-backend-bucket/images%20for%20parks2/imagepath/ElevenLabs_2025-09-12T10_29_53_Rachel_pre_sp100_s50_sb75_se0_b_m2.mp3",
              ),
              Word(
                text: 'Alternator',
                imageUrl:
                    'https://cdn11.bigcommerce.com/s-yu3g4/images/stencil/1280x1280/products/7001/17975/240-amp-high-output-racing-alternator-for-GM-truck-LS-brackets-REAR-OUTPUT-8237240-REAR-Mechman_14248__23425.1748457531.jpg?c=2',
                explanation:
                    'Generates electricity to charge the battery while the engine runs.',
              ),
              Word(
                text: 'Oil Filter',
                imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-QmDl4MZlYRouqsgcLc_Z0rHIxkbGpLB5eg&s',
                explanation:
                    'Removes contaminants from engine oil to keep it clean.',
                audioUrl:
                    "https://storage.googleapis.com/ai-assistant-backend-bucket/images%20for%20parks2/imagepath/ElevenLabs_2025-09-12T10_29_53_Rachel_pre_sp100_s50_sb75_se0_b_m2.mp3",
              ),
              Word(
                text: 'Air Filter',
                imageUrl:
                    'https://www.myteeproducts.com/media/catalog/product/cache/ba2416c1763c91c7e4aefd401fb89716/A/i/Air_Filter_Replaces_OEM_11604545_Mytee_Products1.jpg',
                explanation:
                    'Cleans the air entering the engine for proper combustion.',
                audioUrl:
                    "https://storage.googleapis.com/ai-assistant-backend-bucket/images%20for%20parks2/imagepath/ElevenLabs_2025-09-12T10_29_53_Rachel_pre_sp100_s50_sb75_se0_b_m2.mp3",
              ),
            ],
          ),
          Lesson(
            id: '1-2',
            title: 'Exterior Parts',
            words: [
              Word(text: 'Hood', imageUrl: 'https://example.com/images/hood.jpg'),
              Word(
                text: 'Bumper',
                imageUrl: 'https://example.com/images/bumper.jpg',
              ),
              Word(
                text: 'Headlight',
                imageUrl: 'https://example.com/images/headlight.jpg',
              ),
              Word(
                text: 'Mirror',
                imageUrl: 'https://example.com/images/mirror.jpg',
              ),
              Word(
                text: 'Fender',
                imageUrl: 'https://example.com/images/fender.jpg',
              ),
              Word(
                text: 'Grille',
                imageUrl: 'https://example.com/images/grille.jpg',
              ),
            ],
          ),
        ],
      ),
      models.Category(
        id: '2',
        title: 'Truck Cab Exterior — Full Glossary',
        shortDescription: 'Learn vocabulary for truck parts and maintenance',
        imageUrl:
            'https://www.uwsta.com/media/wysiwyg/Types-of-Truck-Beds-Chart.jpg',
        lessons: [
          Lesson(
            id: '2-1',
            title: 'Cab Design',
            words: [
              Word(
                text: 'Sleeper Cab',
                imageUrl: 'https://example.com/images/sleeper_cab.jpg',
              ),
              Word(
                text: 'Day Cab',
                imageUrl: 'https://example.com/images/day_cab.jpg',
              ),
              Word(
                text: 'Extended Cab',
                imageUrl: 'https://example.com/images/extended_cab.jpg',
              ),
              Word(
                text: 'Aerodynamic',
                imageUrl: 'https://example.com/images/aerodynamic.jpg',
              ),
              Word(
                text: 'Windshield',
                imageUrl: 'https://example.com/images/windshield.jpg',
              ),
              Word(text: 'Door', imageUrl: 'https://example.com/images/door.jpg'),
            ],
          ),
          Lesson(
            id: '2-2',
            title: 'External Features',
            words: [
              Word(text: 'Step', imageUrl: 'https://example.com/images/step.jpg'),
              Word(
                text: 'Handle',
                imageUrl: 'https://example.com/images/handle.jpg',
              ),
              Word(
                text: 'Fairing',
                imageUrl: 'https://example.com/images/fairing.jpg',
              ),
              Word(
                text: 'Mudflap',
                imageUrl: 'https://example.com/images/mudflap.jpg',
              ),
              Word(
                text: 'Running Board',
                imageUrl: 'https://example.com/images/running_board.jpg',
              ),
              Word(
                text: 'Chrome',
                imageUrl: 'https://example.com/images/chrome.jpg',
              ),
            ],
          ),
        ],
      ),
      models.Category(
        id: '3',
        title: 'Truck Cab Interior Glossary ',
        shortDescription: 'Master GPS and direction-related English',
        imageUrl:
            'https://wewin.com/wp-content/uploads/2023/06/Truck-Cab-Inside.webp',
        lessons: [
          Lesson(
            id: '3-1',
            title: 'Dashboard Controls',
            words: [
              Word(
                text: 'Speedometer',
                imageUrl: 'https://example.com/images/speedometer.jpg',
              ),
              Word(
                text: 'Tachometer',
                imageUrl: 'https://example.com/images/tachometer.jpg',
              ),
              Word(
                text: 'Fuel Gauge',
                imageUrl: 'https://example.com/images/fuel_gauge.jpg',
              ),
              Word(text: 'GPS', imageUrl: 'https://example.com/images/gps.jpg'),
              Word(
                text: 'Radio',
                imageUrl: 'https://example.com/images/radio.jpg',
              ),
              Word(
                text: 'Air Conditioning',
                imageUrl: 'https://example.com/images/air_conditioning.jpg',
              ),
            ],
          ),
          Lesson(
            id: '3-2',
            title: 'Driver Comfort',
            words: [
              Word(text: 'Seat', imageUrl: 'https://example.com/images/seat.jpg'),
              Word(
                text: 'Steering Wheel',
                imageUrl: 'https://example.com/images/steering_wheel.jpg',
              ),
              Word(
                text: 'Armrest',
                imageUrl: 'https://example.com/images/armrest.jpg',
              ),
              Word(
                text: 'Cup Holder',
                imageUrl: 'https://example.com/images/cup_holder.jpg',
              ),
              Word(
                text: 'Storage',
                imageUrl: 'https://example.com/images/storage.jpg',
              ),
              Word(text: 'Bunk', imageUrl: 'https://example.com/images/bunk.jpg'),
            ],
          ),
        ],
      ),
      models.Category(
        id: '4',
        title: 'Wheels, Tires & Suspension — Full Glossary',
        shortDescription: 'Communication for cargo and delivery operations',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUSxj0phv0IhYQG2EFs8uuhjJEjiIkA_uf1w&s',
        lessons: [
          Lesson(
            id: '4-1',
            title: 'Tire Types',
            words: [
              Word(
                text: 'All-season',
                imageUrl: 'https://example.com/images/all_season.jpg',
              ),
              Word(
                text: 'Winter',
                imageUrl: 'https://example.com/images/winter.jpg',
              ),
              Word(
                text: 'Drive Tire',
                imageUrl: 'https://example.com/images/drive_tire.jpg',
              ),
              Word(
                text: 'Steer Tire',
                imageUrl: 'https://example.com/images/steer_tire.jpg',
              ),
              Word(
                text: 'Trailer Tire',
                imageUrl: 'https://example.com/images/trailer_tire.jpg',
              ),
              Word(
                text: 'Retread',
                imageUrl: 'https://example.com/images/retread.jpg',
              ),
            ],
          ),
          Lesson(
            id: '4-2',
            title: 'Suspension System',
            words: [
              Word(
                text: 'Air Suspension',
                imageUrl: 'https://example.com/images/air_suspension.jpg',
              ),
              Word(
                text: 'Leaf Spring',
                imageUrl: 'https://example.com/images/leaf_spring.jpg',
              ),
              Word(
                text: 'Shock Absorber',
                imageUrl: 'https://example.com/images/shock_absorber.jpg',
              ),
              Word(text: 'Axle', imageUrl: 'https://example.com/images/axle.jpg'),
              Word(
                text: 'Differential',
                imageUrl: 'https://example.com/images/differential.jpg',
              ),
              Word(text: 'Hub', imageUrl: 'https://example.com/images/hub.jpg'),
            ],
          ),
        ],
      ),
    ];
    notifyListeners();
  }
  
  // Find lesson by ID
  Lesson? getLessonById(String lessonId) {
    for (models.Category category in _categories) {
      for (Lesson lesson in category.lessons) {
        if (lesson.id == lessonId) {
          return lesson;
        }
      }
    }
    return null;
  }
  
  // Mark lesson as completed
  void markLessonAsCompleted(String lessonId) {
    for (int categoryIndex = 0; categoryIndex < _categories.length; categoryIndex++) {
      List<Lesson> lessons = List.from(_categories[categoryIndex].lessons);
      
      for (int lessonIndex = 0; lessonIndex < lessons.length; lessonIndex++) {
        if (lessons[lessonIndex].id == lessonId) {
          lessons[lessonIndex] = lessons[lessonIndex].copyWith(isCompleted: true);
          
          // Update the category with modified lessons
          _categories[categoryIndex] = _categories[categoryIndex].copyWith(lessons: lessons);
          
          notifyListeners();
          return;
        }
      }
    }
  }
  
  // Get completed lessons
  List<Lesson> get completedLessons {
    return allLessons.where((lesson) => lesson.isCompleted).toList();
  }
  
  // Get lessons by category ID
  List<Lesson> getLessonsByCategoryId(String categoryId) {
    models.Category? category = getCategoryById(categoryId);
    return category?.lessons ?? [];
  }
  
  // Find category by ID
  models.Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }
  
  // Get filtered categories by search query
  List<models.Category> getFilteredCategories(String searchQuery) {
    if (searchQuery.isEmpty) {
      return _categories;
    }

    return _categories.where((category) {
      final titleMatch = category.title.toLowerCase().contains(searchQuery.toLowerCase());
      final descriptionMatch = category.shortDescription.toLowerCase().contains(searchQuery.toLowerCase());
      return titleMatch || descriptionMatch;
    }).toList();
  }
  
  // Get completion statistics
  Map<String, int> get completionStats {
    int totalLessons = allLessons.length;
    int completedCount = completedLessons.length;
    int remainingCount = totalLessons - completedCount;
    
    return {
      'total': totalLessons,
      'completed': completedCount,
      'remaining': remainingCount,
    };
  }
  
  // Calculate completion percentage
  double get completionPercentage {
    int total = allLessons.length;
    int completed = completedLessons.length;
    
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }
}