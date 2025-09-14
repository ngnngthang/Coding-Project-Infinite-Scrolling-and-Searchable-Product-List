import 'package:infinite_list_and_search/data/http_client.dart';
import 'package:infinite_list_and_search/models/models.dart';
import 'package:infinite_list_and_search/repository/repository.dart';
import 'package:infinite_list_and_search/utils/utils.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({
    required int page,
    required int limit,
    String? query,
  });
}

class ProductRepositoryImpl extends ProductsRepository {
  ProductRepositoryImpl();
  final NetworkClient _client = NetworkClient.instance;

  @override
  Future<List<Product>> getProducts({
    required int page,
    required int limit,
    String? query,
  }) async {
    try {
      String url = ProductsQueries.products;
      final queries = <String, dynamic>{'skip': page * limit, 'limit': limit};

      if (query != null && query.isNotEmpty) {
        queries['q'] = query;
        url += '/search${buildQueryString(queries)}';
      } else {
        url = ProductsQueries.products + buildQueryString(queries);
      }

      final response = await _client.get(url);

      if (response['products'] == null) {
        throw Exception('Products not found');
      }

      return (response['products'] as List)
          .map((e) => Product.from(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
