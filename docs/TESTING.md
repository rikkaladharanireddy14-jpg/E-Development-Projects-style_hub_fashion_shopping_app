# Style Hub Testing Guide

## Purpose

This guide explains how to run automated tests and static analysis for
the Style Hub Flutter fashion-shopping application.

## Prerequisites

- Flutter SDK installed
- Project dependencies installed
- Terminal opened in the project directory

Install dependencies:

```bash
flutter pub get
```

## Run the Complete Test Suite

```bash
flutter test
```

Run the complete test suite after code changes to check that existing
functionality continues to work.

## Run Individual Test Files

```bash
flutter test test/catalog_test.dart
flutter test test/catalog_empty_response_test.dart
flutter test test/catalog_invalid_response_test.dart
flutter test test/catalog_malformed_products_test.dart
flutter test test/catalog_categories_test.dart
flutter test test/shop_state_test.dart
flutter test test/shop_state_multi_product_test.dart
flutter test test/shop_state_remove_notification_test.dart
flutter test test/shop_state_views_test.dart
flutter test test/shop_state_notifications_test.dart
flutter test test/shop_state_catalog_test.dart
flutter test test/shop_state_catalog_failure_test.dart
flutter test test/shop_state_catalog_recovery_test.dart
flutter test test/wishlist_test.dart
flutter test test/product_model_test.dart
flutter test test/product_filters_test.dart
flutter test test/widgets_test.dart
```

Run only test files that exist in the project.

## Areas Covered

- Successful catalog loading and server errors
- Empty and malformed API responses
- Partial catalog failures and duplicate product IDs
- Requests for configured fashion categories
- Local catalog fallback and loading-state recovery
- Product JSON parsing
- Cart quantities, totals, item removal, and clearing
- Calculations involving multiple products
- Wishlist additions and removals
- Shared-state notifications and read-only collection views
- Product filtering and checkout validation
- Widget behavior and navigation

## Static Analysis

Run:

```bash
flutter analyze
```

Resolve errors and warnings before submission. Review informational lint suggestions separately.

## Before Pushing

1. Run the relevant focused tests.
2. Run the complete suite with `flutter test`.
3. Review changes using `git status`.
4. Create commits with descriptive messages.
5. Push the verified commits to GitHub.

Record test results only after the corresponding commands have completed successfully.