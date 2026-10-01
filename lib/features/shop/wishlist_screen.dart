import 'package:flutter/material.dart';

import '../../core/storage/cart_storage.dart';
import '../../core/storage/wishlist_storage.dart';
import 'product_data.dart';
import 'shop_details.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    final items = await WishlistStorage.getWishlist();

    if (!mounted) return;

    setState(() {
      wishlist = items;
      isLoading = false;
    });
  }

  Product? findProduct(String name) {
    for (final product in products) {
      if (product.name == name) {
        return product;
      }
    }

    return null;
  }

  Future<void> removeItem(String name) async {
    await WishlistStorage.removeFavorite(name);
    await loadWishlist();
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    await CartStorage.addToCart(
      name: item['name'],
      price: (item['price'] as num).toDouble(),
      image: item['image'] ?? '',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart'),
        behavior: SnackBarBehavior.floating,
      ),
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
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF3B61)),
            )
          : wishlist.isEmpty
          ? emptyWishlist()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                return productCard(wishlist[index]);
              },
            ),
    );
  }

  Widget emptyWishlist() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE9ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 55,
                color: Color(0xFFFF3B61),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save your favorite products and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B61),
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(Map<String, dynamic> item) {
    final price = (item['price'] as num).toDouble();

    final product = findProduct(item['name'].toString());

    return GestureDetector(
      onTap: product == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              ).then((value) {
                loadWishlist();
              });
            },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (product != null)
                    Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF0F0F0),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 55,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 55,
                        color: Colors.grey,
                      ),
                    ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          removeItem(item['name'].toString());
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF3B61),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B61),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
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
