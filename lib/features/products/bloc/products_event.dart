part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object> get props => [];
}

class ProductsFetched extends ProductsEvent {
  @override
  List<Object> get props => [];
}

class ProductsLoadedMore extends ProductsEvent {
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
  @override
  List<Object> get props => [];
}
