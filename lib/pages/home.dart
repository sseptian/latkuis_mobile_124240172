import 'package:flutter/material.dart';

import '../models/culinaryModels.dart';
import 'detail.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Mie',
    'Dimsum',
    'Minuman',
    'Favorit ❤️',
  ];

  // Halaman 1: Katalog Menu
  Widget _buildMenuTab() {
    final filteredMenus = menus.where((menu) {
      final matchesSearch = menu.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      if (_selectedCategory == 'Semua') return matchesSearch;
      if (_selectedCategory == 'Favorit ❤️') {
        return matchesSearch && favoriteMenuIds.contains(menu.id);
      }
      return matchesSearch && menu.category == _selectedCategory;
    }).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari menu...',
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Color(0xFF673AB7),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Color(0xFF673AB7)),
              ),
            ),
          ),
        ),

        // Filter Kategori
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSel = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSel,
                selectedColor: const Color(0xFF673AB7),
                backgroundColor: Colors.white,
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSel ? Colors.white : Colors.black87,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSel ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCategory = cat);
                },
              );
            },
          ),
        ),

        // List Item
        Expanded(
          child: ListView.builder(
            itemCount: filteredMenus.length,
            itemBuilder: (context, index) {
              final menu = filteredMenus[index];
              final isFav = favoriteMenuIds.contains(menu.id);

              return InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(menu: menu)),
                  );
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'menu_${menu.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            menu.image,
                            width: 58,
                            height: 58,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              menu.price,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? Colors.redAccent
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFav) {
                              favoriteMenuIds.remove(menu.id);
                            } else {
                              favoriteMenuIds.add(menu.id);
                            }
                          });
                        },
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Halaman 2: Profil & Logout
  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFECE6F8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 45, color: Color(0xFF673AB7)),
          ),
          const SizedBox(height: 14),
          Text(
            'Username',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            widget.username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDF7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 16, color: Color(0xFF673AB7)),
                  SizedBox(width: 6),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF673AB7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FC),
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Home' : 'Profile',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: _currentIndex == 0 ? _buildMenuTab() : _buildProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFFBF8FC),
        elevation: 0,
        selectedItemColor: const Color(0xFF673AB7),
        unselectedItemColor: Colors.grey.shade500,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
