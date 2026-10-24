# Style Hub Project Report Draft

## ACE Engineering College
### Technical Project Report

**Project title:** Style Hub: A Responsive Fashion Shopping Application Using Flutter<br>
**Submitted by:** [Student name(s)]<br>
**Roll number(s):** [Roll number(s)]<br>
**Branch and year:** [Department, year]<br>
**Academic year:** [Academic year]<br>
**Project duration:** 24 October 2026 to [completion date]<br>
**Project guide / mentor:** [Name and designation]<br>
**Organization / training institute:** ACE Engineering College<br>
**Submitted to:** Department of [Department name]

> Draft status: application runtime verification, genuine screenshots, final progress dates and report rendering are still pending. This report records only work and results observed in this project workspace.

## 1. Certificate

Not included. Student, mentor and department details and signatures have not been supplied.

## 2. Acknowledgement

[Add acknowledgements after the project guide and contributors are known.]

## 3. Abstract

Style Hub is a fashion-shopping application developed with Flutter and Dart to bring product discovery, search, category filtering, product details, wishlist management, cart operations and a simulated checkout into one responsive interface. The source implementation uses Provider and ChangeNotifier for shared cart and wishlist state and local widget state for search and category selection. Product catalog data is requested from fashion categories in the DummyJSON sample API and decoded into a product model. A clearly labelled local demonstration catalog is used when the API cannot supply products. The checkout form validates a name, email address, delivery address and postal code before showing a simulated order confirmation; no payment or shipment is created. A compact Style Picks section sorts the visible collection by listed price and describes that rule plainly. Source files, deterministic model and state tests, a Dart fundamentals demonstration a named-route widget check, a Dart fundamentals demonstration and a README mapping the implementation to the ten CS506PC lab experiments have been prepared. At the time of this draft, the installed Flutter/Dart launcher does not complete commands in this environment, so analysis, tests, builds, runtime behavior and screenshots are not yet verified. The DOCX renderer is also unavailable, so this draft remains in Markdown pending final implementation checks and template-based DOCX rendering.

## 4. Introduction

Mobile commerce interfaces need to make product discovery and shopping actions easy to understand on different screen sizes. Flutter provides a widget-based way to build such interfaces and to demonstrate responsive layouts, navigation, shared state, forms, API integration and UI testing in one application. Style Hub applies those course concepts to a compact fashion-shopping flow rather than splitting the experiments into unrelated applications.

## 5. Objectives of the Project

- Build one Flutter application that demonstrates the ten CS506PC UI Design lab experiment areas.
- Support product browsing, search, category filters, product details and explainable product suggestions.
- Keep wishlist and cart state synchronized across screens.
- Calculate quantities and totals and validate a demonstration checkout form.
- Integrate a public sample product API with a local offline demonstration fallback.
- Document the implementation and its verification accurately.

## 6. Problem Statement and Scope

**Problem statement:** A small educational commerce prototype needs to show a complete, understandable shopping journey while demonstrating practical Flutter UI concepts in one maintainable project.

**Scope:** The source includes a fashion catalog interface, search and category filtering, product details, wishlist, cart quantity controls, subtotal and total calculation, checkout validation and simulated confirmation. It includes responsive breakpoints, Material 3 light and dark themes, reusable widgets, a fading product-count transition, image fallbacks, route navigation, loading and offline states, and a price-based Style Picks rule. It does not implement accounts, live inventory, real payments, transaction processing, order fulfilment or persistent storage. DummyJSON is sample data, not a real merchant catalog; local fallback entries are demo content.

## 7. Tools and Technologies Used

| Tool / technology | Purpose | Version / details |
| --- | --- | --- |
| Flutter | UI framework and target application | Installed under `C:\src\flutter`; CLI commands currently stall |
| Dart | Application language and standalone basics example | SDK reports 3.13.4; script execution currently blocked |
| Provider / ChangeNotifier | Shared shopping state | Declared in `pubspec.yaml`; package resolution unverified |
| `http` | REST API requests | Declared in `pubspec.yaml`; package resolution unverified |
| DummyJSON Products API | Sample fashion catalog source | Eight category endpoints queried successfully on 24 October 2026 |
| Git | Local milestone history | Repository initialized; first commit created |

## 8. System Design and Methodology

The interface calls a catalog repository that requests the fashion categories `tops`, `mens-shirts`, `mens-shoes`, `womens-dresses`, `womens-shoes`, `womens-bags`, `womens-jewellery` and `sunglasses`. Responses are parsed into `Product` records and combined by ID. `ShopState` owns catalog loading, cart quantities and wishlist membership. Screens consume shared state through Provider. The checkout uses form validators and constructs an order summary for a simulated confirmation.

```text
DummyJSON fashion category endpoints
                 |
          CatalogRepository
                 |
       Product model and filters
                 |
     Provider / ShopState
       /      |        \
 Discover  Wishlist   Cart -> Checkout -> Demo confirmation
                 \
      labelled offline demonstration catalog
```

The project was started by inspecting the supplied course plan, lab manual and project-report template, then creating a Flutter package skeleton and implementing the application source and evidence plan. Formatting and runtime verification could not be completed because of the local SDK launcher issue described in Section 12.

## 9. Day-Wise Progress Report

| Day | Activities actually performed | Deliverables / outcomes |
| --- | --- | --- |
| 24 October 2026 | Read the course plan, lab manual and report format; inspected the empty Style Hub workspace; initialized local Git; authored application, catalog, state, form-validation, filter, test and Dart demonstration source; queried the sample API endpoints. | Initial local commit `870f23a`; application and test source authored; API category endpoints returned sample product data. Flutter tests and runtime were not verified. |

Further dates and activities will be added after they occur; none are assumed here.

## 10. Implementation and Results

The implementation source is organized in `lib/main.dart` and `lib/src/`. The home screen uses a responsive grid and category chips. Named routes connect discovery, product details, wishlist, cart, checkout and confirmation. The shared state class supports adding and removing favorites, increasing and decreasing cart quantities, and calculating totals. Checkout validation is factored into reusable functions. The product repository requests eight apparel-related API categories; on 24 October 2026, direct HTTP queries returned successful responses with 3–5 products per category and fields including `id`, `title`, `description`, `category`, numeric `price`, `thumbnail` and `images`. The sample schema did not include a currency field, so the interface uses neutral numeric amounts and identifies the currency as unspecified.

Tests have been authored for model parsing, API response and HTTP failure handling, cart totals, wishlist updates, offline fallback, product filtering, Style Picks sorting, checkout field validation and an empty-state widget. These tests have not run. `flutter test` and `flutter analyze` were each interrupted after 20 seconds without output. `dart format` reports that DartDev cannot resolve `Platform.resolvedExecutable`; Flutter tool startup similarly produces no output. The source has therefore not been confirmed by compilation or execution, and screenshots have not been captured.

## 11. Learning Outcomes

The source demonstrates how Flutter widgets can compose responsive shopping screens, how named routes pass product and order data, how Provider and ChangeNotifier share cart and wishlist state, how form validators expose field-level errors, and how a REST response can be parsed into a model with a local fallback. These are implementation outcomes represented in source; runtime learning and demonstration should be recorded after successful execution.

## 12. Challenges Faced and Solutions

| Challenge | Action / solution | Outcome |
| --- | --- | --- |
| The first 50 default DummyJSON products did not contain the selected fashion categories. | Queried the documented per-category endpoints and changed the repository to request those categories directly. | Eight fashion endpoints returned data in the direct API check. |
| Flutter/Dart commands did not produce output; direct formatter invocation failed inside DartDev. | Tried the Flutter and Dart launchers and recorded the error. Avoided modifying the SDK installation. | Analysis, tests, formatting, builds and app screenshots remain unverified. |
| DOCX rendering requires LibreOffice, which is not available in the configured runtime paths. | Kept report content as editable Markdown using the college template's section structure. | DOCX generation and visual template QA remain pending. |

## 13. Conclusion and Future Scope

The project source currently contains the planned core shopping flow and course concept mapping. The intended acceptance outcome has not yet been verified because Flutter cannot be run in this environment. Next, use a working Flutter SDK to resolve dependencies, format and analyze the source, run the tests, launch the app at narrow and wide sizes, capture genuine screenshots, fix any reported issues, complete the actual progress record and render the report in the supplied DOCX format. Future scope may include local persistence and a production catalog service after the educational demonstration is validated.

## 14. References

1. ACE Engineering College, *CS506PC: UI Design-Flutter*, course plan, 2026.
2. ACE Engineering College, *UI Design – Flutter Lab Manual*, 2026.
3. ACE Engineering College, *One-Week Technical Project Report*, supplied template.
4. DummyJSON, [Products API documentation](https://dummyjson.com/docs/products), accessed 24 October 2026.
5. Flutter, [official documentation](https://docs.flutter.dev/).

## 15. Appendices and Supporting Evidence

- Source repository files: `lib/main.dart`, `lib/src/product.dart`, `lib/src/catalog.dart`, `lib/src/shop_state.dart`, `lib/src/product_filters.dart`, and `lib/src/checkout_validation.dart`.
- Tests authored: `test/style_hub_test.dart`, `test/product_filters_test.dart`, and `test/widgets_test.dart`; execution results are pending.
- Standalone Dart basics example: `tool/dart_basics.dart`; execution is pending.
- Genuine application and code screenshots: not yet available; capture after Flutter runtime is restored.
- README experiment mapping: `README.md`.

## 16. Mentor Evaluation Sheet

**Student name(s):** ______________________________<br>
**Project title:** Style Hub: A Responsive Fashion Shopping Application Using Flutter<br>
**Mentor name:** __________________________________

**Mentor remarks:** ________________________________________________________

**Mentor signature:** ____________________  **Date:** ____________________

**HoD signature:** ____________________

Marks and signatures are intentionally blank for the college and mentor to complete.
