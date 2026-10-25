import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;

  const shirt = Product(
    id: 'multi-shirt',
    name: 'Everyday Shirt',
    description: 'A comfortable shirt',
    category: 'tops',
    price: 25.0,
    imageUrl: '',
  );

  const jacket = Product(
    id: 'multi-jacket',
    name: 'Classic Jacket',
    description: 'A lightweight jacket',
    category: 'tops',
    price: 40.0,
    imageUrl: '',
  );

  setUp(() {
    shop = ShopState();
  });

  tearDown(() {
    shop.dispose();
  });

  test('cart total includes different products', () {
    shop.addToCart(shirt);
    shop.addToCart(jacket);

    expect(shop.itemCount, 2);
    expect(shop.total, 65.0);
  });

  test('removing one product preserves the other product', () {
    shop.addToCart(shirt);
    shop.addToCart(jacket);

    shop.removeFromCart(shirt.id);

    expect(shop.itemCount, 1);
    expect(shop.items.single.product.id, jacket.id);
    expect(shop.total, 40.0);
  });

  test('changing one product quantity preserves other products', () {
    shop.addToCart(shirt);
    shop.addToCart(jacket);

    shop.updateQuantity(shirt.id, 3);

    expect(shop.itemCount, 4);
    expect(shop.total, 115.0);
  });
}