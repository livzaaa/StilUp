import 'package:flutter/material.dart';
import '../data/saved_outfits_store.dart';

class InspoFullscreenPage extends StatefulWidget {
  const InspoFullscreenPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<InspoFullscreenPage> createState() => _InspoFullscreenPageState();
}

class _InspoFullscreenPageState extends State<InspoFullscreenPage> {
  static final List<String> images = List.generate(
    40,
    (index) => 'assets/images/inspo${index + 1}.jpg',
  );

  late final PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    final foundIndex = images.indexOf(widget.imagePath);
    currentIndex = foundIndex >= 0 ? foundIndex : 0;

    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = images[currentIndex];
    final isFavorite = SavedOutfitsStore.isFavoriteInspo(currentImage);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imagePath = images[index];

              return Center(
                child: Hero(
                  tag: imagePath,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 64,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentIndex + 1}/${images.length}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await SavedOutfitsStore.toggleFavoriteInspo(
                            currentImage,
                          );

                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.88),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? const Color(0xff8d5f52)
                                : Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
