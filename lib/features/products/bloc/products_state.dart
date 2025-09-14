part of 'products_bloc.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.init,
    this.favoriteListStatus = ProductsStatus.init,
    this.actionStatus = ProductActionStatus.init,
    required this.products,
    this.favoriteProducts = const [],
    this.hasReachedMax = false,
    this.page = 0,
    this.limit = 20,
    this.query = '',
    this.error,
  });

  final ProductsStatus status;
  final ProductsStatus favoriteListStatus;
  final ProductActionStatus actionStatus;
  final List<Product> products;
  final List<Product> favoriteProducts;
  final bool hasReachedMax;
  final int page;
  final int limit;
  final String query;
  final String? error;

  ProductsState copyWith({
    ProductsStatus? status,
    ProductsStatus? favoriteListStatus,
    ProductActionStatus? actionStatus,
    List<Product>? products,
    List<Product>? favoriteProducts,
    bool? hasReachedMax,
    int? page,
    int? limit,
    String? query,
    String? error,
  }) {
    return ProductsState(
      status: status ?? this.status,
      favoriteListStatus: favoriteListStatus ?? this.favoriteListStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      products: products ?? this.products,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      query: query ?? this.query,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favoriteListStatus,
    actionStatus,
    products,
    favoriteProducts,
    hasReachedMax,
    page,
    limit,
    query,
    error,
  ];
}

enum ProductsStatus { init, loading, success, error, loadingMore }

enum ProductActionStatus { init, adding, added, removing, removed, error }

extension ProductsStatusX on ProductsStatus {
  bool get isInit => this == ProductsStatus.init;
  bool get isLoading => this == ProductsStatus.loading;
  bool get isSuccess => this == ProductsStatus.success;
  bool get isError => this == ProductsStatus.error;
  bool get isLoadingMore => this == ProductsStatus.loadingMore;
}

extension ProductActionStatusX on ProductActionStatus {
  bool get isinit => this == ProductActionStatus.init;
  bool get isAdding => this == ProductActionStatus.adding;
  bool get isAdded => this == ProductActionStatus.added;
  bool get isRemoving => this == ProductActionStatus.removing;
  bool get isRemoved => this == ProductActionStatus.removed;
  bool get isError => this == ProductActionStatus.error;
}
