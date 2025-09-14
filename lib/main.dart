import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list_and_search/app/blocs/bloc/connectivity_bloc.dart';
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
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ConnectivityBloc(),
        child: BlocListener<ConnectivityBloc, ConnectivityState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case ConnectivityStatus.connected:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connected to the internet'),
                    backgroundColor: Colors.green,
                  ),
                );
                break;
              case ConnectivityStatus.none:
              case ConnectivityStatus.unknown:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No internet connection'),
                    backgroundColor: Colors.red,
                  ),
                );
                break;
            }
          },
          child: const ProductsScreen(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
