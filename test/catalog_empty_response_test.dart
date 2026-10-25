import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';

void main() {
  test('empty category responses produce a catalog error', () async {
    final client = MockClient((request) async {
      return http.Response('{"products":[]}', 200);
    });

    final repository = CatalogRepository(client: client);

    try {
      await expectLater(
        repository.fetchProducts(),
        throwsA(isA<CatalogException>()),
      );
    } finally {
      repository.close();
    }
  });
}