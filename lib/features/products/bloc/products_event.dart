part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object> get props => [];
}

class ProductsInit extends ProductsEvent {
  const ProductsInit();
  @override
  List<Object> get props => [];
}

class ProductsFetched extends ProductsEvent {
  const ProductsFetched();
  @override
  List<Object> get props => [];
}

class FavorireProductsFetched extends ProductsEvent {
  const FavorireProductsFetched();
  @override
  List<Object> get props => [];
}

class ProductsLoadedMore extends ProductsEvent {
  const ProductsLoadedMore();
  @override
  List<Object> get props => [];
}

class ProductsSearched extends ProductsEvent {
  final String query;
  const ProductsSearched({required this.query});
  @override
  List<Object> get props => [query];
}

class ProductsReloaded extends ProductsEvent {
  const ProductsReloaded();
  @override
  List<Object> get props => [];
}

class ProductFavoriteAdded extends ProductsEvent {
  final Product product;
  const ProductFavoriteAdded({required this.product});
  @override
  List<Object> get props => [product];
}

class ProductFavoriteRemoved extends ProductsEvent {
  final int productId;
  const ProductFavoriteRemoved({required this.productId});
  @override
  List<Object> get props => [productId];
}
