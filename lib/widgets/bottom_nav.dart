import 'package:flutter/material.dart';
import '../screens/saved_outfits_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';
import '../screens/fikirler_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xfffffbf8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff8d5f52).withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const BottomNavItem(
            icon: Icons.home_rounded,
            title: 'Keşfet',
            active: true,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FikirlerPage()),
              );
            },
            child: const BottomNavItem(
              icon: Icons.image_outlined,
              title: 'Fikirler',
            ),
          ),
          const SizedBox(width: 42),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: const BottomNavItem(
              icon: Icons.search_rounded,
              title: 'Ara',
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: const BottomNavItem(
              icon: Icons.person_outline,
              title: 'Profil',
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 74,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xfff1ded4) : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: active ? const Color(0xff8d5f52) : const Color(0xff8b7a73),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: active ? const Color(0xff8d5f52) : const Color(0xff8b7a73),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
