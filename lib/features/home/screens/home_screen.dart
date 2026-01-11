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
      image: 'assets/mushrooms/amanita.png',
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
      image: 'assets/mushrooms/porcini.png',
      type: 'Edible',
      habitat: 'Deciduous and coniferous forests',
      edibility: 'Edible',
      description: 'Prized edible mushroom, known as porcini or king bolete.',
      symptoms: [],
      sporePrintColor: 'Olive-brown',
    ),
    Mushroom(
      name: 'Chanterelle',
      image: 'assets/mushrooms/chanterelle.png',
      type: 'Edible',
      habitat: 'Hardwood and coniferous forests',
      edibility: 'Edible',
      description: 'Golden-yellow funnel-shaped mushroom with a fruity aroma.',
      symptoms: [],
      sporePrintColor: 'Pale yellow',
    ),
    Mushroom(
      name: 'Death Cap',
      image: 'assets/mushrooms/death_cap.png',
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
                  _buildPremiumBanner(theme),
                  const SizedBox(height: 32),
                  _buildCategoryFilter(theme),
                  const SizedBox(height: 20),
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 18),
          const SizedBox(width: 4),
          Text(
            "Fungi World",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ],
      ),
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
            backgroundColor: AppColors.primary.withOpacity(0.1),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back,",
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        Text(
          "Mushroom Explorer! 🍄",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return AnimatedContainer(
      duration: AppTheme.animationMedium,
      curve: AppTheme.defaultCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _isSearchFocused
                ? AppColors.primary.withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: _isSearchFocused ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isSearchFocused
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
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
          icon: AnimatedRotation(
            turns: _isSearchFocused ? 0.5 : 0,
            duration: AppTheme.animationMedium,
            child: const Icon(Icons.search, color: AppColors.primary),
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
            onTap: () {}, // Add navigation
            icon: Icons.auto_awesome,
            title: "Recipes",
            subtitle: "Culinary Guide",
            color: const Color(0xFF2D3142), // Darker professional tone
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBanner(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFFFEDC2A),
                  Colors.orange[300]!,
                  value,
                )!,
                Color.lerp(
                  Colors.orange[400]!,
                  const Color(0xFFFEDC2A),
                  value,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3 + value * 0.1),
                blurRadius: 15 + value * 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.stars, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Get Pro Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Expert ID & Toxic Alerts",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    final categories = ["All", "Edible", "Medicinal", "Toxic", "Rare"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: AppTheme.animationMedium,
              curve: AppTheme.springCurve,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey[200]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
