import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/loading_indicator.dart';
import '../../../models/disease_info.dart';

class MushroomInfoScreen extends StatefulWidget {
  final String prediction;
  final String imagePath;

  const MushroomInfoScreen({
    required this.prediction,
    required this.imagePath,
    super.key,
  });

  @override
  MushroomInfoScreenState createState() => MushroomInfoScreenState();
}

class MushroomInfoScreenState extends State<MushroomInfoScreen> {
  bool isLoading = true;
  late MushroomData mushroomData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate slight delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 400));
    mushroomData = MushroomInfo.getMushroomData(
      widget.prediction.trim().toLowerCase(),
    );
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: "Fetching detailed specs..."),
      );
    }

    final bool isSafe =
        mushroomData.healthStatus.toLowerCase().contains("safe") ||
        mushroomData.healthStatus.toLowerCase().contains("edible");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isSafe),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(isSafe),
                  const SizedBox(height: 32),
                  _buildExpandableInfoCard(
                    title: "Botanical Overview",
                    content: mushroomData.overview,
                    icon: Icons.auto_stories_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildVerificationNotice(),
                  const SizedBox(height: 16),
                  _buildListSection(
                    "Recommended Recipes",
                    mushroomData.recommendedRecipes,
                    Icons.restaurant,
                  ),
                  const SizedBox(height: 16),
                  _buildListSection(
                    "Alternative Suggestions",
                    mushroomData.alternativeSuggestions,
                    Icons.swap_calls,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Share.share("Check out this ${mushroomData.mushroomName} I found!"),
        backgroundColor: const Color(0xffb65ec4),
        icon: const Icon(Icons.share, color: Colors.white),
        label: const Text(
          "Share Report",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSafe) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: isSafe ? Colors.green[700] : Colors.red[700],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(widget.imagePath), fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSafe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                mushroomData.mushroomName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            _buildSafetyIcon(isSafe),
          ],
        ),
        const SizedBox(height: 12),
        _buildRiskScoreMeter(isSafe),
      ],
    );
  }

  Widget _buildSafetyIcon(bool isSafe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSafe
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSafe ? Icons.verified_user : Icons.gpp_maybe,
        color: isSafe ? Colors.green : Colors.red,
        size: 32,
      ),
    );
  }

  Widget _buildRiskScoreMeter(bool isSafe) {
    final double score = isSafe ? 0.15 : 0.85;
    final Color color = isSafe ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Safety Level",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              isSafe ? "High Confidence" : "Extreme Risk",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: score,
            minHeight: 10,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.biotech, color: Colors.amber),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Always verify AI results with physical traits like gill attachment and spore print.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xffb65ec4), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[800],
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Chip(
                  avatar: Icon(icon, size: 16, color: const Color(0xffb65ec4)),
                  label: Text(item),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
