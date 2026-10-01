import 'package:flutter/material.dart';

import 'product_data.dart';
import 'shop_details.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';
  String selectedCategory = 'All';

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              product.category.toLowerCase().contains(
                searchText.toLowerCase(),
              );

      final matchesCategory =
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showSort() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Price: Low to High'),
                  onTap: () {
                    setState(() {
                      products.sort(
                        (a, b) =>
                            a.price.compareTo(b.price),
                      );
                    });

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Price: High to Low'),
                  onTap: () {
                    setState(() {
                      products.sort(
                        (a, b) =>
                            b.price.compareTo(a.price),
                      );
                    });

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Name: A to Z'),
                  onTap: () {
                    setState(() {
                      products.sort(
                        (a, b) =>
                            a.name.compareTo(b.name),
                      );
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

  void showFilter() {
    const categories = [
      'All',
      'Womens',
      'Mens',
      'Shoes',
      'Bags',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected:
                          selectedCategory == category,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFFFF3B61),
            ),
            SizedBox(width: 6),
            Text(
              'Stylish',
              style: TextStyle(
                color: Color(0xFFFF3B61),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              16,
              5,
              16,
              15,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search any Product...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isEmpty
                    ? const Icon(Icons.mic_none)
                    : IconButton(
                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            searchText = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(9),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              15,
              16,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${filteredProducts.length}+ Items',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                smallButton(
                  'Sort',
                  Icons.swap_vert,
                  showSort,
                ),
                const SizedBox(width: 8),
                smallButton(
                  'Filter',
                  Icons.filter_alt_outlined,
                  showFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      20,
                    ),
                    itemCount:
                        filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.57,
                    ),
                    itemBuilder: (context, index) {
                      return productCard(
                        filteredProducts[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget smallButton(
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
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

  Widget productCard(Product product) {
    final discount =
        ((product.oldPrice - product.price) /
                product.oldPrice *
                100)
            .round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      color: const Color(0xFFF0F0F0),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 55,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '₹${product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          decoration:
                              TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$discount% Off',
                        style: const TextStyle(
                          color: Color(0xFFFF3B61),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style:
                            const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${product.reviews}',
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
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
}