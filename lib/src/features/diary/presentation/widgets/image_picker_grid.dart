import 'package:flutter/material.dart';

class ImagePickerGrid extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const ImagePickerGrid({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length + (images.length < 3 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == images.length) {
          return GestureDetector(
            onTap: onAdd,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Icon(Icons.add_a_photo, size: 30),
              ),
            ),
          );
        }

        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(images[index]), // Mock URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
