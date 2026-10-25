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
      id: 'view-shirt',
      name: 'Everyday Shirt',
      description: 'A versatile everyday shirt',
      category: 'tops',
      price: 30.0,
      imageUrl: '',
    );

    secondProduct = const Product(
      id: 'view-jacket',
      name: 'Classic Jacket',
      description: 'A lightweight jacket',
      category: 'tops',
      price: 50.0,
      imageUrl: '',
    );
  });

  tearDown(() {
    shop.dispose();
  });

  test('cart items list cannot be modified directly', () {
    shop.addToCart(product);

    final itemsSnapshot = shop.items;

    expect(
      () => itemsSnapshot.clear(),
      throwsA(isA<UnsupportedError>()),
    );

    expect(shop.items, hasLength(1));
    expect(shop.itemCount, 1);
  });

  test('cart items getter returns a snapshot', () {
    shop.addToCart(product);

    final itemsSnapshot = shop.items;

    shop.addToCart(secondProduct);

    expect(itemsSnapshot, hasLength(1));
    expect(shop.items, hasLength(2));
  });

  test('wishlist list cannot be modified directly', () {
    shop.toggleWishlist(product);

    final wishlistSnapshot = shop.wishlist;

    expect(
      () => wishlistSnapshot.clear(),
      throwsA(isA<UnsupportedError>()),
    );

    expect(shop.wishlist, hasLength(1));
    expect(shop.isWishlisted(product.id), isTrue);
  });

  test('wishlist getter returns a snapshot', () {
    shop.toggleWishlist(product);

    final wishlistSnapshot = shop.wishlist;

    shop.toggleWishlist(secondProduct);

    expect(wishlistSnapshot, hasLength(1));
    expect(shop.wishlist, hasLength(2));
  });
}