class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.isDemo = false,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final bool isDemo;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: '${json['id'] ?? ''}',
        name: json['title'] is String ? json['title'] as String : 'Untitled piece',
        description: json['description'] is String
            ? json['description'] as String
            : 'A considered addition to your wardrobe.',
        category: json['category'] is String ? json['category'] as String : 'clothing',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        imageUrl: (json['thumbnail'] as String?) ??
            ((json['images'] as List?)?.whereType<String>().firstOrNull ?? ''),
      );
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class CartItem {
  const CartItem({required this.product, required this.quantity});
  final Product product;
  final int quantity;
}

class OrderSummary {
  const OrderSummary({required this.name, required this.email, required this.total, required this.itemCount});
  final String name;
  final String email;
  final double total;
  final int itemCount;
}

const demoCatalog = <Product>[
  Product(id: 'demo-1', name: 'The Everyday Overshirt', description: 'A relaxed layer for the in-between hours, chosen for easy pairing and everyday wear.', category: 'Demo clothing', price: 32.90, imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=900&q=80', isDemo: true),
  Product(id: 'demo-2', name: 'Soft Structure Tote', description: 'A clean-lined carryall with room for the things that travel with you.', category: 'Demo accessories', price: 24.50, imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=900&q=80', isDemo: true),
  Product(id: 'demo-3', name: 'Weekend Knit', description: 'An easy knit layer with a soft hand and a relaxed silhouette.', category: 'Demo clothing', price: 37.90, imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=900&q=80', isDemo: true),
  Product(id: 'demo-4', name: 'City Walk Loafer', description: 'A versatile finishing touch for a considered everyday look.', category: 'Demo footwear', price: 41.90, imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=900&q=80', isDemo: true),
];
