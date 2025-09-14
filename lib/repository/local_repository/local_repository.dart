import 'dart:convert';

import 'package:infinite_list_and_search/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepository {
  Future<void> saveFavoriteProduct({required Product product});

  Future<void> removeFavoriteProduct({required int productId});

  Future<List<Product>> getFavoriteProducts();
}

class LocalRepositoryImpl extends LocalRepository {
  @override
  Future<List<Product>> getFavoriteProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteProducts = prefs.getString('favorite_products');

      if (favoriteProducts != null) {
        final List<dynamic> decodedList = jsonDecode(favoriteProducts);
        return decodedList.map((e) => Product.from(e)).toList();
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Failed to load favorite products: $error');
    }
  }

  @override
  Future<void> removeFavoriteProduct({required int productId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final favoriteProducts = prefs.getString('favorite_products');

      if (favoriteProducts != null) {
        final List<dynamic> decodedList = jsonDecode(favoriteProducts);
        final updatedList = decodedList
            .where((e) => e['id'] != productId)
            .toList();
        await prefs.setString('favorite_products', jsonEncode(updatedList));
      }
    } catch (error) {
      throw Exception('Failed to remove favorite product: $error');
    }
  }

  @override
  Future<void> saveFavoriteProduct({required Product product}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final favoriteProducts = prefs.getString('favorite_products');

      List<dynamic> decodedList = [];
      if (favoriteProducts != null) {
        decodedList = jsonDecode(favoriteProducts);
      }

      if (!decodedList.any((e) => e['id'] == product.id)) {
        decodedList.add(product.toJson());
        await prefs.setString('favorite_products', jsonEncode(decodedList));
      }
    } catch (error) {
      throw Exception('Failed to save favorite product: $error');
    }
  }
}
