import 'package:flutter/material.dart';

class ProductSelectionPage extends StatelessWidget {
  const ProductSelectionPage({
    super.key,
    required this.category,
    required this.products,
  });

  final String category;
  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'Bu kategoriye ürün eklenmedi',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(18),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final imagePath = product['image'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, product['name']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffa67868).withOpacity(0.12),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.broken_image,
                                                  color: Colors.pink.shade200,
                                                  size: 42,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  imagePath,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xffa67868),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    0,
                                    12,
                                    12,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        product['name'] ?? '',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff2b2026),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
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
            child: const Icon(Icons.arrow_back_ios_new, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            category,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
        ],
      ),
    );
  }
}
