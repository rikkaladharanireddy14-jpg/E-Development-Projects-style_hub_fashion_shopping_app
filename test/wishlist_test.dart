import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;
  late Product product;
  late Product secondProduct;

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

    secondProduct = const Product(
      id: 'wishlist-jacket',
      name: 'Classic Jacket',
      description: 'A lightweight everyday jacket',
      category: 'tops',
      price: 50.0,
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

  test('wishlist supports multiple products', () {
    shop.toggleWishlist(product);
    shop.toggleWishlist(secondProduct);

    expect(shop.wishlist, hasLength(2));
    expect(shop.isWishlisted(product.id), isTrue);
    expect(shop.isWishlisted(secondProduct.id), isTrue);
  });

  test('removing one product keeps other wishlist products', () {
    shop.toggleWishlist(product);
    shop.toggleWishlist(secondProduct);

    shop.toggleWishlist(product);

    expect(shop.wishlist, hasLength(1));
    expect(shop.isWishlisted(product.id), isFalse);
    expect(shop.isWishlisted(secondProduct.id), isTrue);
  });

  test('wishlist actions do not change cart contents', () {
    shop.addToCart(product);

    shop.toggleWishlist(product);
    shop.toggleWishlist(secondProduct);

    expect(shop.itemCount, 1);
    expect(shop.total, 30.0);
    expect(shop.wishlist, hasLength(2));
  });
}
