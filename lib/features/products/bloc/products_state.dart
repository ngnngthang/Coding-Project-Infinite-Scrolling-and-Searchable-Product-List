part of 'products_bloc.dart';

enum ProductsStatus { init, loading, success, error, loadingMore }

extension ProductsStatusX on ProductsStatus {
  bool get isInit => this == ProductsStatus.init;
  bool get isLoading => this == ProductsStatus.loading;
  bool get isSuccess => this == ProductsStatus.success;
  bool get isError => this == ProductsStatus.error;
  bool get isLoadingMore => this == ProductsStatus.loadingMore;
}

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.init,
    required this.products,
    this.hasReachedMax = false,
    this.page = 0,
    this.limit = 20,
    this.query = '',
  });

  final ProductsStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final int page;
  final int limit;
  final String query;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
    int? page,
    int? limit,
    String? query,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [
    status,
    products,
    hasReachedMax,
    page,
    limit,
    query,
  ];
}
