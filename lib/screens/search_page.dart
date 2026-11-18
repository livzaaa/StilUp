import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/product_data.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  List<Map<String, String>> get allProducts {
    final List<Map<String, String>> products = [];

    ProductCatalog.products.forEach((category, items) {
      for (final item in items) {
        products.add({...item, 'category': category});
      }
    });

    return products;
  }

  List<Map<String, String>> get filteredProducts {
    if (searchText.trim().isEmpty) {
      return allProducts;
    }

    final query = searchText.toLowerCase().trim();

    return allProducts.where((product) {
      final name = (product['name'] ?? '').toLowerCase();
      final brand = (product['brand'] ?? '').toLowerCase();
      final category = (product['category'] ?? '').toLowerCase();

      return name.contains(query) ||
          brand.contains(query) ||
          category.contains(query);
    }).toList();
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff8d5f52).withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Çanta, ayakkabı, Zara, siyah...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xffa67868),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final imagePath = product['image'] ?? '';

                  return GestureDetector(
                    onTap: () => _showProductInfo(product),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff8d5f52).withOpacity(0.10),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.80),
                            blurRadius: 8,
                            offset: const Offset(-3, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: imagePath.isEmpty
                                ? const Icon(
                                    Icons.image_not_supported,
                                    color: Color(0xffa67868),
                                    size: 50,
                                  )
                                : Image.asset(
                                    imagePath,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        color: Color(0xffa67868),
                                        size: 50,
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product['name'] ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2b2026),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product['brand'] ?? '',
                            style: const TextStyle(
                              color: Color(0xffa67868),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 28),
          ),
          const SizedBox(width: 16),
          const Text(
            'Ara',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showProductInfo(Map<String, String> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final imagePath = product['image'] ?? '';

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imagePath.isEmpty
                  ? const Icon(Icons.image_not_supported, size: 70)
                  : Image.asset(
                      imagePath,
                      height: 130,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 70);
                      },
                    ),
              const SizedBox(height: 14),
              Text(
                product['name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product['brand'] ?? '',
                style: const TextStyle(
                  color: Color(0xffa67868),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa67868),
                ),
                onPressed: () => _openUrl(product['url'] ?? ''),
                child: const Text(
                  'Web sitesine git',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
