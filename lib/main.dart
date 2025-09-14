import 'package:flutter/material.dart';
import 'package:infinite_list_and_search/data/http_client.dart';
import 'package:infinite_list_and_search/features/products/view/products_screen.dart';

Future<void> main() async {
  await NetworkClient(baseUrl: 'https://dummyjson.com').initClient();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
