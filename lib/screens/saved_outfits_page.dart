import 'package:flutter/material.dart';
import 'inspo_fullscreen_page.dart';

class SavedOutfitsPage extends StatelessWidget {
  const SavedOutfitsPage({super.key});

  static const List<String> inspoImages = [
    'assets/images/inspo1.jpg',
    'assets/images/inspo2.jpg',
    'assets/images/inspo3.jpg',
    'assets/images/inspo4.jpg',
    'assets/images/inspo5.jpg',
    'assets/images/inspo6.jpg',
    'assets/images/inspo7.jpg',
    'assets/images/inspo8.jpg',
    'assets/images/inspo9.jpg',
    'assets/images/inspo10.jpg',
    'assets/images/inspo11.jpg',
    'assets/images/inspo12.jpg',
    'assets/images/inspo13.jpg',
    'assets/images/inspo14.jpg',
    'assets/images/inspo15.jpg',
    'assets/images/inspo16.jpg',
    'assets/images/inspo17.jpg',
    'assets/images/inspo18.jpg',
    'assets/images/inspo19.jpg',
    'assets/images/inspo20.jpg',
    'assets/images/inspo21.jpg',
    'assets/images/inspo22.jpg',
    'assets/images/inspo23.jpg',
    'assets/images/inspo24.jpg',
    'assets/images/inspo25.jpg',
    'assets/images/inspo26.jpg',
    'assets/images/inspo27.jpg',
    'assets/images/inspo28.jpg',
    'assets/images/inspo29.jpg',
    'assets/images/inspo30.jpg',
    'assets/images/inspo31.jpg',
    'assets/images/inspo32.jpg',
    'assets/images/inspo33.jpg',
    'assets/images/inspo34.jpg',
    'assets/images/inspo35.jpg',
    'assets/images/inspo36.jpg',
    'assets/images/inspo37.jpg',
    'assets/images/inspo38.jpg',
    'assets/images/inspo39.jpg',
    'assets/images/inspo40.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 34),
                itemCount: inspoImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final imagePath = inspoImages[index];

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
                    child: Hero(
                      tag: imagePath,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffa67868).withOpacity(0.10),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        ),
                      ),
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

  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fikirler',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2b2026),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pinterest tarzı kombin ilhamları',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff7a6470),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xfff1ded4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '🎀 ${inspoImages.length}',
              style: const TextStyle(
                color: Color(0xffa67868),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
