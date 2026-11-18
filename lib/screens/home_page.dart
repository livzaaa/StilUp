import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/outfit_card.dart';
import '../data/saved_outfits_store.dart';
import 'outfit_result_page.dart';
import 'create_outfit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedStyle = 'günlük şıklık';

  final List<String> styles = [
    'günlük şıklık',
    'spor',
    'iş şıklığı',
    'akşam şıklığı',
  ];
  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    await SavedOutfitsStore.loadOutfits();
    if (mounted) setState(() {});
  }

  Future<void> _openCreateOutfitPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOutfitPage(selectedStyle: selectedStyle),
      ),
    );

    if (mounted) {
      await _loadCount();
    }
  }

  Future<void> _showAiSuggestion() async {
    await SavedOutfitsStore.loadOutfits();

    final filteredOutfits = SavedOutfitsStore.savedOutfits.where((outfit) {
      final outfitStyle = outfit['Stil'];

      if (outfitStyle == null || outfitStyle.isEmpty) {
        return selectedStyle == 'günlük şıklık';
      }

      return outfitStyle == selectedStyle;
    }).toList();

    if (!mounted) return;

    if (filteredOutfits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bu stile ait kayıtlı kombin yok. Önce $selectedStyle için kombin kaydet 🤎',
          ),
        ),
      );
      return;
    }

    final randomIndex = Random().nextInt(filteredOutfits.length);
    final suggestedOutfit = filteredOutfits[randomIndex];

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Sana kayıtlı kombinlerinden biri önerildi'),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutfitResultPage(selectedPieces: suggestedOutfit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xfff3ebe6),
      bottomNavigationBar: const BottomNav(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffb88a78),
        elevation: 8,
        onPressed: _openCreateOutfitPage,
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          _softBlobs(),
          SafeArea(
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 18),
                _filterRow(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
                    children: [
                      const SizedBox(height: 4),
                      _styleSelector(),
                      const SizedBox(height: 16),
                      _aiSuggestionButton(),
                      OutfitCard(
                        selectedSeason: '',
                        selectedStyle: selectedStyle,
                        onCreateTap: _openCreateOutfitPage,
                      ),
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
              top: 135,
              left: -75,
              child: _blob(
                size: 190,
                color: const Color(0xffd7b3a6).withOpacity(0.28),
              ),
            ),
            Positioned(
              top: 360,
              right: -95,
              child: _blob(
                size: 230,
                color: const Color(0xff8d5f52).withOpacity(0.13),
              ),
            ),
            Positioned(
              bottom: 130,
              left: -70,
              child: _blob(
                size: 190,
                color: const Color(0xffead8cf).withOpacity(0.55),
              ),
            ),
            Positioned(
              bottom: 280,
              right: 40,
              child: _blob(
                size: 120,
                color: const Color(0xfffffbf8).withOpacity(0.80),
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

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: const BoxDecoration(
        color: Color(0xfffffbf8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'StilUp',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xff9f7262),
              fontStyle: FontStyle.italic,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffb88a78), Color(0xffd7b3a6)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff8d5f52).withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              '🧩 ${SavedOutfitsStore.savedOutfits.length}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [Expanded(child: _filterBox('Stil', selectedStyle))],
      ),
    );
  }

  Widget _filterBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xfffffbf8),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 17, color: Color(0xff2b2026)),
            children: [
              TextSpan(text: '$title '),
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xff9f7262),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _styleSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xffb88a78)
                  : const Color(0xfffffdfb),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xffc7a596), width: 1.8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xff8d5f52).withOpacity(0.16),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              isSelected ? '✓ $style' : style,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xff2b2026),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _aiSuggestionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8d5f52), Color(0xffd7b3a6)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: _showAiSuggestion,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'AI kombin öner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xff2b2026),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
