import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/event_data.dart';
import '../models/event_model.dart';
import 'add_event_screen.dart';
import 'event_details_screen.dart';

class EventScreen extends StatefulWidget {
  final Function(int)? onTabChange;

  const EventScreen({super.key, this.onTabChange});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  late TabController _topTabController;
  late TabController _bottomTabController;

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(length: 3, vsync: this);
    _bottomTabController = TabController(length: 3, vsync: this);
  }

  // State
  final String _searchQuery = '';
  final List<String> _categories = [
    "All",
    "Workshops",
    "Foraging",
    "Online",
    "Exhibitions",
  ];
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _topTabController.dispose();
    _bottomTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 1. Top Discovery Section (Awareness, TIPS, Workshops)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: _buildSectionHeader("Discovery"),
                    ),
                    const SizedBox(height: 12),
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 600),
                      child: _buildTopTabBar(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        controller: _topTabController,
                        physics: const BouncingScrollPhysics(),
                        children: const [
                          DiscoverySlider(
                            items: [
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_awareness_1.jpg',
                                title: "Fungal Diversity",
                                subtitle: "Eco Systems",
                              ),
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_event3.jpg',
                                title: "Safe Foraging",
                                subtitle: "Community",
                              ),
                            ],
                          ),
                          DiscoverySlider(
                            items: [
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_tip_1.jpg',
                                title: "Identification",
                                subtitle: "Expert Tips",
                              ),
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_tip_2.jpg',
                                title: "Spore Printing",
                                subtitle: "Techniques",
                              ),
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_tip_3.jpg',
                                title: "Cooking 101",
                                subtitle: "Culinary",
                              ),
                            ],
                          ),
                          DiscoverySlider(
                            items: [
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_workshop_1.jpg',
                                title: "Grow Kits",
                                subtitle: "Workshop",
                              ),
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_workshop_2.jpg',
                                title: "Mycology Lab",
                                subtitle: "Advanced",
                              ),
                              DiscoveryItem(
                                imagePath: 'assets/mushroom_workshop_3.jpg',
                                title: "Field Trip",
                                subtitle: "Outdoor",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Sticky TabBar for "Your Events"
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(child: _buildBottomTabBar()),
            ),
          ];
        },
        body: TabBarView(
          controller: _bottomTabController,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildEventList(), // This tab will show filtered events
            _buildSavedEventsList(),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('No past events', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEventScreen()),
          ),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Host Event",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => widget.onTabChange?.call(0),
      ),
      title: const Text(
        'Community Events',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[200], height: 1.0),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTopTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _topTabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey[600],
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: const [
          Tab(text: 'Awareness'),
          Tab(text: 'TIPS'),
          Tab(text: 'Workshops'),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _bottomTabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'GOING'),
              Tab(text: 'SAVED'),
              Tab(text: 'PAST'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // 1. Determine Category
    EventCategory selectedCategory;
    switch (_categories[_selectedCategoryIndex]) {
      case "Workshops":
        selectedCategory = EventCategory.workshop;
        break;
      case "Foraging":
        selectedCategory = EventCategory.foraging;
        break;
      case "Online":
        selectedCategory = EventCategory.online;
        break;
      case "Exhibitions":
        selectedCategory = EventCategory.exhibition;
        break;
      default:
        selectedCategory = EventCategory.all;
    }

    // 2. Filter Data
    final filteredEvents = EventData.filterEvents(
      category: selectedCategory,
      searchQuery: _searchQuery,
    );

    // 3. Build List
    if (filteredEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No events found for this category or search.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: EventCardWithDetails(
            event: event,
            onBookmarkToggled: () {
              setState(() {
                EventData.toggleBookmark(event.id);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildSavedEventsList() {
    final savedEvents = EventData.savedEvents;
    if (savedEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No saved events yet',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: savedEvents.length,
      itemBuilder: (context, index) {
        final event = savedEvents[index];
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: EventCardWithDetails(
            event: event,
            onBookmarkToggled: () {
              setState(() {
                EventData.toggleBookmark(event.id);
              });
            },
          ),
        );
      },
    );
  }
}

// --- Sticky Header Delegate ---
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 165.0; // Increased to securely accommodate all font-scales
  @override
  double get maxExtent => 165.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => true;
}

// --- Supporting Widgets (Slider Items) ---

class DiscoverySlider extends StatelessWidget {
  final List<DiscoveryItem> items;

  const DiscoverySlider({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _DiscoveryCard(
          imagePath: item.imagePath,
          title: item.title,
          subtitle: item.subtitle,
        );
      },
    );
  }
}

class DiscoveryItem {
  final String imagePath;
  final String title;
  final String subtitle;

  const DiscoveryItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class _DiscoveryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _DiscoveryCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[300]),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Vertical Event Card ---
class EventCardWithDetails extends StatelessWidget {
  final Event event;
  final VoidCallback? onBookmarkToggled;

  const EventCardWithDetails({super.key, required this.event, this.onBookmarkToggled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: event.id, // Unique tag for Hero animation
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  event.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.dateFormatted,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${event.attendees} going",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location.replaceAll('@', ''),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _BookmarkButton(
              isBookmarked: event.isBookmarked,
              onTap: () {
                if (onBookmarkToggled != null) onBookmarkToggled!();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      !event.isBookmarked ? "Event Saved" : "Event Removed",
                    ),
                    duration: const Duration(milliseconds: 600),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;

  const _BookmarkButton({required this.isBookmarked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: isBookmarked ? AppColors.primary : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
