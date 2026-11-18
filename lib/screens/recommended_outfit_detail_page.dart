import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendedOutfitDetailPage extends StatelessWidget {
  const RecommendedOutfitDetailPage({super.key, required this.outfit});

  final Map<String, dynamic> outfit;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final products = outfit['products'] as List<dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      outfit['image'],
                      height: 430,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ürünler',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2b2026),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...products.map((product) {
                    return _productCard(product);
                  }),
                ],
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
          Expanded(
            child: Text(
              outfit['title'],
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff2b2026),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(dynamic product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Image.asset(
            product['image'],
            width: 82,
            height: 82,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2b2026),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['brand'],
                  style: const TextStyle(
                    color: Color(0xffa67868),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openUrl(product['url']),
            icon: const Icon(Icons.open_in_new, color: Color(0xffa67868)),
          ),
        ],
      ),
    );
  }
}
