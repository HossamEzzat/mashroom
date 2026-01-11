import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../models/prediction_result.dart';
import '../repositories/disease_repository.dart';
import '../widgets/prediction_result_card.dart';
import 'mushroom_info_screen.dart';

class DiseasePredictionScreen extends StatefulWidget {
  const DiseasePredictionScreen({super.key});

  @override
  State<DiseasePredictionScreen> createState() =>
      _DiseasePredictionScreenState();
}

class _DiseasePredictionScreenState extends State<DiseasePredictionScreen> {
  File? _image;
  PredictionResult? _result;
  final ImagePicker _picker = ImagePicker();
  final DiseaseRepository _repository = DiseaseRepository();
  bool _isClassifying = false;

  Future<void> _onImageSourceSelected(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85, // Optimized for AI inference
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null;
      });
      Navigator.pop(context); // Close bottom sheet
      _classifyImage(); // Auto-start classification
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => _onImageSourceSelected(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => _onImageSourceSelected(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _classifyImage() async {
    if (_image == null) return;

    setState(() => _isClassifying = true);

    try {
      final result = await _repository.classifyImage(_image!);
      HapticFeedback.mediumImpact();

      setState(() {
        _result = result;
        _isClassifying = false;
      });
    } catch (e) {
      setState(() => _isClassifying = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('AI Classifier'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildImagePickerArea(),
            const SizedBox(height: 24),

            if (_isClassifying)
              const LoadingIndicator(message: "AI is analyzing the specimen...")
            else if (_result != null)
              PredictionResultCard(
                result: _result!,
                imagePath: _image!.path,
                onMoreInfo: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MushroomInfoScreen(
                      prediction: _result!.prediction,
                      imagePath: _image!.path,
                    ),
                  ),
                ),
              )
            else
              _buildInstructionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerArea() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _image == null
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (_image != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            if (_image != null)
              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _showImageSourceSheet,
                  ),
                ),
              ),
            if (_image == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Upload Mushroom Photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Camera or Gallery',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, color: AppColors.primary),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Tip: For best results, ensure the mushroom is well-lit and the gills or cap are clearly visible.",
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
