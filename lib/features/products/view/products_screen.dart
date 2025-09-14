import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list_and_search/features/products/bloc/products_bloc.dart';
import 'package:infinite_list_and_search/features/products/components/product_list.dart';
import 'package:infinite_list_and_search/features/products/components/product_search_input.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc()..add(ProductsInit()),
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
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? 'Something went wrong'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.actionStatus.isAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to favorites'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            if (state.actionStatus.isRemoved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product removed from favorites'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
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
                        favoriteItems: state.favoriteProducts,
                        onLoadMore: () {
                          bloc.add(ProductsLoadedMore());
                        },
                        onRefresh: () {
                          bloc.add(ProductsReloaded());
                        },
                        canLoadMore: !state.hasReachedMax,
                        onAddToFavorite: (product) {
                          bloc.add(ProductFavoriteAdded(product: product));
                        },
                        onRemoveFromFavorite: (productId) {
                          bloc.add(
                            ProductFavoriteRemoved(productId: productId),
                          );
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
