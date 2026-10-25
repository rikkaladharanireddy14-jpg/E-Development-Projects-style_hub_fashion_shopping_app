\# Style Hub Testing Guide



\## Purpose



This guide explains how to run automated tests and static analysis for the Style Hub Flutter application.



\## Prerequisites



\- Flutter SDK installed

\- Project dependencies installed

\- Terminal opened in the project directory



Install dependencies:



```bash

flutter pub get

```



\## Run All Tests



```bash

flutter test

```



Run the complete test suite after making changes to verify existing functionality.



\## Run Individual Test Files



```bash

flutter test test/catalog\_test.dart

flutter test test/shop\_state\_test.dart

flutter test test/wishlist\_test.dart

flutter test test/shop\_state\_notifications\_test.dart

flutter test test/shop\_state\_catalog\_test.dart

flutter test test/product\_model\_test.dart

flutter test test/product\_filters\_test.dart

flutter test test/widgets\_test.dart

```



\## Test Coverage



The test suite includes checks for:



\- Catalog API success and failure handling

\- Partial catalog failures and duplicate products

\- Local demonstration catalog fallback

\- Product JSON parsing

\- Cart quantities, totals, removal, and clearing

\- Wishlist add/remove behavior

\- Shared-state notifications

\- Product filtering and checkout validation

\- Widget behavior and navigation



\## Static Analysis



Run:



```bash

flutter analyze

```



Fix errors and warnings before submission. Review informational lint suggestions separately.



\## Before Pushing



1\. Run the relevant individual tests.

2\. Run the full suite with `flutter test`.

3\. Review changes using `git status`.

4\. Commit changes with descriptive messages.

5\. Push the completed batch to GitHub.



Record test results only after the relevant commands finish successfully.# Style Hub Testing Guide



\## Purpose



This guide explains how to run automated tests and static analysis for the Style Hub Flutter application.



\## Prerequisites



\- Flutter SDK installed

\- Project dependencies installed

\- Terminal opened in the project directory



Install dependencies:



```bash

flutter pub get

```



\## Run All Tests



```bash

flutter test

```



Run the complete test suite after making changes to verify existing functionality.



\## Run Individual Test Files



```bash

flutter test test/catalog\_test.dart

flutter test test/shop\_state\_test.dart

flutter test test/wishlist\_test.dart

flutter test test/shop\_state\_notifications\_test.dart

flutter test test/shop\_state\_catalog\_test.dart

flutter test test/product\_model\_test.dart

flutter test test/product\_filters\_test.dart

flutter test test/widgets\_test.dart

```



\## Test Coverage



The test suite includes checks for:



\- Catalog API success and failure handling

\- Partial catalog failures and duplicate products

\- Local demonstration catalog fallback

\- Product JSON parsing

\- Cart quantities, totals, removal, and clearing

\- Wishlist add/remove behavior

\- Shared-state notifications

\- Product filtering and checkout validation

\- Widget behavior and navigation



\## Static Analysis



Run:



```bash

flutter analyze

```



Fix errors and warnings before submission. Review informational lint suggestions separately.



\## Before Pushing



1\. Run the relevant individual tests.

2\. Run the full suite with `flutter test`.

3\. Review changes using `git status`.

4\. Commit changes with descriptive messages.

5\. Push the completed batch to GitHub.



Record test results only after the relevant commands finish successfully.ter test

