import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/product_data.dart';
import 'product_selection_page.dart';
import 'outfit_result_page.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({super.key, required this.selectedStyle});

  final String selectedStyle;

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  late String selectedStyle;

  final List<String> styles = [
    'günlük şıklık',
    'spor',
    'iş şıklığı',
    'akşam şıklığı',
  ];

  final Map<String, String> selectedPieces = {
    'Dış Giyim': '',
    'Üst': '',
    'Alt': '',
    'Elbise': '',
    'Çanta': '',
    'Ayakkabı': '',
    'Aksesuar': '',
    'Gözlük': '',
  };

  @override
  void initState() {
    super.initState();
    selectedStyle = widget.selectedStyle;
  }

  Future<void> _openProductPage(String category) async {
    final selectedProduct = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSelectionPage(
          category: category,
          products: ProductCatalog.products[category] ?? [],
        ),
      ),
    );

    if (selectedProduct != null) {
      setState(() {
        selectedPieces[category] = selectedProduct;
      });
    }
  }

  void _openResultPage() {
    final outfitWithStyle = Map<String, String>.from(selectedPieces);
    outfitWithStyle['Stil'] = selectedStyle;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutfitResultPage(selectedPieces: outfitWithStyle),
      ),
    );
  }

  int get selectedCount =>
      selectedPieces.values.where((item) => item.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ebe6),
      body: Stack(
        children: [
          _softBlobs(),
          SafeArea(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
                    children: [
                      const Text(
                        'Kombin yap',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2b2026),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Stilini seç, parçaları tamamla ve kendi kombinini oluştur.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff7a6470),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _styleSelector(),
                      const SizedBox(height: 24),
                      _grid(),
                      const SizedBox(height: 24),
                      _createButton(),
                    ],
                  ),
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
              top: 110,
              left: -80,
              child: _blob(
                size: 190,
                color: const Color(0xffd7b3a6).withOpacity(0.28),
              ),
            ),
            Positioned(
              top: 420,
              right: -100,
              child: _blob(
                size: 240,
                color: const Color(0xff8d5f52).withOpacity(0.12),
              ),
            ),
            Positioned(
              bottom: 150,
              left: -70,
              child: _blob(
                size: 180,
                color: const Color(0xffead8cf).withOpacity(0.52),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 75, spreadRadius: 35)],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xfffffbf8).withOpacity(0.92),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 32, color: Color(0xff8d5f52)),
          ),
          const SizedBox(width: 16),
          const Text(
            'Kombin yap',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff2b2026),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff8d5f52), Color(0xffd7b3a6)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              '🧩 $selectedCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _styleSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.76),
                const Color(0xfff6eee9).withOpacity(0.62),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff8d5f52).withOpacity(0.08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stil seçimi',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2b2026),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: styles.map((style) {
                  final isSelected = selectedStyle == style;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStyle = style;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xff8d5f52)
                            : Colors.white.withOpacity(0.52),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff8d5f52)
                              : Colors.white.withOpacity(0.65),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xff8d5f52,
                                  ).withOpacity(0.16),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        isSelected ? '✓ $style' : style,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff2b2026),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    final categories = selectedPieces.keys.toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final selectedName = selectedPieces[category] ?? '';
        final product = ProductCatalog.findProduct(category, selectedName);
        final imagePath = product['image'] ?? '';

        return GestureDetector(
          onTap: () => _openProductPage(category),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: selectedName.isEmpty
                        ? [
                            Colors.white.withOpacity(0.48),
                            const Color(0xffead8cf).withOpacity(0.42),
                          ]
                        : [
                            Colors.white.withOpacity(0.78),
                            const Color(0xfff6eee9).withOpacity(0.58),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: selectedName.isEmpty
                        ? Colors.white.withOpacity(0.52)
                        : const Color(0xff8d5f52).withOpacity(0.32),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff8d5f52).withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        selectedName.isEmpty
                            ? Icons.add_circle
                            : Icons.check_circle,
                        color: const Color(0xff8d5f52),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: selectedName.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _iconFor(category),
                                    color: const Color(0xff8d5f52),
                                    size: 42,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2b2026),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              _iconFor(category),
                                              color: const Color(0xff8d5f52),
                                              size: 42,
                                            );
                                          },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    selectedName,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2b2026),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selectedCount > 0
              ? const [Color(0xff8d5f52), Color(0xffd7b3a6)]
              : [
                  const Color(0xff8d5f52).withOpacity(0.28),
                  const Color(0xffd7b3a6).withOpacity(0.28),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: selectedCount > 0
            ? [
                BoxShadow(
                  color: const Color(0xff8d5f52).withOpacity(0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 9),
                ),
              ]
            : [],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: selectedCount > 0 ? _openResultPage : null,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'Kombini oluştur',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'Üst':
        return Icons.checkroom;
      case 'Alt':
        return Icons.dry_cleaning;
      case 'Dış Giyim':
        return Icons.layers;
      case 'Elbise':
        return Icons.checkroom;
      case 'Çanta':
        return Icons.shopping_bag;
      case 'Ayakkabı':
        return Icons.woman;
      case 'Aksesuar':
        return Icons.watch;
      case 'Gözlük':
        return Icons.sunny;
      default:
        return Icons.local_mall;
    }
  }
}
