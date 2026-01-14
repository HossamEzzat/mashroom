enum EventCategory { all, workshop, foraging, online, exhibition }

class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int attendees;
  final String imagePath;
  final EventCategory category;
  final String description;
  final bool isBookmarked;
  final double price;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.attendees,
    required this.imagePath,
    required this.category,
    this.description = '',
    this.isBookmarked = false,
    this.price = 0.0,
  });

  String get dateFormatted {
    // Basic formatting without intl package for now to keep dependencies light
    // In a real app, use DateFormat from intl package
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return "${weekDays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
