import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../data/saved_outfits_store.dart';
import 'favorite_outfits_page.dart';
import 'saved_outfits_page.dart';
import 'favorite_inspo_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    await SavedOutfitsStore.loadOutfits();
    if (mounted) setState(() {});
  }

  Map<String, String>? get lastOutfit {
    if (SavedOutfitsStore.savedOutfits.isEmpty) return null;
    return SavedOutfitsStore.savedOutfits.first;
  }

  List<MapEntry<String, String>> _itemsOf(Map<String, String> outfit) {
    return outfit.entries.where((entry) {
      if (entry.value.isEmpty) return false;
      if (entry.key == 'Stil') return false;
      if (entry.key == 'KombinAdi') return false;
      if (entry.key == 'KombinAdı') return false;
      if (entry.key == 'Favori') return false;
      if (entry.key == 'CreatedAt') return false;
      if (entry.key.startsWith('PosX_')) return false;
      if (entry.key.startsWith('PosY_')) return false;
      if (entry.key.startsWith('Size_')) return false;

      final product = ProductCatalog.findProduct(entry.key, entry.value);
      return (product['image'] ?? '').isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = SavedOutfitsStore.savedOutfits.length;
    final favoriteCount = SavedOutfitsStore.favoriteOutfits.length;
    final favoriteIdeaCount = SavedOutfitsStore.favoriteInspoImages.length;

    return Scaffold(
      backgroundColor: const Color(0xfff3ebe6),
      body: Stack(
        children: [
          _softBlobs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                _topBar(context),
                const SizedBox(height: 12),
                _profileCard(totalCount, favoriteCount, favoriteIdeaCount),
                const SizedBox(height: 10),
                _settingCard(
                  context,
                  Icons.favorite,
                  'Favori kombinler',
                  'Kalple işaretlediğin kombinler',
                  const FavoriteOutfitsPage(),
                  preview: true,
                ),
                _settingCard(
                  context,
                  Icons.auto_awesome,
                  'Favori fikirler',
                  '${SavedOutfitsStore.favoriteInspoImages.length} fikir kaydedildi',
                  FavoriteInspoPage(),
                  inspoPreview: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softBlobs() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 70,
              left: -80,
              child: _blob(
                size: 210,
                color: const Color(0xffd7b3a6).withOpacity(0.30),
              ),
            ),
            Positioned(
              top: 360,
              right: -95,
              child: _blob(
                size: 245,
                color: const Color(0xff8d5f52).withOpacity(0.12),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -70,
              child: _blob(
                size: 190,
                color: const Color(0xffead8cf).withOpacity(0.62),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 78, spreadRadius: 36)],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xfffffbf8).withOpacity(0.94),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 24),
          ),
          const SizedBox(width: 16),
          const Text(
            'Profil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard(
    int totalCount,
    int favoriteCount,
    int favoriteIdeaCount,
  ) {
    return _glassCard(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        children: [
          _avatar(),
          const SizedBox(height: 8),
          const Text(
            '🤎 🤍 LİVZA 🤎 🤍',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'soft style • pinterest mood',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff7a6470),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _miniStat('🧩', '$totalCount', 'Kombin'),
              _miniStat('🤎', '$favoriteCount', 'Favori'),
              _miniStat('✨', '$favoriteIdeaCount', 'Fikir'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xff8d5f52), Color(0xffd7b3a6)],
        ),
      ),
      child: const CircleAvatar(
        radius: 36,
        backgroundColor: Color(0xfff6eee9),
        child: Icon(Icons.person, size: 42, color: Color(0xff8d5f52)),
      ),
    );
  }

  Widget _miniStat(String emoji, String value, String title) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.52),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff8d5f52),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Color(0xff7a6470), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _lastOutfitPreview(Map<String, String>? outfit) {
    if (outfit == null) return const SizedBox();

    final items = _itemsOf(outfit).take(4).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.42),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.58)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xff8d5f52), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Son oluşturulan kombin',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff8d5f52),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _miniImageList(items),
        ],
      ),
    );
  }

  Widget _favoriteOutfitsPreview() {
    final favorites = SavedOutfitsStore.favoriteOutfits;
    if (favorites.isEmpty) return const SizedBox();

    final previewOutfits = favorites.take(5).toList();

    return _glassCard(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(18),
      radius: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xff8d5f52), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Favori kombinlerin',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff2b2026),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffead8cf).withOpacity(0.70),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '🤎 ${favorites.length}',
                  style: const TextStyle(
                    color: Color(0xff8d5f52),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: previewOutfits.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final outfit = previewOutfits[index];
                final items = _itemsOf(outfit).take(4).toList();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteOutfitsPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 108,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xfffffbf8).withOpacity(0.72),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.65)),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];
                        final product = ProductCatalog.findProduct(
                          item.key,
                          item.value,
                        );
                        final imagePath = product['image'] ?? '';

                        return Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              color: Color(0xff8d5f52),
                              size: 18,
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniImageList(List<MapEntry<String, String>> items) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          final product = ProductCatalog.findProduct(item.key, item.value);
          final imagePath = product['image'] ?? '';

          return Container(
            width: 82,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xfffffbf8).withOpacity(0.72),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.65)),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Color(0xff8d5f52),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _settingCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page, {
    bool preview = false,
    bool inspoPreview = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: _cardContent(
        icon,
        title,
        subtitle,
        showArrow: true,
        preview: preview,
        inspoPreview: inspoPreview,
      ),
    );
  }

  Widget _cardContent(
    IconData icon,
    String title,
    String subtitle, {
    required bool showArrow,
    bool preview = false,
    bool inspoPreview = false,
  }) {
    return _glassCard(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      radius: 24,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: const Color(0xff8d5f52)),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff2b2026),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff7a6470),
                      ),
                    ),
                  ],
                ),
              ),

              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Color(0xff2b2026),
                ),
            ],
          ),

          // FAVORİ KOMBİNLER
          if (preview) ...[
            const SizedBox(height: 10),

            SizedBox(
              height: 112,

              child: ListView.separated(
                scrollDirection: Axis.horizontal,

                itemCount: SavedOutfitsStore.favoriteOutfits.length,

                separatorBuilder: (_, __) => const SizedBox(width: 10),

                itemBuilder: (context, index) {
                  final outfit = SavedOutfitsStore.favoriteOutfits[index];

                  final items = _itemsOf(outfit).take(4).toList();

                  return Container(
                    width: 100,
                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      color: const Color(0xfffffbf8).withOpacity(0.72),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(color: Colors.white.withOpacity(0.65)),
                    ),

                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: items.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                          ),

                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];

                        final product = ProductCatalog.findProduct(
                          item.key,
                          item.value,
                        );

                        return Image.asset(
                          product['image'] ?? '',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],

          // FAVORİ FİKİRLER
          if (inspoPreview) ...[
            const SizedBox(height: 10),

            _favoriteInspoPreview(),
          ],
        ],
      ),
    );
  }

  Widget _favoriteInspoPreview() {
    final images = SavedOutfitsStore.favoriteInspoImages;

    if (images.isEmpty) {
      return const Text(
        'Henüz favori fikir yok',
        style: TextStyle(color: Color(0xff7a6470), fontWeight: FontWeight.w600),
      );
    }

    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final imagePath = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath, width: 130, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
    required EdgeInsets margin,
    required EdgeInsets padding,
    double radius = 28,
  }) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.76),
                  const Color(0xfff6eee9).withOpacity(0.62),
                ],
              ),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
