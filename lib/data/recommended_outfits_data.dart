class RecommendedOutfitsData {
  static const List<Map<String, dynamic>> outfits = [
    {
      'style': 'spor',
      'title': 'Spor kombin',
      'image': 'assets/images/inspo1.jpg',
      'products': [
        {
          'name': 'Çizgili kazak',
          'brand': 'Zara',
          'image': 'assets/images/striped_sweater.png',
          'url': 'https://www.zara.com/tr/',
        },
        {
          'name': 'Bol paça jean',
          'brand': 'Zara',
          'image': 'assets/images/blue_jean.png',
          'url': 'https://www.zara.com/tr/',
        },
        {
          'name': 'Siyah oval gözlük',
          'brand': 'Zara',
          'image': 'assets/images/black_glasses.png',
          'url': 'https://www.zara.com/tr/',
        },
      ],
    },
    {
      'style': 'günlük şıklık',
      'title': 'Günlük şık kombin',
      'image': 'assets/images/inspo2.jpg',
      'products': [
        {
          'name': 'Beyaz düğme detaylı üst',
          'brand': 'Zara',
          'image': 'assets/images/white_top.png',
          'url': 'https://www.zara.com/tr/',
        },
        {
          'name': 'Beyaz şort',
          'brand': 'Zara',
          'image': 'assets/images/white_shorts.png',
          'url': 'https://www.zara.com/tr/',
        },
        {
          'name': 'Kahverengi kemer',
          'brand': 'Zara',
          'image': 'assets/images/brown_belt.png',
          'url': 'https://www.zara.com/tr/',
        },
      ],
    },
  ];

  static List<Map<String, dynamic>> byStyle(String style) {
    final filtered = outfits
        .where((outfit) => outfit['style'] == style)
        .toList();

    if (filtered.isEmpty) {
      return outfits;
    }

    return filtered;
  }
}
