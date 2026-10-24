import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/product.dart';
import 'src/product_filters.dart';
import 'src/checkout_validation.dart';
import 'src/shop_state.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => ShopState()..loadCatalog(),
      child: const StyleHubApp(),
    ));

const wine = Color(0xFF783B46);
const ink = Color(0xFF28231F);
const paper = Color(0xFFF8F5F0);

class StyleHubApp extends StatefulWidget {
  const StyleHubApp({super.key});
  @override
  State<StyleHubApp> createState() => _StyleHubAppState();
}

class _StyleHubAppState extends State<StyleHubApp> {
  ThemeMode mode = ThemeMode.light;

  ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(seedColor: wine, brightness: brightness, surface: dark ? const Color(0xFF211E1C) : paper);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? const Color(0xFF171514) : paper,
      appBarTheme: AppBarTheme(backgroundColor: dark ? const Color(0xFF171514) : paper, foregroundColor: dark ? Colors.white : ink, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF292523) : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: scheme.primary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Style Hub',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(builder: (_) => HomeScreen(onToggleTheme: () => setState(() => mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light)));
            case '/product':
              return MaterialPageRoute<void>(builder: (_) => ProductScreen(product: settings.arguments! as Product));
            case '/wishlist':
              return MaterialPageRoute<void>(builder: (_) => const WishlistScreen());
            case '/cart':
              return MaterialPageRoute<void>(builder: (_) => const CartScreen());
            case '/checkout':
              return MaterialPageRoute<void>(builder: (_) => const CheckoutScreen());
            case '/order':
              return MaterialPageRoute<void>(builder: (_) => OrderScreen(order: settings.arguments! as OrderSummary));
            default:
              return MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
          }
        },
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();
  final scroll = ScrollController();
  String query = '';
  String category = 'All';

  @override
  void dispose() {
    search.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    final categories = shop.products.map((p) => p.category).toSet().toList()..sort();
    categories.insert(0, 'All');
    final matches = filterProducts(shop.products, query: query, category: category);
    return Scaffold(
      appBar: AppBar(
        title: const Text('STYLE HUB', style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w800, fontSize: 16)),
        actions: [
          IconButton(tooltip: 'Switch theme', onPressed: widget.onToggleTheme, icon: const Icon(Icons.contrast_outlined)),
          IconButton(tooltip: 'Wishlist', onPressed: () => Navigator.pushNamed(context, '/wishlist'), icon: const Icon(Icons.favorite_border)),
          IconButton(tooltip: 'Shopping bag', onPressed: () => Navigator.pushNamed(context, '/cart'), icon: const Icon(Icons.shopping_bag_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final pad = wide ? 48.0 : 20.0;
        return CustomScrollView(controller: scroll, slivers: [
          SliverPadding(padding: EdgeInsets.fromLTRB(pad, 8, pad, 0), sliver: SliverToBoxAdapter(child: _Hero(wide: wide, onExplore: () => scroll.animateTo(310, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic)))),
          SliverPadding(padding: EdgeInsets.fromLTRB(pad, 28, pad, 0), sliver: const SliverToBoxAdapter(child: SectionHeading(title: 'Find your point of view', eyebrow: 'THE EDIT'))),
          SliverPadding(padding: EdgeInsets.fromLTRB(pad, 14, pad, 0), sliver: SliverToBoxAdapter(child: TextField(controller: search, onChanged: (v) => setState(() => query = v.trim()), decoration: const InputDecoration(hintText: 'Search pieces, categories…', prefixIcon: Icon(Icons.search))))),
          SliverPadding(padding: EdgeInsets.fromLTRB(pad, 14, pad, 0), sliver: SliverToBoxAdapter(child: SizedBox(height: 42, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: categories.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (context, i) {
            final item = categories[i];
            return ChoiceChip(label: Text(item == 'All' ? item : pretty(item)), selected: category == item, onSelected: (_) => setState(() => category = item), showCheckmark: false, selectedColor: wine, labelStyle: TextStyle(color: category == item ? Colors.white : null));
          })))),
          if (shop.isFallback) SliverPadding(padding: EdgeInsets.fromLTRB(pad, 12, pad, 0), sliver: SliverToBoxAdapter(child: FallbackNotice(error: shop.error, onRetry: shop.loadCatalog))),
          if (shop.isLoading && shop.products.isEmpty)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (matches.isEmpty)
            const SliverFillRemaining(child: EmptyState(title: 'No pieces found', message: 'Try another search or choose a different category.'))
          else ...[
            SliverPadding(padding: EdgeInsets.fromLTRB(pad, 28, pad, 14), sliver: SliverToBoxAdapter(child: Row(children: [const Expanded(child: SectionHeading(title: 'Curated for you', eyebrow: 'NEW SEASON')), AnimatedSwitcher(duration: const Duration(milliseconds: 280), transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child), child: Text('${matches.length} pieces', key: ValueKey('${query}-${category}-${matches.length}'), style: Theme.of(context).textTheme.bodySmall)), if (shop.isLoading) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))]))),
            SliverPadding(padding: EdgeInsets.fromLTRB(pad, 0, pad, 28), sliver: SliverLayoutBuilder(builder: (context, grid) {
              final width = grid.crossAxisExtent;
              final columns = width >= 1180 ? 4 : width >= 760 ? 3 : width >= 430 ? 2 : 1;
              return SliverGrid.builder(
                itemCount: matches.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 20, childAspectRatio: columns == 1 ? 0.82 : 0.64),
                itemBuilder: (context, index) => ProductCard(product: matches[index], onTap: () => Navigator.pushNamed(context, '/product', arguments: matches[index])),
              );
            })),
            SliverPadding(padding: EdgeInsets.fromLTRB(pad, 0, pad, 42), sliver: SliverToBoxAdapter(child: StylePicks(products: matches))),
          ],
        ]);
      })),
      bottomNavigationBar: const HubNavigation(selected: 0),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.wide, required this.onExplore});
  final bool wide;
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(alignment: Alignment.centerLeft, children: [
          SizedBox(width: double.infinity, height: wide ? 310 : 280, child: Image.network('https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1800&q=85', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFFE5DCD2)))),
          Container(width: double.infinity, height: wide ? 310 : 280, color: Colors.black.withValues(alpha: .32)),
          Padding(padding: EdgeInsets.all(wide ? 40 : 24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('A LITTLE LESS ORDINARY', style: TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text('Make room\nfor your style.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.08)),
            const SizedBox(height: 18),
            FilledButton.tonal(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: ink), onPressed: onExplore, child: const Text('EXPLORE THE EDIT')),
          ]))),
        ]),
      );
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    final saved = shop.isWishlisted(product.id);
    return InkWell(borderRadius: BorderRadius.circular(18), onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Stack(children: [Positioned.fill(child: ProductImage(url: product.imageUrl, radius: 16)), Positioned(right: 10, top: 10, child: CircleAvatar(backgroundColor: Colors.white.withValues(alpha: .92), radius: 18, child: IconButton(padding: EdgeInsets.zero, iconSize: 19, tooltip: 'Toggle wishlist', onPressed: () => shop.toggleWishlist(product), icon: Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? wine : ink))))])),
      const SizedBox(height: 10),
      Text(pretty(product.category).toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1, color: Theme.of(context).colorScheme.primary)),
      const SizedBox(height: 3),
      Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(price(product.price), style: const TextStyle(fontWeight: FontWeight.w700)),
    ]));
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Scaffold(appBar: AppBar(title: const Text('THE DETAILS')), body: LayoutBuilder(builder: (context, size) {
      final wide = size.maxWidth > 760;
      final image = AspectRatio(aspectRatio: wide ? .88 : .84, child: ProductImage(url: product.imageUrl, radius: 22));
      final details = Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(pretty(product.category).toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12), Text(product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12), Text(price(product.price), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 18), const Divider(), const SizedBox(height: 14),
        Text(product.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.65)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { shop.addToCart(product); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to your bag'))); }, icon: const Icon(Icons.shopping_bag_outlined), label: const Text('ADD TO BAG'))),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => shop.toggleWishlist(product), icon: Icon(shop.isWishlisted(product.id) ? Icons.favorite : Icons.favorite_border), label: Text(shop.isWishlisted(product.id) ? 'SAVED TO WISHLIST' : 'SAVE TO WISHLIST'))),
      ]));
      return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1100), child: wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: image), Expanded(child: details)]) : Column(children: [image, details]))));
    }));
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Scaffold(appBar: AppBar(title: const Text('WISHLIST')), body: shop.wishlist.isEmpty ? const EmptyState(title: 'A place for your favourites', message: 'Save pieces you love and come back to them here.') : ProductList(products: shop.wishlist, onTap: (p) => Navigator.pushNamed(context, '/product', arguments: p), trailing: (p) => IconButton(onPressed: () => shop.toggleWishlist(p), icon: const Icon(Icons.favorite, color: wine))), bottomNavigationBar: const HubNavigation(selected: 1));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Scaffold(appBar: AppBar(title: const Text('YOUR BAG')), body: shop.items.isEmpty ? const EmptyState(title: 'Your bag is taking a breather', message: 'When you find something you love, it will be waiting here.') : Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10), itemCount: shop.items.length, itemBuilder: (context, index) { final item = shop.items[index]; return Padding(padding: const EdgeInsets.only(bottom: 12), child: CartLine(item: item, onIncrease: () => shop.updateQuantity(item.product.id, item.quantity + 1), onDecrease: () => shop.updateQuantity(item.product.id, item.quantity - 1), onRemove: () => shop.removeFromCart(item.product.id))); })),
      Padding(padding: const EdgeInsets.all(20), child: Column(children: [OrderTotals(subtotal: shop.total, total: shop.total), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushNamed(context, '/checkout'), child: const Text('CONTINUE TO CHECKOUT')))])),
    ]))), bottomNavigationBar: const HubNavigation(selected: 2));
  }
}

class CartLine extends StatelessWidget {
  const CartLine({super.key, required this.item, required this.onIncrease, required this.onDecrease, required this.onRemove});
  final CartItem item;
  final VoidCallback onIncrease, onDecrease, onRemove;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)), child: Row(children: [
    SizedBox(width: 86, height: 100, child: ProductImage(url: item.product.imageUrl, radius: 12)), const SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), Text(price(item.product.price)),
      Row(children: [IconButton(onPressed: onDecrease, visualDensity: VisualDensity.compact, icon: const Icon(Icons.remove_circle_outline)), Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)), IconButton(onPressed: onIncrease, visualDensity: VisualDensity.compact, icon: const Icon(Icons.add_circle_outline)), const SizedBox(height: 24), IconButton(onPressed: onRemove, tooltip: 'Remove item', icon: const Icon(Icons.delete_outline))]),
    ])),
  ]));
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController(), address = TextEditingController(), postal = TextEditingController();
  @override
  void dispose() { name.dispose(); email.dispose(); address.dispose(); postal.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopState>();
    return Scaffold(appBar: AppBar(title: const Text('CHECKOUT')), body: LayoutBuilder(builder: (context, size) {
      final width = size.maxWidth > 700 ? 620.0 : size.maxWidth;
      return SingleChildScrollView(padding: const EdgeInsets.all(22), child: Center(child: SizedBox(width: width, child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Delivery details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 6), const Text('A few details so we can prepare your demo order.'), const SizedBox(height: 24),
        TextFormField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name'), validator: validateName), const SizedBox(height: 12),
        TextFormField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address'), validator: validateEmail), const SizedBox(height: 12),
        TextFormField(controller: address, minLines: 2, maxLines: 3, decoration: const InputDecoration(labelText: 'Delivery address'), validator: validateAddress), const SizedBox(height: 12),
        TextFormField(controller: postal, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Postal code'), validator: validatePostalCode), const SizedBox(height: 26),
        OrderTotals(subtotal: shop.total, total: shop.total), const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: shop.items.isEmpty ? null : submit, child: const Text('PLACE DEMO ORDER'))), const SizedBox(height: 9),
        const Center(child: Text('Demonstration only • No payment is collected', style: TextStyle(fontSize: 12))),
      ])))));
    }));
  }
  void submit() {
    if (!form.currentState!.validate()) return;
    final shop = context.read<ShopState>();
    final order = OrderSummary(name: name.text.trim(), email: email.text.trim(), total: shop.total, itemCount: shop.itemCount);
    shop.clearCart();
    Navigator.pushNamedAndRemoveUntil(context, '/order', (route) => route.settings.name == '/', arguments: order);
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key, required this.order});
  final OrderSummary order;
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(28), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 84, height: 84, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle), child: Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary, size: 42)), const SizedBox(height: 24),
    Text('Your order is in the works', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 12),
    Text('Thanks, ${order.name}. This is a simulated confirmation. No payment or shipment was created.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)), const SizedBox(height: 20),
    Text('${order.itemCount} item${order.itemCount == 1 ? '' : 's'} • ${price(order.total)}', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 26),
    SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false), child: const Text('BACK TO STYLE HUB'))),
  ])))));
}

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.products, required this.trailing, required this.onTap});
  final List<Product> products;
  final Widget Function(Product) trailing;
  final ValueChanged<Product> onTap;
  @override
  Widget build(BuildContext context) => ListView.separated(padding: const EdgeInsets.all(20), itemCount: products.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (context, i) {
    final p = products[i];
    return Material(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18), child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => onTap(p), child: Padding(padding: const EdgeInsets.all(10), child: Row(children: [SizedBox(width: 74, height: 84, child: ProductImage(url: p.imageUrl, radius: 12)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), Text(pretty(p.category), style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 4), Text(price(p.price), style: const TextStyle(fontWeight: FontWeight.w700))])), trailing(p)]))));
  });
}

class HubNavigation extends StatelessWidget {
  const HubNavigation({super.key, required this.selected});
  final int selected;
  @override
  Widget build(BuildContext context) => NavigationBar(selectedIndex: selected, onDestinationSelected: (i) { final route = switch (i) { 0 => '/', 1 => '/wishlist', _ => '/cart' }; if (i != selected) Navigator.pushNamed(context, route); }, destinations: const [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Discover'),
    NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Wishlist'),
    NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Bag'),
  ]);
}

class OrderTotals extends StatelessWidget {
  const OrderTotals({super.key, required this.subtotal, required this.total});
  final double subtotal, total;
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text(price(subtotal))]), const SizedBox(height: 10),
    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Delivery'), Text('Complimentary')]), const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)), Text(price(total), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18))]),
  ]);
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, required this.radius});
  final String url;
  final double radius;
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: ColoredBox(color: const Color(0xFFECE6DF), child: url.isEmpty ? const Center(child: Icon(Icons.checkroom_outlined, size: 42, color: Color(0xFF8D8177))) : Image.network(url, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.checkroom_outlined, size: 42, color: Color(0xFF8D8177))), loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)))));
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, required this.eyebrow});
  final String title, eyebrow;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2)), const SizedBox(height: 6), Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))]);
}

class StylePicks extends StatelessWidget {
  const StylePicks({super.key, required this.products});
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    final picks = stylePicks(products);
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .45), borderRadius: BorderRadius.circular(20)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.auto_awesome_outlined, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('STYLE PICKS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)), const SizedBox(height: 5), const Text('A simple edit based on the lowest listed prices in this collection.'), const SizedBox(height: 12), Text(picks.take(3).map((p) => '${p.name} · ${price(p.price)}').join('\n'), style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.7))]))]));
  }
}

class FallbackNotice extends StatelessWidget {
  const FallbackNotice({super.key, required this.error, required this.onRetry});
  final String? error;
  final Future<void> Function() onRetry;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.wifi_off_outlined, size: 18), const SizedBox(width: 8), Expanded(child: Text('Showing clearly labelled local demo pieces${error == null ? '' : ' · API unavailable'}', style: Theme.of(context).textTheme.bodySmall)), TextButton(onPressed: onRetry, child: const Text('RETRY'))]));
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});
  final String title, message;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.checkroom_outlined, size: 48, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 16), Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center)])));
}

String price(double amount) => '$' + amount.toStringAsFixed(2);
String pretty(String value) => value.replaceAll('-', ' ').split(' ').map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
