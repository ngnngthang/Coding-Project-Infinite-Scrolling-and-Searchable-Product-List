import 'package:flutter/material.dart';
import 'package:infinite_list_and_search/features/products/components/product_item.dart';
import 'package:infinite_list_and_search/models/models.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    super.key,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.onLoadMore,
    this.onRefresh,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final List<Product> items;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRefresh;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      widget.onLoadMore?.call();
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: widget.items.isEmpty && !widget.isLoading
          ? const EmptyProductList()
          : Skeletonizer(
              enabled: widget.isLoading,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= widget.items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ProductItem(product: widget.items[index]);
                },
              ),
            ),
    );
  }
}

class EmptyProductList extends StatelessWidget {
  const EmptyProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.remove_shopping_cart_rounded,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
