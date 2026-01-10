import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMushroomInformation(widget.prediction);
    });
  }

  String normalizePrediction(String prediction) {
    return prediction.trim().toLowerCase();
  }

  void fetchMushroomInformation(String prediction) {
    mushroomData =
        MushroomInfo.getMushroomData(normalizePrediction(prediction));
    setState(() {
      isLoading = false;
    });
  }

  void _showBottomSheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(content);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mushroom Information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffb65ec4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Column(children: [
                          Text(
                            mushroomData.mushroomName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff8a3d98),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildSafetyBadge(mushroomData.healthStatus),
                          const SizedBox(height: 10),
                          _buildRiskScoreBadge(mushroomData.healthStatus),
                        ])),
                        const SizedBox(height: 20),
                        _buildTile(
                          title: "Overview",
                          content: mushroomData.overview,
                          icon: Icons.info_outline,
                        ),
                        _buildTile(
                          title: "Health Status",
                          content: mushroomData.healthStatus,
                          icon: Icons.health_and_safety_outlined,
                        ),
                        _buildTile(
                          title: "Recommended Recipes",
                          content: mushroomData.recommendedRecipes.join("\n"),
                          icon: Icons.restaurant_menu,
                        ),
                        _buildTile(
                          title: "Alternative Suggestions",
                          content:
                              mushroomData.alternativeSuggestions.join("\n"),
                          icon: Icons.sync_alt,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRiskScoreBadge(String healthStatus) {
    int riskScore = 50;
    IconData icon = Icons.error_outline;
    String label = "Moderate Risk";

    final lower = healthStatus.toLowerCase();

    if (lower.contains("safe") || lower.contains("edible")) {
      riskScore = 10;
      icon = Icons.check_circle;
      label = "Safe to Eat";
    } else if (lower.contains("toxic") || lower.contains("poisonous")) {
      riskScore = 90;
      icon = Icons.warning_amber_rounded;
      label = "Highly Toxic";
    } else if (lower.contains("caution") || lower.contains("risk")) {
      riskScore = 60;
      icon = Icons.error_outline;
      label = "Use with Caution";
    }

    Color badgeColor;
    if (riskScore <= 30) {
      badgeColor = Colors.green;
    } else if (riskScore <= 70) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Risk Score: $riskScore",
              style: TextStyle(
                color: badgeColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xffb65ec4)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showBottomSheet(title, content),
    );
  }

  Widget _buildImageSection() {
    final file = File(widget.imagePath);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: file.existsSync()
          ? Image.file(
              file,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
            )
          : _buildErrorImage(),
    );
  }

  Widget _buildSafetyBadge(String healthStatus) {
    bool isSafe = healthStatus.toLowerCase().contains("safe") ||
        healthStatus.toLowerCase().contains("edible");
    Color badgeColor = isSafe ? Colors.green : Colors.red;
    IconData badgeIcon = isSafe ? Icons.check_circle : Icons.warning;
    String label = isSafe ? "✅ Safe to Eat" : "⚠️ Potentially Toxic";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: double.infinity,
      height: 210,
      color: Colors.grey[300],
      child: const Center(
        child: Text(
          'Image not available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
