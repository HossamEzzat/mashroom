import 'package:flutter/material.dart';
import '../../../models/mushroom_difference.dart';
import '../../../models/plant_model.dart';

class LookalikeScreen extends StatefulWidget {
  const LookalikeScreen(
      {super.key, required void Function(int index) onTabChange});

  @override
  State<LookalikeScreen> createState() => _LookalikeScreenState();
}

class _LookalikeScreenState extends State<LookalikeScreen> {
  late Future<List<MushroomPair>> _data;

  @override
  void initState() {
    super.initState();
    _data = loadLookalikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚠️ Beware Lookalikes'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<MushroomPair>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(item.className,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: MushroomCard(
                                  title: 'Safe', mushroom: item.safe)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: MushroomCard(
                                  title: 'Lookalike',
                                  mushroom: item.lookalike)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Differences:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          ...item.differences.map((d) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 14)),
                                  Expanded(
                                      child: Text(d,
                                          style:
                                              const TextStyle(fontSize: 14))),
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MushroomCard extends StatelessWidget {
  final String title;
  final Mushroom mushroom;

  const MushroomCard({super.key, required this.title, required this.mushroom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(mushroom.image, height: 100, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(mushroom.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text(mushroom.description,
            style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }
}
