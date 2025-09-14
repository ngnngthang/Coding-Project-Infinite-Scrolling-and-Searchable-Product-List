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
  }

  final ProductsRepository _repo = ProductRepositoryImpl();

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
}
