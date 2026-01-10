import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/screens/cart_screen.dart';
import '../../disease/widgets/prediction_cards.dart';
import 'home_screen.dart';
import '../../events/screens/event_tips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages with callback
    _pages = [
      const HomeScreen(),
      PlantPredictionCards(onTabChange: _onItemTapped),
      LookalikeScreen(onTabChange: _onItemTapped),
      EventScreen(onTabChange: _onItemTapped),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Predict'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'LookLike'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Events'),
        ],
      ),
    );
  }
}
