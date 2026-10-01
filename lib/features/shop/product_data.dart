class Product {
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final String category;
  final String image;
  final double rating;
  final int reviews;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.image,
    required this.rating,
    required this.reviews,
  });
}

final List<Product> products = [
  const Product(
    name: 'Women Dress',
    description: 'Beautiful dress with a comfortable fit for everyday wear.',
    price: 1500,
    oldPrice: 2499,
    category: 'Womens',
    image: 'photos/dress1.jpg',
    rating: 4.5,
    reviews: 56890,
  ),
  const Product(
    name: 'Beige Winter Jacket',
    description: 'Warm beige jacket with a modern casual design.',
    price: 2499,
    oldPrice: 3999,
    category: 'Mens',
    image: 'photos/jacket1.jpg',
    rating: 4.4,
    reviews: 34400,
  ),
  const Product(
    name: 'Style Sneakers',
    description: 'Comfortable everyday sneakers with a sporty design.',
    price: 1999,
    oldPrice: 2999,
    category: 'Shoes',
    image: 'photos/shoes1.jpg',
    rating: 4.7,
    reviews: 48200,
  ),
  const Product(
    name: 'Red Embroidered Dress',
    description: 'Elegant red dress for casual and special occasions.',
    price: 1899,
    oldPrice: 2899,
    category: 'Womens',
    image: 'photos/dress2.jpg',
    rating: 4.6,
    reviews: 23500,
  ),
  const Product(
    name: 'Classic Handbag',
    description: 'Stylish handbag with enough space for daily essentials.',
    price: 1799,
    oldPrice: 2599,
    category: 'Bags',
    image: 'photos/bag1.jpg',
    rating: 4.3,
    reviews: 12800,
  ),
  const Product(
    name: 'White Casual Sneakers',
    description: 'Clean and minimal sneakers for a casual everyday look.',
    price: 1699,
    oldPrice: 2499,
    category: 'Shoes',
    image: 'photos/shoes2.jpg',
    rating: 4.8,
    reviews: 41300,
  ),
];
