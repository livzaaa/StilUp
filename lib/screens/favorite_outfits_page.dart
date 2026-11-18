import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../data/saved_outfits_store.dart';
import 'outfit_result_page.dart';

class FavoriteOutfitsPage extends StatefulWidget {
  const FavoriteOutfitsPage({super.key});

  @override
  State<FavoriteOutfitsPage> createState() => _FavoriteOutfitsPageState();
}

class _FavoriteOutfitsPageState extends State<FavoriteOutfitsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await SavedOutfitsStore.loadOutfits();

    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, String>> get favorites {
    return SavedOutfitsStore.favoriteOutfits;
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
    final favs = favorites;

    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: favs.isEmpty
                  ? _emptyState()
                  : ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        scrollbars: false,
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 34),
                        itemCount: favs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          return _favoriteCard(favs[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCard(Map<String, String> outfit) {
    final items = _itemsOf(outfit);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OutfitResultPage(selectedPieces: outfit),
          ),
        ).then((_) => _load());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffffffff), Color(0xfffff7fa)],
          ),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffa67868).withOpacity(0.11),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.90),
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    outfit['KombinAdi'] ?? 'Favori kombin',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2b2026),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xfff1ded4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xffa67868),
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: _productGrid(items)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: _brandTags(items)),
          ],
        ),
      ),
    );
  }

  Widget _productGrid(List<MapEntry<String, String>> items) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length > 4 ? 4 : items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, itemIndex) {
        final item = items[itemIndex];
        final product = ProductCatalog.findProduct(item.key, item.value);

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xfffff4f7), Color(0xffffe6ee)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffa67868).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            product['image'] ?? '',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                color: Color(0xffa67868),
                size: 38,
              );
            },
          ),
        );
      },
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xfff1ded4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.8)),
        ),
        child: Text(
          brand,
          style: const TextStyle(
            color: Color(0xffa67868),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );
    }).toList();
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffa67868).withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, color: Color(0xffa67868), size: 56),
            SizedBox(height: 14),
            Text(
              'Henüz favori kombin yok 💗',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff2b2026),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ana sayfadaki kalp ikonuna basarak kombinlerini favorilere ekleyebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff7a6470),
                height: 1.3,
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
                  'Favoriler',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2b2026),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Kalple işaretlediğin kombinler',
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
              '💗 ${favorites.length}',
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
