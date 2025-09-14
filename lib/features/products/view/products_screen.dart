import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list_and_search/components/inputs/text_input.dart';
import 'package:infinite_list_and_search/features/products/bloc/products_bloc.dart';
import 'package:infinite_list_and_search/features/products/components/product_list.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc()..add(ProductsFetched()),
      child: const ProductView(),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductsBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.primaries.first,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocListener<ProductsBloc, ProductsState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {},
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: <Widget>[
                BlocBuilder<ProductsBloc, ProductsState>(
                  buildWhen: (previous, current) =>
                      previous.query != current.query,
                  builder: (context, state) {
                    return ProductSearchInput(
                      onClearText: () {
                        bloc.add(ProductsSearched(query: ''));
                      },
                      onChanged: (value) {
                        bloc.add(ProductsSearched(query: value));
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      return ProductList(
                        isLoading:
                            state.status.isLoading || state.status.isInit,
                        isLoadingMore: state.status.isLoadingMore,
                        items: state.products,
                        onLoadMore: () {
                          bloc.add(ProductsLoadedMore());
                        },
                        onRefresh: () {
                          bloc.add(ProductsReloaded());
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductSearchInput extends StatefulWidget {
  const ProductSearchInput({super.key, this.onChanged, this.onClearText});

  final Function(String)? onChanged;
  final VoidCallback? onClearText;

  @override
  State<ProductSearchInput> createState() => _ProductSearchInputState();
}

class _ProductSearchInputState extends State<ProductSearchInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    setState(() {});
  }

  void _clearText() {
    _controller.clear();
    widget.onClearText?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: _controller,
      hintText: 'Search products...',
      onChanged: _onChanged,
      prefix: Icon(Icons.search, size: 20, color: Colors.black87),
      suffix: _controller.text.isNotEmpty
          ? IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              onPressed: _clearText,
              icon: Icon(Icons.clear, size: 20, color: Colors.black87),
            )
          : null,
    );
  }
}
