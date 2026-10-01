import 'package:flutter/material.dart';
import '../../core/storage/cart_storage.dart';
import 'placeorder.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> cart = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await CartStorage.getCart();

    if (!mounted) return;

    setState(() {
      cart = items;
      isLoading = false;
    });
  }

  double get subtotal {
    double result = 0;

    for (final item in cart) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();

      result += price * quantity;
    }

    return result;
  }

  double get delivery {
    if (cart.isEmpty) {
      return 0;
    }

    return 5;
  }

  double get total {
    return subtotal + delivery;
  }

  Future<void> increaseQuantity(
    Map<String, dynamic> item,
  ) async {
    final int quantity = (item['quantity'] as num).toInt();

    await CartStorage.updateQuantity(
      item['name'],
      quantity + 1,
    );

    await loadCart();
  }

  Future<void> decreaseQuantity(
    Map<String, dynamic> item,
  ) async {
    final int quantity = (item['quantity'] as num).toInt();

    if (quantity <= 1) {
      await removeItem(item);
      return;
    }

    await CartStorage.updateQuantity(
      item['name'],
      quantity - 1,
    );

    await loadCart();
  }

  Future<void> removeItem(
    Map<String, dynamic> item,
  ) async {
    await CartStorage.removeFromCart(
      item['name'],
    );

    await loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Shopping Bag',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF3B61),
              ),
            )
          : cart.isEmpty
              ? emptyCart()
              : buildCart(),
      bottomNavigationBar:
          cart.isEmpty || isLoading
              ? null
              : buildBottomBar(),
    );
  }

  Widget emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE9ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 55,
                color: Color(0xFFFF3B61),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add some products to your cart and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF3B61),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child:
                  const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCart() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        25,
      ),
      children: [
        const Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 21,
            ),
            SizedBox(width: 7),
            Text(
              'Shopping List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...cart.map(
          (item) => Padding(
            padding:
                const EdgeInsets.only(bottom: 13),
            child: productCard(item),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              priceRow(
                'Order',
                '\$${subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 13),
              priceRow(
                'Delivery',
                '\$${delivery.toStringAsFixed(2)}',
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Divider(),
              ),
              priceRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget productCard(
    Map<String, dynamic> item,
  ) {
    final int quantity =
        (item['quantity'] as num).toInt();

    final double price =
        (item['price'] as num).toDouble();

    final String image =
        item['image']?.toString() ?? '';

    return Dismissible(
      key: ValueKey(item['name']),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(item);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding:
            const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B61),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 105,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9ED),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: image.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(9),
                      child: Image.asset(
                        image,
                        width: 90,
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                          return const Icon(
                            Icons.checkroom,
                            color:
                                Color(0xFFFF3B61),
                            size: 50,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.checkroom,
                      color:
                          Color(0xFFFF3B61),
                      size: 50,
                    ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          removeItem(item);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      quantityButton(
                        Icons.remove,
                        () {
                          decreaseQuantity(item);
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 13,
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                      quantityButton(
                        Icons.add,
                        () {
                          increaseQuantity(item);
                        },
                      ),
                      const Spacer(),
                      Text(
                        '\$${(price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w600,
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

  Widget quantityButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(6),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius:
              BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 17,
        ),
      ),
    );
  }

  Widget priceRow(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color:
                  bold ? Colors.black : Colors.grey,
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 17 : 14,
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          18,
          12,
          18,
          12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaceOrderScreen(
                        total: total,
                      ),
                    ),
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF3B61),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}