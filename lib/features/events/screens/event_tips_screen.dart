import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EventScreen extends StatefulWidget {
  final Function(int)? onTabChange; // Callback to change the tab in MainScreen

  const EventScreen(
      {super.key, this.onTabChange}); // Add onTabChange to the constructor

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Call the callback to switch to the Home tab (index 0)
            if (widget.onTabChange != null) {
              widget.onTabChange!(0); // Switch to Home tab
            }
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.notifications, color: Colors.red),
          ],
        ),
        bottom: TabBar(
          controller: _topTabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Awareness'),
            Tab(text: 'TIPS'),
            Tab(text: 'Workshops'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                child: TabBarView(
                  controller: _topTabController,
                  children: const [
                    CommunitySlider(),
                    TipsSlider(),
                    EventsSlider(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TabBar(
                controller: _bottomTabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'GOING'),
                  Tab(text: 'SAVED'),
                  Tab(text: 'PAST'),
                ],
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _bottomTabController,
                  children: [
                    ListView(
                      children: const [
                        EventCardWithDetails(
                          imagePath: 'assets/mushroom_event1.jpg',
                          date: 'SAT, JUL 12 • 14:00',
                          title: 'Mushroom Foraging',
                          attendees: '86 going',
                          location: '@Green Forest',
                        ),
                        EventCardWithDetails(
                          imagePath: 'assets/mushroom_event2.jpg',
                          date: 'SUN, JUL 20 • 11:00',
                          title: 'Home Cultivation 101',
                          attendees: '112 going',
                          location: '@Community Garden',
                        ),
                        EventCardWithDetails(
                          imagePath: 'assets/mushroom_event3.jpg',
                          date: 'TU, AUG 6 • 1:00',
                          title: 'Mushroomy  201',
                          attendees: '112 going',
                          location: '@Club Garden',
                        ),
                      ],
                    ),
                    const Center(child: Text('No saved events')),
                    const Center(child: Text('No past events')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Community Slider Widget
class CommunitySlider extends StatelessWidget {
  const CommunitySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final communities = [
      {
        'imagePath': 'assets/mushroom_awareness_1.jpg',
        'title': 'Mushroom Awareness',
        'description': 'Learn how mushrooms help ecosystems.',
      },
      {
        'imagePath': 'assets/mushroom_types.jpg',
        'title': 'Types of Mushrooms',
        'description': 'Explore edible, medicinal, and toxic species.',
      },
      {
        'imagePath': 'assets/mushroom_safety.jpg',
        'title': 'Safe Foraging',
        'description': 'Identify safe vs poisonous mushrooms.',
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CommunityCard(
            imagePath: community['imagePath']!,
            title: community['title']!,
            description: community['description']!,
          ),
        );
      },
    );
  }
}

// Community Card Widget
class CommunityCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;

  const CommunityCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  CommunityCardState createState() => CommunityCardState();
}

class CommunityCardState extends State<CommunityCard> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator.push instead of pushNamed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(
              title: widget.title,
              description: widget.description,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFE6F4EA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                widget.imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.diversity_3,
                        size: 20,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                        },
                        child: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: _isLiked ? Colors.red : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Community Detail Screen
// Community Detail Screen
class CommunityDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const CommunityDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join our mushroom awareness event to explore how fungi can help reduce waste, support biodiversity, and contribute to sustainable living.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Joined mushroom awareness event successfully!'),
                      backgroundColor: Color(0xffd993e4),
                    ),
                  );
                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffd993e4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Join Community',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TIPS Slider Widget
class TipsSlider extends StatelessWidget {
  const TipsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'imagePath': 'assets/mushroom_tip_1.jpg',
        'title': 'Compost with Mushrooms',
        'tip': 'Use fungi to enhance soil health.',
      },
      {
        'imagePath': 'assets/mushroom_tip_2.jpg',
        'title': 'Grow at Home',
        'tip': 'Sustainably grow mushrooms in small spaces.',
      },
      {
        'imagePath': 'assets/mushroom_tip_3.jpg',
        'title': 'Plastic-Eating Fungi',
        'tip': 'Discover mushrooms that break down plastic waste.',
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TipCard(
            imagePath: tip['imagePath']!,
            title: tip['title']!,
            tip: tip['tip']!,
          ),
        );
      },
    );
  }
}

// Tip Card Widget
class TipCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String tip;

  const TipCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.tip,
  });

  @override
  TipCardState createState() => TipCardState();
}

class TipCardState extends State<TipCard> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator.push instead of pushNamed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TipDetailScreen(
              title: widget.title,
              tip: widget.tip,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                widget.imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.tip,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.eco,
                        size: 20,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSaved = !_isSaved;
                          });
                        },
                        child: Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: 20,
                          color:
                              _isSaved ? const Color(0xffd993e4) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tip Detail Screen
// Tip Detail Screen
class TipDetailScreen extends StatelessWidget {
  final String title;
  final String tip;
  final String imagePath;

  const TipDetailScreen({
    super.key,
    required this.title,
    required this.tip,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tip,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'More Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Implementing this tip can significantly reduce your environmental impact. Here are some additional steps you can take to make a difference.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tip shared successfully!'),
                      backgroundColor: Color(0xffd993e4),
                    ),
                  );
                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffd993e4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Share Tip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Events Slider Widget
class EventsSlider extends StatelessWidget {
  const EventsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'imagePath': 'assets/mushroom_workshop_1.jpg',
        'date': 'SAT, JUL 12 • 14:00',
        'title': 'Mushroom Foraging Walk',
      },
      {
        'imagePath': 'assets/mushroom_workshop_2.jpg',
        'date': 'SUN, JUL 20 • 11:00',
        'title': 'Grow Mushrooms at Home',
      },
      {
        'imagePath': 'assets/mushroom_workshop_3.jpg',
        'date': 'FRI, JUL 25 • 16:00',
        'title': 'Cooking with Mushrooms',
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: EventCard(
            imagePath: event['imagePath']!,
            date: event['date']!,
            title: event['title']!,
          ),
        );
      },
    );
  }
}

// Event Card Widget
class EventCard extends StatefulWidget {
  final String imagePath;
  final String date;
  final String title;

  const EventCard({
    super.key,
    required this.imagePath,
    required this.date,
    required this.title,
  });

  @override
  EventCardState createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  bool _isStarred = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator.push instead of pushNamed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              title: widget.title,
              date: widget.date,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xfff8d7ff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                widget.imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isStarred = !_isStarred;
                          });
                        },
                        child: Icon(
                          _isStarred ? Icons.star : Icons.star_border,
                          size: 20,
                          color: _isStarred
                              ? const Color(0xffd993e4)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EventCardWithDetails widget
class EventCardWithDetails extends StatefulWidget {
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
  EventCardWithDetailsState createState() => EventCardWithDetailsState();
}

class EventCardWithDetailsState extends State<EventCardWithDetails> {
  bool _isStarred = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator.push instead of pushNamed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              title: widget.title,
              date: widget.date,
              imagePath: widget.imagePath,
              attendees: widget.attendees,
              location: widget.location,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.attendees,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.location,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isStarred = !_isStarred;
                });
              },
              child: Icon(
                _isStarred ? Icons.star : Icons.star_border,
                color: _isStarred ? const Color(0xffd993e4) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Event Detail Screen
// Event Detail Screen
class EventDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String imagePath;
  final String? attendees;
  final String? location;

  const EventDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.imagePath,
    this.attendees,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              if (attendees != null && location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      attendees!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      location!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join us for an impactful event aimed at making a difference in our environment. Bring your friends and family to participate in this meaningful activity.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Joined event successfully!'),
                      backgroundColor: Color(0xffd993e4),
                    ),
                  );
                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffd993e4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Join Event',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // AddEventScreen Widget

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Simulate saving the event (you can add logic to save to a list or database)
      final String title = _titleController.text;
      final String date = _dateController.text;
      final String location = _locationController.text;
      final String description = _descriptionController.text;

      // For now, just print the event details
      debugPrint('Event Saved: $title, $date, $location, $description');

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workshop saved! Let’s grow sustainability 🍄'),
          backgroundColor: Color(0xffd993e4),
        ),
      );

      // Navigate back to EventScreen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Mushroom Workshop',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                const Text(
                  'Event Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter event title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Event Date
                const Text(
                  'Event Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Enter event date (e.g., SAT, OCT 8 • 13:00)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Event Location
                const Text(
                  'Event Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter event location (e.g., @Hurghadah)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Event Description
                const Text(
                  'Event Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter event description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd993e4),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Save Event',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
