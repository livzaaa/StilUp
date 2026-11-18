import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/product_data.dart';
import '../data/saved_outfits_store.dart';

class OutfitResultPage extends StatefulWidget {
  const OutfitResultPage({super.key, required this.selectedPieces});

  final Map<String, String> selectedPieces;

  @override
  State<OutfitResultPage> createState() => _OutfitResultPageState();
}

class _OutfitResultPageState extends State<OutfitResultPage> {
  bool isSaved = false;
  final TextEditingController nameController = TextEditingController();

  final Map<String, Offset> piecePositions = {};
  final Map<String, double> pieceSizes = {};

  String _pieceKey(MapEntry<String, String> item) {
    return '${item.key}_${item.value}';
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.selectedPieces['KombinAdi'] ?? '';
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await SavedOutfitsStore.loadOutfits();
    _loadSavedLayout();

    if (mounted) {
      setState(() {});
    }
  }

  void _loadSavedLayout() {
    for (final item in selectedItems) {
      final key = _pieceKey(item);

      final savedX = double.tryParse(widget.selectedPieces['PosX_$key'] ?? '');
      final savedY = double.tryParse(widget.selectedPieces['PosY_$key'] ?? '');
      final savedSize = double.tryParse(
        widget.selectedPieces['Size_$key'] ?? '',
      );

      if (savedX != null && savedY != null) {
        piecePositions[key] = Offset(savedX, savedY);
      }

      if (savedSize != null) {
        pieceSizes[key] = savedSize;
      }
    }
  }

  List<MapEntry<String, String>> get selectedItems {
    return widget.selectedPieces.entries.where((entry) {
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

  String get selectedStyle {
    return widget.selectedPieces['Stil'] ?? 'günlük şıklık';
  }

  Future<void> _saveOutfit() async {
    await SavedOutfitsStore.loadOutfits();

    final outfitToSave = Map<String, String>.from(widget.selectedPieces);
    final typedName = nameController.text.trim();

    outfitToSave['KombinAdi'] = typedName.isEmpty
        ? 'Kombin ${SavedOutfitsStore.savedOutfits.length + 1}'
        : typedName;

    outfitToSave['Stil'] = selectedStyle;
    outfitToSave['Favori'] = outfitToSave['Favori'] ?? 'false';

    for (final item in selectedItems) {
      final key = _pieceKey(item);
      final position = piecePositions[key];
      final size = pieceSizes[key];

      if (position != null) {
        outfitToSave['PosX_$key'] = position.dx.toString();
        outfitToSave['PosY_$key'] = position.dy.toString();
      }

      if (size != null) {
        outfitToSave['Size_$key'] = size.toString();
      }
    }

    final existingIndex = SavedOutfitsStore.savedOutfits.indexWhere((outfit) {
      final createdAt = widget.selectedPieces['CreatedAt'];

      if (createdAt != null && createdAt.isNotEmpty) {
        return outfit['CreatedAt'] == createdAt;
      }

      return identical(outfit, widget.selectedPieces);
    });

    if (existingIndex >= 0) {
      final oldCreatedAt =
          SavedOutfitsStore.savedOutfits[existingIndex]['CreatedAt'];
      final oldFavorite =
          SavedOutfitsStore.savedOutfits[existingIndex]['Favori'];

      if (oldCreatedAt != null && oldCreatedAt.isNotEmpty) {
        outfitToSave['CreatedAt'] = oldCreatedAt;
      }

      if (oldFavorite != null && oldFavorite.isNotEmpty) {
        outfitToSave['Favori'] = oldFavorite;
      }

      await SavedOutfitsStore.updateOutfit(existingIndex, outfitToSave);
    } else if (!isSaved) {
      await SavedOutfitsStore.addOutfit(outfitToSave);
    }

    await SavedOutfitsStore.loadOutfits();

    if (mounted) {
      setState(() {
        isSaved = true;
      });
    }

    if (!mounted) return;

    _showSavedSuccessDialog();
  }

  void _showSavedSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Kapat',
      barrierColor: Colors.black.withOpacity(0.18),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 285,
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xfffffbf8), Color(0xfff6eee9)],
                ),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: Colors.white.withOpacity(0.75),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff8d5f52).withOpacity(0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff8d5f52), Color(0xffd7b3a6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff8d5f52).withOpacity(0.24),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Kombin kaydedildi 🤎',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2b2026),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.2,
                          color: const Color(0xffd7b3a6),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '🤍',
                          style: TextStyle(
                            color: Color(0xffd7b3a6),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.2,
                          color: const Color(0xffd7b3a6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8d5f52),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tamam',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.84,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  void _resetLayout() {
    setState(() {
      piecePositions.clear();
      pieceSizes.clear();
    });
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = selectedItems;

    return Scaffold(
      backgroundColor: const Color(0xffead8cf),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
                children: [
                  _nameField(),
                  const SizedBox(height: 14),
                  _styleBadge(),
                  const SizedBox(height: 14),
                  _outfitPreview(items),
                  const SizedBox(height: 22),
                  _brandTags(items),
                  const SizedBox(height: 22),
                  _bottomButtons(),
                ],
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
          const Text(
            'Kombin editörü',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text('🧩 ${selectedItems.length}'),
        ],
      ),
    );
  }

  Widget _nameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: 'Kombine isim ver...',
        prefixIcon: const Icon(Icons.edit, color: Color(0xff8d5f52)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _styleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xff8d5f52), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xff8d5f52), size: 20),
          const SizedBox(width: 8),
          Text(
            selectedStyle,
            style: const TextStyle(
              color: Color(0xff8d5f52),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _resetLayout,
            child: const Text(
              'Sıfırla',
              style: TextStyle(
                color: Color(0xff8d5f52),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hintCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfffffbf8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Row(
        children: [
          Icon(Icons.touch_app, color: Color(0xff8d5f52)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Parçaları sürükle. Sağ alt pembe ikonla büyüt/küçült. Ürüne dokununca detay açılır.',
              style: TextStyle(
                color: Color(0xff7a6470),
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outfitPreview(List<MapEntry<String, String>> items) {
    return Container(
      height: 590,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffffffff), Color(0xfff6eee9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            for (int i = 0; i < items.length; i++) _piece(items[i], i),
          ],
        ),
      ),
    );
  }

  Widget _piece(MapEntry<String, String> item, int index) {
    final product = ProductCatalog.findProduct(item.key, item.value);
    final imagePath = product['image'] ?? '';
    final key = _pieceKey(item);

    final defaultPositions = [
      const Offset(120, 36),
      const Offset(112, 192),
      const Offset(24, 250),
      const Offset(210, 346),
      const Offset(38, 398),
      const Offset(220, 112),
      const Offset(98, 456),
      const Offset(218, 235),
    ];

    final defaultSizes = [120.0, 160.0, 130.0, 125.0, 120.0, 105.0, 98.0, 94.0];

    final safeIndex = index % defaultPositions.length;
    final position = piecePositions[key] ?? defaultPositions[safeIndex];
    final size = pieceSizes[key] ?? defaultSizes[safeIndex];

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () => _showProductInfo(item, index),
        onPanUpdate: (details) {
          setState(() {
            final currentPosition =
                piecePositions[key] ?? defaultPositions[safeIndex];

            piecePositions[key] = Offset(
              currentPosition.dx + details.delta.dx,
              currentPosition.dy + details.delta.dy,
            );
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: size,
          height: size,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xff8d5f52).withOpacity(0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff8d5f52).withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: imagePath.isEmpty
              ? const Icon(Icons.image_not_supported, color: Color(0xff8d5f52))
              : Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      color: Color(0xff8d5f52),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _showProductInfo(MapEntry<String, String> item, int index) {
    final product = ProductCatalog.findProduct(item.key, item.value);
    final imagePath = product['image'] ?? '';
    final key = _pieceKey(item);

    final defaultSizes = [120.0, 160.0, 130.0, 125.0, 120.0, 105.0, 98.0, 94.0];
    final safeIndex = index % defaultSizes.length;

    double currentSize = pieceSizes[key] ?? defaultSizes[safeIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.62,
          minChildSize: 0.42,
          maxChildSize: 0.88,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, modalSetState) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xffead8cf),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (imagePath.isEmpty)
                        const Icon(Icons.image_not_supported, size: 56)
                      else
                        Center(
                          child: Image.asset(
                            imagePath,
                            height: 76,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 56,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2b2026),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['brand'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff8d5f52),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xfff6eee9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parça boyutu',
                              style: TextStyle(
                                color: Color(0xff2b2026),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    modalSetState(() {
                                      currentSize = (currentSize - 12).clamp(
                                        55.0,
                                        300.0,
                                      );
                                    });
                                    setState(() {
                                      pieceSizes[key] = currentSize;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(0xff8d5f52),
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: currentSize,
                                    min: 55,
                                    max: 300,
                                    activeColor: const Color(0xff8d5f52),
                                    inactiveColor: const Color(0xffead8cf),
                                    onChanged: (value) {
                                      modalSetState(() {
                                        currentSize = value;
                                      });
                                      setState(() {
                                        pieceSizes[key] = value;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    modalSetState(() {
                                      currentSize = (currentSize + 12).clamp(
                                        55.0,
                                        300.0,
                                      );
                                    });
                                    setState(() {
                                      pieceSizes[key] = currentSize;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xff8d5f52),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Parçayı ekranda sürükle, boyutunu buradan ayarla.',
                              style: TextStyle(
                                color: Color(0xff7a6470),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8d5f52),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () => _openUrl(product['url'] ?? ''),
                          child: const Text(
                            'Web sitesine git',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _brandTags(List<MapEntry<String, String>> items) {
    final brands = items
        .map(
          (item) =>
              ProductCatalog.findProduct(item.key, item.value)['brand'] ?? '',
        )
        .where((brand) => brand.isNotEmpty)
        .toSet()
        .toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: brands.map((brand) {
        return Chip(
          backgroundColor: const Color(0xfff1ded4),
          label: Text(
            brand,
            style: const TextStyle(
              color: Color(0xff8d5f52),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xff8d5f52), width: 1.4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.edit, color: Color(0xff8d5f52)),
            label: const Text(
              'Düzenle',
              style: TextStyle(color: Color(0xff8d5f52)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff8d5f52),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _saveOutfit,
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            label: Text(
              isSaved ? 'Kaydedildi' : 'Kaydet',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
