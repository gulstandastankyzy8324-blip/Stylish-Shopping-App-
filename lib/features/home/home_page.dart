import 'package:flutter/material.dart';

import '../checkout/checkout_screen.dart';
import '../profile/profile.dart';
import '../shop/product_data.dart';
import '../shop/shop_details.dart';
import '../shop/shop_screen.dart';
import '../shop/wishlist_screen.dart';
import 'dart:io';
import '../../core/storage/user_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String selectedCategory = 'All';
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  Future<void> loadAvatar() async {
    final path = await UserStorage.getAvatar();

    if (!mounted) return;

    setState(() {
      avatarPath = path;
    });
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Womens', 'icon': Icons.woman},
    {'name': 'Mens', 'icon': Icons.man},
    {'name': 'Shoes', 'icon': Icons.directions_run},
    {'name': 'Bags', 'icon': Icons.shopping_bag_outlined},
  ];

  List<Product> get visibleProducts {
    if (selectedCategory == 'All') {
      return products;
    }

    return products
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  void openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                menuItem(Icons.home_outlined, 'Home', () {
                  Navigator.pop(context);
                }),
                menuItem(Icons.shopping_bag_outlined, 'Shop', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopScreen()),
                  );
                }),
                menuItem(Icons.favorite_border, 'Wishlist', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistScreen(),
                    ),
                  );
                }),
                menuItem(Icons.shopping_cart_outlined, 'Cart', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutScreen(),
                    ),
                  );
                }),
                menuItem(Icons.person_outline, 'Profile', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFFE9ED),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFFF3B61)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void changePage(int index) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
      });
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WishlistScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShopScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Price: Low to High'),
                  onTap: () {
                    setState(() {
                      products.sort((a, b) => a.price.compareTo(b.price));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Price: High to Low'),
                  onTap: () {
                    setState(() {
                      products.sort((a, b) => b.price.compareTo(a.price));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Name: A to Z'),
                  onTap: () {
                    setState(() {
                      products.sort((a, b) => a.name.compareTo(b.name));
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    final name = category['name'] as String;

                    return ChoiceChip(
                      label: Text(name),
                      selected: selectedCategory == name,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = name;
                        });

                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  children: [
                    buildHeader(),
                    const SizedBox(height: 18),
                    buildSearch(),
                    const SizedBox(height: 18),
                    buildFeaturedHeader(),
                    const SizedBox(height: 15),
                    buildCategories(),
                    const SizedBox(height: 18),
                    buildSaleBanner(),
                    const SizedBox(height: 18),
                    buildDealBanner(),
                    const SizedBox(height: 14),
                    buildProductList(),
                    const SizedBox(height: 22),
                    buildSpecialOffer(),
                    const SizedBox(height: 22),
                    buildTrendingHeader(),
                    const SizedBox(height: 14),
                    buildTrendingProducts(),
                    const SizedBox(height: 22),
                    buildSummerBanner(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF3B61),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: openMenu,
            borderRadius: BorderRadius.circular(12),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(Icons.menu),
            ),
          ),
        ),
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFFFF3B61),
                size: 28,
              ),
              SizedBox(width: 6),
              Text(
                'Stylish',
                style: TextStyle(
                  color: Color(0xFFFF3B61),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );

            await loadAvatar();
          },
          child: CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xFFFFE4EA),
            backgroundImage:
                avatarPath != null && File(avatarPath!).existsSync()
                ? FileImage(File(avatarPath!))
                : null,
            child: avatarPath == null || !File(avatarPath!).existsSync()
                ? const Icon(Icons.person, color: Color(0xFFFF3B61))
                : null,
          ),
        ),
      ],
    );
  }

  Widget buildSearch() {
    return TextField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        );
      },
      decoration: InputDecoration(
        hintText: 'Search any Product...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.mic_none),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildFeaturedHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedCategory == 'All' ? 'All Featured' : selectedCategory,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        smallButton('Sort', Icons.swap_vert, showSortOptions),
        const SizedBox(width: 8),
        smallButton('Filter', Icons.filter_alt_outlined, showFilterOptions),
      ],
    );
  }

  Widget smallButton(String text, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Text(text),
              const SizedBox(width: 4),
              Icon(icon, size: 17),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 17);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final name = category['name'] as String;
          final active = selectedCategory == name;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = name;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active
                        ? const Color(0xFFFF3B61)
                        : const Color(0xFFFFE4EA),
                  ),
                  child: Icon(
                    category['icon'],
                    color: active ? Colors.white : const Color(0xFFFF3B61),
                  ),
                ),
                const SizedBox(height: 5),
                Text(name, style: const TextStyle(fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSaleBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B88), Color(0xFFFF3B61)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '50-40% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Now in product',
                  style: TextStyle(color: Colors.white),
                ),
                const Text(
                  'All colours',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Shop Now  →'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 105,
            height: 135,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.checkroom, color: Colors.white, size: 72),
          ),
        ],
      ),
    );
  }

  Widget buildDealBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF4392F9),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal of the Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 15),
                    SizedBox(width: 5),
                    Text(
                      '22h 55m 20s remaining',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text('View all →'),
          ),
        ],
      ),
    );
  }

  Widget buildProductList() {
    if (visibleProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Text('No products found'),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: visibleProducts.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          return productCard(visibleProducts[index]);
        },
      ),
    );
  }

  Widget productCard(Product product) {
    return GestureDetector(
      onTap: () => openProduct(product),
      child: Container(
        width: 175,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 175,
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF1F1F1),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${product.reviews}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecialOffer() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFFFE4EA),
            child: Icon(Icons.local_offer, color: Color(0xFFFF3B61), size: 30),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'We make sure you get the best prices.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTrendingHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B88),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.white, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'Last Date 29/09/26',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text('View all →'),
          ),
        ],
      ),
    );
  }

  Widget buildTrendingProducts() {
    final trending = products.take(3).toList();

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trending.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          return productCard(trending[index]);
        },
      ),
    );
  }

  Widget buildSummerBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Arrivals',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Summer 26 Collections',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B61),
              foregroundColor: Colors.white,
            ),
            child: const Text('View all →'),
          ),
        ],
      ),
    );
  }
}
