# Style Hub

A responsive Flutter fashion-shopping application for the CS506PC UI Design lab. Style Hub brings product discovery, search and category filters, product details, wishlist, cart, and a simulated checkout into one small application. The catalog reads fashion categories from DummyJSON and falls back to a visibly labelled local demonstration catalog when the API is unavailable.

## Scope

Included: fashion product browsing, search, category filters, product details, shared cart and wishlist state, quantity and total calculations, checkout validation, simulated order confirmation, responsive grid breakpoints, light/dark themes, image fallbacks, and explainable price-based Style Picks.

Excluded: real payments, accounts, order fulfilment, stock claims, ratings or discount claims, and backend persistence. Style Picks use a simple lowest-listed-price sort; they are not AI recommendations. Local fallback items are marked as demo products in the data model and are clearly labelled in the interface.

## Technology

- Flutter and Dart
- Provider / ChangeNotifier for shared cart and wishlist state
- `http` for REST calls
- DummyJSON product category endpoints for sample product data

The live catalog requests `https://dummyjson.com/products/category/{category}` for `tops`, `mens-shirts`, `mens-shoes`, `womens-dresses`, `womens-shoes`, `womens-bags`, `womens-jewellery`, and `sunglasses`. On 24 October 2026, each endpoint returned HTTP success and between 3 and 5 products. The response included `id`, `title`, `description`, `category`, `price`, `thumbnail`, and `images` fields. The app combines and de-duplicates these category results. The API returns a numeric `price` but no currency field, so the interface displays neutral amounts and states that the currency is unspecified. DummyJSON describes itself as sample / placeholder data, so the products are for demonstration only.

## Setup

Requires a Flutter SDK and network access for dependency resolution. From this folder:

```powershell
flutter create --project-name style_hub --platforms android,ios,web .
flutter pub get
flutter run -d chrome
```

Without API access, the app is designed to show the local demo catalog. Product imagery is remote and falls back to a neutral clothing icon if unavailable.

## Project structure

```text
lib/
  main.dart              App theme, named routes, responsive screens and reusable UI
  src/product.dart       Product/cart/order models and labelled local catalog
  src/catalog.dart       DummyJSON client, JSON parsing and category aggregation
  src/shop_state.dart         Shared cart, wishlist and catalog loading state
  src/product_filters.dart    Search and Style Picks rules
  src/checkout_validation.dart Reusable checkout field validators
test/
  style_hub_test.dart    Model, API parsing, cart, wishlist and fallback tests
  product_filters_test.dart Search, Style Picks and checkout validation tests
  widgets_test.dart      Empty-state widget test
tool/
  dart_basics.dart       Executable Dart fundamentals demonstration
 docs/
  screenshots/app/       Genuine app screenshots (to be captured after runtime is available)
  screenshots/code/      Genuine code screenshots (to be captured after editor/runtime is available)
```

## Lab experiment mapping

| Experiment | Style Hub evidence |
| --- | --- |
| 1. Dart and Flutter basics | `tool/dart_basics.dart` demonstrates typed values, functions, collections, a condition, loops, and cart arithmetic. |
| 2. Widgets and layouts | `lib/main.dart`: Text, Image, Container, Icon, Row, Column, Stack, product cards and detail layouts. |
| 3. Responsive UI | `LayoutBuilder`, `SliverLayoutBuilder`, responsive product grid, and detail layout in `lib/main.dart`. |
| 4. Navigation | Named route dispatch in `StyleHubApp`; routes for home, product, wishlist, cart, checkout and order. |
| 5. State management | `ShopState` uses ChangeNotifier; `main` provides it; local search/filter/theme interactions use `setState`. |
| 6. Custom widgets and themes | `ProductCard`, `ProductImage`, `OrderTotals`, `EmptyState`, `SectionHeading`, `StylePicks`, and Material 3 light/dark themes in `lib/main.dart`. |
| 7. Forms and validation | `CheckoutScreen` uses Form and TextFormField validators for name, email, address and postal code. |
| 8. Animations | `AnimatedSwitcher` fades the product count as search/filter results change; the explore action uses an eased scroll animation. |
| 9. REST API | `lib/src/catalog.dart` fetches fashion category endpoints and `Product.fromJson` parses results. Loading, fallback and error presentation are in `lib/main.dart`. |
| 10. Testing and debugging | `test/` covers parsing, API failure, cart totals, wishlist, search, checkout validation, fallback and an empty-state widget. Runtime verification remains pending because the installed Flutter/Dart CLI currently fails to launch reliably in this environment. |

## Dart demonstration

Run the small standalone example with:

```powershell
dart run tool/dart_basics.dart
```

Expected output includes the product name, unit price, quantity, calculated subtotal and two visible cart rows.

## Verification log

- Flutter/Dart SDK detected at `C:\src\flutter`; Dart SDK identifies itself as 3.13.4.
- The DummyJSON product category endpoints were queried directly on 24 October 2026. All eight fashion category requests succeeded; the result counts ranged from 3 to 5 products each.
- `flutter create` and `flutter --version` did not return output within the command window. Direct `dart format` fails inside DartDev with `Platform.resolvedExecutable` null; the Flutter tool snapshot reports an incompatible/empty `resolved_executable_name` VM flag. Consequently `dart format`, `dart run`, `flutter analyze`, `flutter test`, runtime checks, and genuine screenshots have not yet been verified.
- `flutter test` and `flutter analyze` were each started and stopped after 20 seconds without output. `dart run tool/dart_basics.dart` also produced no output within 10 seconds and was interrupted. These are blocked attempts, not passing results.
- The report content is in `docs/PROJECT_REPORT_DRAFT.md`. A DOCX was not produced because the configured DOCX renderer cannot find LibreOffice; its rendering gate cannot be completed.
- The report content is in docs/PROJECT_REPORT_DRAFT.md. A DOCX was not produced because the configured DOCX renderer cannot find LibreOffice; its rendering gate cannot be completed.

## Screenshots and evidence

No application screenshots have been added yet. Capture genuine screens from the running app into `docs/screenshots/app/` (home, search/filter, detail, wishlist, cart quantities/totals, checkout errors and simulated confirmation) and update this README with working image links once the Flutter runtime is available.

## References

- ACE Engineering College, *CS506PC: UI Design-Flutter* course plan, 2026.
- ACE Engineering College, *UI Design – Flutter Lab Manual*, 2026.
- ACE Engineering College, *One-Week Technical Project Report* template, supplied for the project.
- DummyJSON, [Products API documentation](https://dummyjson.com/docs/products), accessed 24 October 2026.
- Flutter, [official documentation](https://docs.flutter.dev/).

## Current limitations

The project source and tests are in place, but local Flutter tooling is not currently launching, so the app has not been analyzed, tested, built, or run. Platform scaffolding, screenshots, visual responsive checks, Flutter analysis and tests depend on restoring or using a working Flutter SDK. The report remains a Markdown draft until a DOCX renderer is available. The user-provided Style Hub `origin` URL is configured. The push attempt failed before authentication because the Git credential helper could not start in this environment; no commits have been pushed. An authenticated GitHub connection or a working local credential helper is still needed.
