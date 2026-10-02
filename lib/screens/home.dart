import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/data.dart';
import 'package:flutter_application_4/screens/detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // daftar kategori diambil otomatis dari data menu
    final List<String> categories = [
      'Semua',
      ...menus.map((m) => m.category).toSet(),
    ];

    // filter 
    final filteredMenus = menus.where((m) {
      final cocokKategori =
          _selectedCategory == 'Semua' || m.category == _selectedCategory;
      final cocokSearch = m.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      return cocokKategori && cocokSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Cari menu',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          Expanded(
            child: filteredMenus.isEmpty
                ? Center(child: Text('Menu tidak ditemukan'))
                : ListView.builder(
                    itemCount: filteredMenus.length,
                    itemBuilder: (context, index) {
                      final menu = filteredMenus[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(menu: menu),
                            ),
                          );
                        },
                        title: Text(menu.name),
                        subtitle: Text('${menu.category} • ${menu.price}'),
                        leading: Image.network(menu.image, width: 50),
                        trailing: Icon(Icons.arrow_forward_ios),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
