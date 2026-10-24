import 'package:flutter/foundation.dart';

import 'catalog.dart';
import 'product.dart';

class ShopState extends ChangeNotifier {
  ShopState({CatalogRepository? repository}) : _repository = repository ?? CatalogRepository();
  final CatalogRepository _repository;
  List<Product> products = const [];
  final Map<String, CartItem> _cart = {};
  final Map<String, Product> _wishlist = {};
  bool isLoading = false;
  bool isFallback = false;
  String? error;

  List<CartItem> get items => List.unmodifiable(_cart.values);
  List<Product> get wishlist => List.unmodifiable(_wishlist.values);
  int get itemCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  double get total => _cart.values.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  bool isWishlisted(String id) => _wishlist.containsKey(id);

  Future<void> loadCatalog() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      products = await _repository.fetchProducts();
      isFallback = false;
    } catch (exception) {
      error = exception.toString();
      products = demoCatalog;
      isFallback = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    final previous = _cart[product.id];
    _cart[product.id] = CartItem(product: product, quantity: (previous?.quantity ?? 0) + 1);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final item = _cart[id];
    if (item == null) return;
    if (quantity < 1) {
      _cart.remove(id);
    } else {
      _cart[id] = CartItem(product: item.product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (_wishlist.containsKey(product.id)) {
      _wishlist.remove(product.id);
    } else {
      _wishlist[product.id] = product;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
