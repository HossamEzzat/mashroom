import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Theme & Colors
import '../../../core/theme/app_colors.dart';
// Screen Imports - Ensure these paths match your project structure
import '../../cart/screens/cart_screen.dart';
import '../../disease/widgets/prediction_cards.dart';
import '../../events/screens/event_tips_screen.dart'; // This is where EventScreen usually lives
import '../../home/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Using a getter to ensure the most up-to-date callbacks are passed
  List<Widget> get _pages => [
    const HomeScreen(),
    PlantPredictionCards(onTabChange: _onItemTapped),
    LookalikeScreen(onTabChange: _onItemTapped), // Properly linked callback
    EventScreen(onTabChange: _onItemTapped),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack prevents the screens from re-initializing (keeps scroll position)
      body: IndexedStack(index: _selectedIndex, children: _pages),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: Icon(
          Icons.camera_enhance_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.search_rounded, 'Identify', 1),
              const SizedBox(width: 40), // Notch spacer
              _buildNavItem(Icons.compare_rounded, 'Lookalike', 2),
              _buildNavItem(Icons.event_note_rounded, 'Events', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
