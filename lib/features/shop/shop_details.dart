import 'package:flutter/material.dart';

import '../../core/storage/cart_storage.dart';
import '../../core/storage/wishlist_storage.dart';
import '../checkout/checkout_screen.dart';
import 'product_data.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = '7 UK';
  bool isFavorite = false;
  bool isAdding = false;

  final List<String> sizes = ['36', '38', '40', '42', '44'];

  @override
  void initState() {
    super.initState();
    loadFavorite();
  }

  double get productPrice => widget.product.price;

  int get discount {
    final p = widget.product;
    return ((p.oldPrice - p.price) / p.oldPrice * 100).round();
  }

  Future<void> loadFavorite() async {
    final favorite = await WishlistStorage.isFavorite(widget.product.name);

    if (!mounted) return;

    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> changeFavorite() async {
    await WishlistStorage.toggleFavorite(
      name: widget.product.name,
      price: productPrice,
    );

    if (!mounted) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to wishlist' : 'Removed from wishlist',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> addToCart() async {
    setState(() {
      isAdding = true;
    });

    await CartStorage.addToCart(
      name: widget.product.name,
      price: productPrice,
      image: widget.product.image,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    setState(() {
      isAdding = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
            );
          },
        ),
      ),
    );
  }

  Future<void> buyNow() async {
    await CartStorage.addToCart(
      name: widget.product.name,
      price: productPrice,
      image: widget.product.image,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: changeFavorite,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? const Color(0xFFFF3B61) : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.directions_run,
                    size: 135,
                    color: Color(0xFFFF3B61),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Size: $selectedSize',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sizes.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  final size = sizes[index];
                  final selected = selectedSize == size;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFFF3B61)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: const Color(0xFFFF3B61)),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFFFF3B61),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 23),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(product.category, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 19),
                const SizedBox(width: 4),
                Text(
                  '${product.rating}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Text(
                  '${product.reviews}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '₹${product.oldPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$discount% Off',
                  style: const TextStyle(
                    color: Color(0xFFFF3B61),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Product Details',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(height: 1.5, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                infoButton(Icons.location_on_outlined, 'Nearest Store'),
                infoButton(Icons.lock_outline, 'VIP'),
                infoButton(Icons.replay, 'Return policy'),
              ],
            ),
            const SizedBox(height: 27),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAdding ? null : addToCart,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: isAdding
                        ? const SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add to cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4392F9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: buyNow,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF40C878),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD8DF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery in', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 3),
                  Text(
                    '1 within Hour',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
