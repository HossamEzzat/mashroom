import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/feature_card.dart';
import '../../../models/plant_model.dart';
import '../../disease/screens/disease_prediction_screen.dart';
import '../widgets/mushroom_grid_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.animationSlow,
    );
    _animationController.forward();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Sample mushroom data
  static final List<Mushroom> _sampleMushrooms = [
    Mushroom(
      name: 'Amanita muscaria',
      image: 'assets/mushrooms/Amanitamuscaria.jpg',
      type: 'Poisonous',
      habitat: 'Forests, near birch and pine trees',
      edibility: 'Toxic',
      description:
          'Iconic red cap with white spots. Highly toxic and hallucinogenic.',
      symptoms: ['Nausea', 'Hallucinations', 'Confusion'],
      sporePrintColor: 'White',
    ),
    Mushroom(
      name: 'Boletus edulis',
      image: 'assets/mushrooms/Boletus.jpg',
      type: 'Edible',
      habitat: 'Deciduous and coniferous forests',
      edibility: 'Edible',
      description: 'Prized edible mushroom, known as porcini or king bolete.',
      symptoms: [],
      sporePrintColor: 'Olive-brown',
    ),
    Mushroom(
      name: 'Chanterelle',
      image: 'assets/mushrooms/Cantharellus.jpg',
      type: 'Edible',
      habitat: 'Hardwood and coniferous forests',
      edibility: 'Edible',
      description: 'Golden-yellow funnel-shaped mushroom with a fruity aroma.',
      symptoms: [],
      sporePrintColor: 'Pale yellow',
    ),
    Mushroom(
      name: 'Death Cap',
      image: 'assets/mushrooms/Amanita phalloides.jpg',
      type: 'Poisonous',
      habitat: 'Near oak and chestnut trees',
      edibility: 'Deadly',
      description:
          'One of the most poisonous mushrooms. Responsible for most fatal poisonings.',
      symptoms: ['Severe abdominal pain', 'Vomiting', 'Liver failure'],
      sporePrintColor: 'White',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: CustomScrollView(
        // This makes the entire screen scroll smoothly
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, theme),

          // Using a single SliverToBoxAdapter for the top content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildGreeting(theme),
                  const SizedBox(height: 20),
                  _buildSearchBar(theme),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Refactor MushroomGridView to be a Sliver, or wrap it properly:
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: MushroomGridView(mushrooms: _sampleMushrooms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFFFBFBFB),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () async {
            // Show confirmation dialog or just logout
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              await AuthService().signOut();
              // AuthWrapper will handle navigation
            }
          },
          icon: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons
                  .logout_rounded, // Changed icon to indicate logout availability or keep person
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGreeting(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Mushroom Explorer! 🍄",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/stephine.jpg'),
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return AnimatedContainer(
      duration: AppTheme.animationMedium,
      curve: AppTheme.defaultCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isSearchFocused
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: _isSearchFocused ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _isSearchFocused
              ? AppColors.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: "Search species, habitats...",
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          icon: AnimatedContainer(
            duration: AppTheme.animationMedium,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isSearchFocused
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.search,
              color: _isSearchFocused ? AppColors.primary : Colors.grey[400],
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FeatureCard(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DiseasePredictionScreen(),
              ),
            ),
            icon: Icons.filter_center_focus, // More "Scan-like" icon
            title: "Identify",
            subtitle: "Scan Species",
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FeatureCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Recipe collection coming soon!"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF2D3142),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: Icons.restaurant_menu_rounded,
            title: "Recipes",
            subtitle: "Culinary Guide",
            color: const Color(0xFF2D3142), // Darker professional tone
          ),
        ),
      ],
    );
  }
}
