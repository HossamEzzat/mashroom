import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
      body: CustomScrollView(
        slivers: [
          // 1. Top Discovery Section (Awareness, TIPS, Workshops)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Discovery"),
                  const SizedBox(height: 12),
                  _buildTopTabBar(),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 230,
                    child: TabBarView(
                      controller: _topTabController,
                      children: const [
                        CommunitySlider(),
                        TipsSlider(),
                        EventsSlider(),
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

          // 3. Vertical List of Events
          SliverFillRemaining(
            child: TabBarView(
              controller: _bottomTabController,
              children: [
                _buildEventList([
                  const EventCardWithDetails(
                    imagePath: 'assets/mushroom_event1.jpg',
                    date: 'SAT, JUL 12 • 14:00',
                    title: 'Mushroom Foraging',
                    attendees: '86 going',
                    location: '@Green Forest',
                  ),
                  const EventCardWithDetails(
                    imagePath: 'assets/mushroom_event2.jpg',
                    date: 'SUN, JUL 20 • 11:00',
                    title: 'Home Cultivation 101',
                    attendees: '112 going',
                    location: '@Community Garden',
                  ),
                ]),
                const Center(child: Text('No saved events yet')),
                const Center(child: Text('No past events')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
    );
  }

  // --- UI Helper Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => widget.onTabChange?.call(0),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search workshops...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
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
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TabBar(
            controller: _bottomTabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
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

  Widget _buildEventList(List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: children,
    );
  }
}

// --- Sticky Header Delegate ---
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 90.0;
  @override
  double get maxExtent => 90.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}

// --- Supporting Widgets (Slider Items) ---

class CommunitySlider extends StatelessWidget {
  const CommunitySlider({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) => const _SquareCard(
        color: Color(0xFFE6F4EA),
        title: "Ecosystems",
        icon: Icons.diversity_3,
      ),
    );
  }
}

class TipsSlider extends StatelessWidget {
  const TipsSlider({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) => const _SquareCard(
        color: Color(0xFFFFF9E6),
        title: "Soil Health",
        icon: Icons.eco,
      ),
    );
  }
}

class EventsSlider extends StatelessWidget {
  const EventsSlider({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) => const _SquareCard(
        color: Color(0xfff8d7ff),
        title: "Workshops",
        icon: Icons.calendar_month,
      ),
    );
  }
}

class _SquareCard extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;

  const _SquareCard({
    required this.color,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- Vertical Event Card ---
class EventCardWithDetails extends StatelessWidget {
  final String imagePath;
  final String date;
  final String title;
  final String attendees;
  final String location;

  const EventCardWithDetails({
    super.key,
    required this.imagePath,
    required this.date,
    required this.title,
    required this.attendees,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
            ), // Replace with Image.asset
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$attendees • $location",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.star_border, color: Colors.grey),
        ],
      ),
    );
  }
}

// Placeholder for AddEventScreen
class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Host Event")));
}
