import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/saved_outfits_store.dart';
import 'inspo_fullscreen_page.dart';

class FikirlerPage extends StatefulWidget {
  const FikirlerPage({super.key});

  @override
  State<FikirlerPage> createState() => _FikirlerPageState();
}

class _FikirlerPageState extends State<FikirlerPage> {
  static final List<String> images = List.generate(
    40,
    (index) => 'assets/images/inspo${index + 1}.jpg',
  );

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await SavedOutfitsStore.loadOutfits();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),

      appBar: AppBar(
        backgroundColor: const Color(0xfffffbf8),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff2b2026)),
        ),

        centerTitle: false,
        title: const Text(
          'Fikirler',
          style: TextStyle(
            color: Color(0xff2b2026),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xffead8cf),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                '🎀 ${images.length}',
                style: const TextStyle(
                  color: Color(0xff8d5f52),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: MasonryGridView.count(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imagePath = images[index];
            final isFavorite = SavedOutfitsStore.favoriteInspoImages.contains(
              imagePath,
            );

            final height = index % 4 == 0
                ? 300.0
                : index % 3 == 0
                ? 250.0
                : 220.0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InspoFullscreenPage(imagePath: imagePath),
                  ),
                );
              },
              child: SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Hero(
                      tag: imagePath,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          await SavedOutfitsStore.toggleFavoriteInspo(
                            imagePath,
                          );
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.82),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xff8d5f52),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
