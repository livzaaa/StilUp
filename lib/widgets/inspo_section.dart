import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../screens/inspo_fullscreen_page.dart';
import '../data/saved_outfits_store.dart';

class InspoSection extends StatefulWidget {
  const InspoSection({
    super.key,
    required this.selectedSeason,
    required this.selectedStyle,
  });

  final String selectedSeason;
  final String selectedStyle;

  @override
  State<InspoSection> createState() => _InspoSectionState();
}

class _InspoSectionState extends State<InspoSection> {
  static const List<String> allInspoLooks = [
    'assets/images/inspo1.jpg',
    'assets/images/inspo2.jpg',
    'assets/images/inspo3.jpg',
    'assets/images/inspo4.jpg',
    'assets/images/inspo5.jpg',
    'assets/images/inspo6.jpg',
    'assets/images/inspo7.jpg',
    'assets/images/inspo8.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: allInspoLooks.length,
          itemBuilder: (context, index) {
            final imagePath = allInspoLooks[index];
            final isFavorite = SavedOutfitsStore.favoriteInspoImages.contains(
              imagePath,
            );

            final cardHeight = index % 3 == 0 ? 270.0 : 210.0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InspoFullscreenPage(imagePath: imagePath),
                  ),
                );
              },
              child: SizedBox(
                height: cardHeight,
                child: Stack(
                  children: [
                    Hero(
                      tag: imagePath,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                            color: Colors.white.withOpacity(0.92),
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
      ],
    );
  }
}
