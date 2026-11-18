import 'package:flutter/material.dart';
import '../data/saved_outfits_store.dart';
import 'inspo_fullscreen_page.dart';

class FavoriteInspoPage extends StatelessWidget {
  const FavoriteInspoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = SavedOutfitsStore.favoriteInspoImages;

    return Scaffold(
      backgroundColor: const Color(0xfff3ebe6),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, images.length),
            Expanded(
              child: images.isEmpty
                  ? const Center(
                      child: Text(
                        'Henüz favori fikir yok 🤎',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2b2026),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 34),
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        final imagePath = images[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    InspoFullscreenPage(imagePath: imagePath),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(imagePath, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: const BoxDecoration(
        color: Color(0xfffffbf8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Favori fikirlerin',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff2b2026),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xffead8cf),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '🤎 $count',
              style: const TextStyle(
                color: Color(0xff8d5f52),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
