import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list_and_search/models/models.dart';
import 'package:infinite_list_and_search/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

part 'products_event.dart';
part 'products_state.dart';

const throttleDuration = Duration(milliseconds: 100);
const debounceDuration = Duration(milliseconds: 500);

EventTransformer<E> throttleTransformer<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttleTime(duration), mapper);
  };
}

EventTransformer<E> debounceTransformer<E>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(debounceDuration).flatMap(mapper);
  };
}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState(products: Product.dummy())) {
    on<ProductsInit>(_onInit);
    on<ProductsFetched>(_onProductsFetch);
    on<ProductsLoadedMore>(
      _onProductsLoadMore,
      transformer: throttleTransformer(throttleDuration),
    );
    on<ProductsSearched>(
      _onProductsSeach,
      transformer: debounceTransformer(debounceDuration),
    );
    on<ProductsReloaded>(_onProductsReload);
    on<FavorireProductsFetched>(_onFavorireProductsFetch);
    on<ProductFavoriteAdded>(_onProductFavoriteAdd);
    on<ProductFavoriteRemoved>(_onProductFavoriteRemove);
  }

  final ProductsRepository _repo = ProductRepositoryImpl();
  final LocalRepository _localRepo = LocalRepositoryImpl();

  Future<void> _onInit(ProductsInit event, Emitter<ProductsState> emit) async {
    add(const ProductsFetched());
    add(const FavorireProductsFetched());
  }

  Future<void> _onProductsFetch(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    try {
      final response = await _repo.getProducts(
        page: state.page,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: response,
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductsStatus.error));
      rethrow;
    }
  }

  Future<void> _onProductsSeach(
    ProductsSearched event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(query: event.query));

    try {
      final response = await _repo.getProducts(
        page: 0,
        limit: state.limit,
        query: event.query,
      );

      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: response,
          page: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductsStatus.error));
    }
  }

  Future<void> _onProductsLoadMore(
    ProductsLoadedMore event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loadingMore));

    try {
      final response = await _repo.getProducts(
        page: state.page,
        limit: state.limit,
        query: state.query.isNotEmpty ? state.query : null,
      );

      if (response.isEmpty) {
        emit(
          state.copyWith(status: ProductsStatus.success, hasReachedMax: true),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: [...state.products, ...response],
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductsStatus.error));
      rethrow;
    }
  }

  Future<void> _onProductsReload(
    ProductsReloaded event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading, page: 0, query: ''));

    try {
      final response = await _repo.getProducts(page: 0, limit: state.limit);

      emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: response,
          page: 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductsStatus.error));
      rethrow;
    }
  }

  Future<void> _onFavorireProductsFetch(
    FavorireProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(favoriteListStatus: ProductsStatus.loading));

      final favorites = await _localRepo.getFavoriteProducts();
      print(favorites);

      emit(
        state.copyWith(
          favoriteListStatus: ProductsStatus.success,
          favoriteProducts: favorites,
        ),
      );
    } catch (error) {
      emit(state.copyWith(actionStatus: ProductActionStatus.error));
    }
  }

  Future<void> _onProductFavoriteAdd(
    ProductFavoriteAdded event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(actionStatus: ProductActionStatus.adding));

      final updatedFavorites = List<Product>.from(state.favoriteProducts);

      if (!updatedFavorites.contains(event.product)) {
        updatedFavorites.add(event.product);
        await _localRepo.saveFavoriteProduct(product: event.product);
      }

      emit(
        state.copyWith(
          actionStatus: ProductActionStatus.added,
          favoriteProducts: updatedFavorites,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: ProductActionStatus.error,
          error: 'Failed to add favorite product',
        ),
      );
      rethrow;
    }
  }

  Future<void> _onProductFavoriteRemove(
    ProductFavoriteRemoved event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(actionStatus: ProductActionStatus.removing));

      final updatedFavorites = state.favoriteProducts
          .where((product) => product.id != event.productId)
          .toList();

      await _localRepo.removeFavoriteProduct(productId: event.productId);

      emit(
        state.copyWith(
          actionStatus: ProductActionStatus.removed,
          favoriteProducts: updatedFavorites,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: ProductActionStatus.error,
          error: 'Failed to remove favorite product',
        ),
      );
    }
  }
}
