import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../data/saved_outfits_store.dart';
import '../screens/outfit_result_page.dart';

class OutfitCard extends StatefulWidget {
  const OutfitCard({
    super.key,
    required this.selectedSeason,
    required this.selectedStyle,
    required this.onCreateTap,
  });

  final String selectedSeason;
  final String selectedStyle;
  final VoidCallback onCreateTap;

  @override
  State<OutfitCard> createState() => _OutfitCardState();
}

class _OutfitCardState extends State<OutfitCard> {
  int? pressedIndex;

  @override
  void initState() {
    super.initState();
    _loadSavedOutfits();
  }

  @override
  void didUpdateWidget(covariant OutfitCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedStyle != widget.selectedStyle) {
      _loadSavedOutfits();
    }
  }

  Future<void> _loadSavedOutfits() async {
    await SavedOutfitsStore.loadOutfits();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openOutfit(int index, Map<String, String> outfit) async {
    setState(() {
      pressedIndex = index;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    setState(() {
      pressedIndex = null;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) {
          return OutfitResultPage(selectedPieces: outfit);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(curved),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
                child: child,
              ),
            ),
          );
        },
      ),
    );

    await _loadSavedOutfits();
  }

  List<Map<String, String>> get filteredOutfits {
    return SavedOutfitsStore.savedOutfits.where((outfit) {
      final outfitStyle = outfit['Stil'];

      if (outfitStyle == null || outfitStyle.isEmpty) {
        return widget.selectedStyle == 'günlük şıklık';
      }

      return outfitStyle == widget.selectedStyle;
    }).toList();
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
      final imagePath = product['image'] ?? '';

      return imagePath.isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final outfits = filteredOutfits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _newOutfitButton(),
        const SizedBox(height: 18),
        const Text(
          'Kendi kombinlerin',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff2b2026),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.selectedStyle,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xff7a6470),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (outfits.isEmpty) _emptyCard() else _savedOutfitList(outfits),
      ],
    );
  }

  Widget _newOutfitButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff8d5f52), Color(0xffd7b3a6)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff8d5f52).withOpacity(0.24),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: widget.onCreateTap,
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: const Text(
            'Yeni kombin yap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xfffffbf8), Color(0xfff6eee9)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.favorite_border, color: Color(0xff8d5f52), size: 52),
          SizedBox(height: 14),
          Text(
            'Bu stile ait kendi kombinin yok',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Yeni kombin yap kısmından bu stile uygun kombin oluşturup kaydedebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff7a6470),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _savedOutfitList(List<Map<String, String>> outfits) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: outfits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        return _savedOutfitCard(index, outfit);
      },
    );
  }

  Widget _savedOutfitCard(int index, Map<String, String> outfit) {
    final items = _itemsOf(outfit);
    final isPressed = pressedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openOutfit(index, outfit),
      child: AnimatedScale(
        scale: isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutBack,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              height: 480,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.76),
                    const Color(0xfff6eee9).withOpacity(0.68),
                  ],
                ),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: Colors.white.withOpacity(0.70),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xff8d5f52,
                    ).withOpacity(isPressed ? 0.18 : 0.10),
                    blurRadius: isPressed ? 34 : 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardHeader(index, outfit),
                  const SizedBox(height: 12),
                  SizedBox(height: 320, child: _collagePreview(items)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: _brandTags(items),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardHeader(int index, Map<String, String> outfit) {
    return Row(
      children: [
        Expanded(
          child: Text(
            (outfit['KombinAdi'] != null &&
                    outfit['KombinAdi']!.trim().isNotEmpty)
                ? outfit['KombinAdi']!
                : 'Kombin ${index + 1}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                final realIndex = SavedOutfitsStore.savedOutfits.indexOf(
                  outfit,
                );

                await SavedOutfitsStore.toggleFavorite(realIndex);

                if (mounted) {
                  setState(() {});
                }
              },
              child: _smallActionButton(
                icon: outfit['Favori'] == 'true'
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final realIndex = SavedOutfitsStore.savedOutfits.indexOf(
                  outfit,
                );

                await SavedOutfitsStore.removeOutfit(realIndex);

                if (mounted) {
                  setState(() {});
                }
              },
              child: _smallActionButton(icon: Icons.delete_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallActionButton({required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.42),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Icon(icon, color: const Color(0xff8d5f52), size: 22),
    );
  }

  Widget _collagePreview(List<MapEntry<String, String>> items) {
    final previewItems = items.take(4).toList();

    if (previewItems.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.55)),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            color: Color(0xff8d5f52),
            size: 38,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: previewItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        return _floatingProduct(previewItems[index]);
      },
    );
  }

  Widget _floatingProduct(MapEntry<String, String> item) {
    final product = ProductCatalog.findProduct(item.key, item.value);
    final imagePath = product['image'] ?? '';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.48),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.58)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: imagePath.isEmpty
          ? const Icon(
              Icons.image_not_supported,
              color: Color(0xff8d5f52),
              size: 34,
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Color(0xff8d5f52),
                  size: 34,
                );
              },
            ),
    );
  }

  List<Widget> _brandTags(List<MapEntry<String, String>> items) {
    final brands = items
        .map(
          (item) =>
              ProductCatalog.findProduct(item.key, item.value)['brand'] ?? '',
        )
        .where((brand) => brand.isNotEmpty)
        .toSet()
        .toList();

    return brands.map((brand) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.42),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.55)),
        ),
        child: Text(
          brand,
          style: const TextStyle(
            color: Color(0xff8d5f52),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }).toList();
  }
}
