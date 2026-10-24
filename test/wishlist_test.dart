import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;
  late Product product;

  setUp(() {
    shop = ShopState();
    product = const Product(
      id: 'wishlist-shirt',
      name: 'Everyday Shirt',
      description: 'A versatile wardrobe essential',
      category: 'tops',
      price: 30.0,
      imageUrl: '',
    );
  });

  tearDown(() {
    shop.dispose();
  });

  test('product can be added to wishlist', () {
    shop.toggleWishlist(product);

    expect(shop.wishlist, contains(product));
    expect(shop.isWishlisted(product.id), isTrue);
  });

  test('toggling a wishlisted product removes it', () {
    shop.toggleWishlist(product);
    shop.toggleWishlist(product);

    expect(shop.wishlist, isEmpty);
    expect(shop.isWishlisted(product.id), isFalse);
  });
}