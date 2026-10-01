import 'package:flutter/material.dart';
import '../../core/storage/user_storage.dart';
import 'shipping.dart';

class PlaceOrderScreen extends StatefulWidget {
  final double total;

  const PlaceOrderScreen({
    super.key,
    this.total = 84.00,
  });

  @override
  State<PlaceOrderScreen> createState() =>
      _PlaceOrderScreenState();
}

class _PlaceOrderScreenState
    extends State<PlaceOrderScreen> {
  String name = '';
  String address = '';
  String city = '';
  String country = '';

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  Future<void> loadAddress() async {
    final savedName = await UserStorage.getName();
    final savedAddress = await UserStorage.getAddress();
    final savedCity = await UserStorage.getCity();
    final savedCountry = await UserStorage.getCountry();

    if (!mounted) return;

    setState(() {
      name = savedName;
      address = savedAddress;
      city = savedCity;
      country = savedCountry;
    });
  }

  String get fullAddress {
    final parts = [
      address,
      city,
      country,
    ].where((value) => value.isNotEmpty).toList();

    if (parts.isEmpty) {
      return 'No address added yet';
    }

    return parts.join(', ');
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
          'Place Order',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFFFF3B61),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'User' : name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          fullAddress,
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Order Payment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  paymentRow(
                    'Order Amounts',
                    '\$${(widget.total - 5).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 15),
                  paymentRow(
                    'Convenience',
                    'Know More',
                    pink: true,
                  ),
                  const SizedBox(height: 15),
                  paymentRow(
                    'Delivery Fee',
                    '\$5.00',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Order',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  paymentRow(
                    'Order',
                    '\$${(widget.total - 5).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 15),
                  paymentRow(
                    'Shipping',
                    '\$5.00',
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),
                  paymentRow(
                    'Total',
                    '\$${widget.total.toStringAsFixed(2)}',
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShippingScreen(
                        total: widget.total,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF3B61),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentRow(
    String title,
    String value, {
    bool pink = false,
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: pink
                ? const Color(0xFFFF3B61)
                : Colors.black,
            fontSize: bold ? 17 : 14,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}