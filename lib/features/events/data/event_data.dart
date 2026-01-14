import '../models/event_model.dart';

class EventData {
  static final List<Event> _events = [
    Event(
      id: '1',
      title: 'Mushroom Foraging',
      date: DateTime.now().add(const Duration(days: 5, hours: 4)),
      location: '@Green Forest',
      attendees: 86,
      imagePath: 'assets/mushroom_event1.jpg',
      category: EventCategory.foraging,
      description:
          'Join our expert guides for a morning of mushroom hunting in the beautiful Green Forest. Learn to identify local edible species and avoid poisonous look-alikes.',
      price: 25.0,
    ),
    Event(
      id: '2',
      title: 'Home Cultivation 101',
      date: DateTime.now().add(const Duration(days: 12, hours: 2)),
      location: '@Community Garden',
      attendees: 112,
      imagePath: 'assets/mushroom_event2.jpg',
      category: EventCategory.workshop,
      description:
          'Learn the basics of growing gourmet mushrooms at home. We will cover substrate preparation, inoculation, and fruiting conditions.',
      price: 45.0,
    ),
    Event(
      id: '3',
      title: 'Medicinal Fungi Online',
      date: DateTime.now().add(const Duration(days: 2, hours: 8)),
      location: 'Online Zoom',
      attendees: 340,
      imagePath: 'assets/mushroom_workshop_2.jpg',
      category: EventCategory.online,
      description:
          'A deep dive into the health benefits of Reishi, Lion\'s Mane, and Turkey Tail. Guest speaker Dr. Funghi.',
      price: 0.0,
    ),
    Event(
      id: '4',
      title: 'Spore Print Art',
      date: DateTime.now().add(const Duration(days: 20)),
      location: '@City Art Center',
      attendees: 45,
      imagePath: 'assets/mushroom_tip_2.jpg',
      category: EventCategory.exhibition,
      description:
          'Create beautiful art using nothing but mushroom spores. All materials provided.',
      price: 15.0,
    ),
  ];

  static List<Event> get events => _events;

  static List<Event> get upcomingEvents => _events; // Placeholder for logic

  static List<Event> filterEvents({
    required EventCategory category,
    String searchQuery = '',
  }) {
    return _events.where((event) {
      final matchesCategory =
          category == EventCategory.all || event.category == category;
      final matchesSearch =
          event.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
