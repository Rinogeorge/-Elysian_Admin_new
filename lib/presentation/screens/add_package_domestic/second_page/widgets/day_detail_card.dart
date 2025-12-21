import 'dart:io';
import 'package:flutter/material.dart';

class DayDetailCard extends StatelessWidget {
  final int day;
  final List<String> existingImages;
  final List<String> newImages;
  final String? initialDescription;
  final VoidCallback onImageSelected;
  final ValueChanged<String> onDescriptionChanged;
  final Function(int) onNewImageRemove;
  final Function(String) onExistingImageRemove;
  final String? locationError;
  final String? imageError;

  const DayDetailCard({
    super.key,
    required this.day,
    this.existingImages = const [],
    this.newImages = const [],
    this.initialDescription,
    required this.onImageSelected,
    required this.onDescriptionChanged,
    required this.onNewImageRemove,
    required this.onExistingImageRemove,
    this.locationError,
    this.imageError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBBDEFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Day $day',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    key: ValueKey(day),
                    initialValue: initialDescription,
                    onChanged: onDescriptionChanged,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter location ',
                      errorText: locationError,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (existingImages.isNotEmpty || newImages.isNotEmpty)
            Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: existingImages.length + newImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isExisting = index < existingImages.length;
                  final imageSource =
                      isExisting
                          ? existingImages[index]
                          : newImages[index - existingImages.length];

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              isExisting
                                  ? Image.network(
                                    imageSource,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  )
                                  : Image.file(
                                    File(imageSource),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap:
                              () =>
                                  isExisting
                                      ? onExistingImageRemove(imageSource)
                                      : onNewImageRemove(
                                        index - existingImages.length,
                                      ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Center(
            child: OutlinedButton.icon(
              onPressed: onImageSelected,
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text('Add more images'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),

          if (imageError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  imageError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
