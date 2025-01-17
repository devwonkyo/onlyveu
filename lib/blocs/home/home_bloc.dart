import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlyveyou/models/home_model.dart';
import 'package:onlyveyou/models/product_model.dart';
import 'package:onlyveyou/repositories/home/home_repository.dart';
import 'package:onlyveyou/repositories/shopping_cart_repository.dart';

// 이벤트 정의
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class LoadMoreProducts extends HomeEvent {}

class ToggleProductFavorite extends HomeEvent {
  final ProductModel product;
  final String userId;
  ToggleProductFavorite(this.product, this.userId);
}

class AddToCart extends HomeEvent {
  final String productId;
  AddToCart(this.productId); // userId 제거
}

// 상태 정의 (이전과 동일)
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeSuccess extends HomeState {
  final String message;
  HomeSuccess(this.message);
}

class HomeLoaded extends HomeState {
  final List<BannerItem> bannerItems;
  final List<ProductModel> recommendedProducts;
  final List<ProductModel> popularProducts;
  final bool isLoading;

  HomeLoaded({
    required this.bannerItems,
    required this.recommendedProducts,
    required this.popularProducts,
    this.isLoading = false,
  });

  HomeLoaded copyWith({
    List<BannerItem>? bannerItems,
    List<ProductModel>? recommendedProducts,
    List<ProductModel>? popularProducts,
    bool? isLoading,
  }) {
    return HomeLoaded(
      bannerItems: bannerItems ?? this.bannerItems,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      popularProducts: popularProducts ?? this.popularProducts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// HomeBloc 구현
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final ShoppingCartRepository _cartRepository;

  HomeBloc({
    required HomeRepository homeRepository,
    required ShoppingCartRepository cartRepository, // 추가
  })  : _homeRepository = homeRepository,
        _cartRepository = cartRepository, // 추가
        super(HomeInitial()) {
    // LoadHomeData 이벤트 핸들러
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        final bannerItems = _homeRepository.getBannerItems();
        final recommendedProducts =
            await _homeRepository.getRecommendedProducts();
        final popularProducts = await _homeRepository.getPopularProducts();

        emit(HomeLoaded(
          bannerItems: bannerItems,
          recommendedProducts: recommendedProducts,
          popularProducts: popularProducts,
        ));
      } catch (e) {
        print('Error loading home data: $e');
        emit(HomeError('데이터를 불러오는데 실패했습니다.'));
      }
    });

    // 좋아요 부분
    on<ToggleProductFavorite>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        try {
          await _homeRepository.toggleProductFavorite(
              event.product.productId, event.userId);

          // 추천 상품 목록 업데이트
          final updatedRecommended =
              currentState.recommendedProducts.map((product) {
            if (product.productId == event.product.productId) {
              List<String> updatedFavoriteList =
                  List<String>.from(product.favoriteList);
              if (updatedFavoriteList.contains(event.userId)) {
                updatedFavoriteList.remove(event.userId);
              } else {
                updatedFavoriteList.add(event.userId);
              }
              return product.copyWith(favoriteList: updatedFavoriteList);
            }
            return product;
          }).toList();

          // 인기 상품 목록 업데이트
          final updatedPopular = currentState.popularProducts.map((product) {
            if (product.productId == event.product.productId) {
              List<String> updatedFavoriteList =
                  List<String>.from(product.favoriteList);
              if (updatedFavoriteList.contains(event.userId)) {
                updatedFavoriteList.remove(event.userId);
              } else {
                updatedFavoriteList.add(event.userId);
              }
              return product.copyWith(favoriteList: updatedFavoriteList);
            }
            return product;
          }).toList();

          emit(HomeLoaded(
            bannerItems: currentState.bannerItems,
            recommendedProducts: updatedRecommended,
            popularProducts: updatedPopular,
          ));
        } catch (e) {
          print('Error toggling favorite: $e');
        }
      }
    });
    // RefreshHomeData 이벤트 핸들러
    on<RefreshHomeData>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(isLoading: true));

        try {
          add(LoadHomeData());
        } catch (e) {
          print('Error refreshing data: $e');
          emit(HomeError('새로고침에 실패했습니다.'));
        }
      }
    });

    // LoadMoreProducts 이벤트 핸들러
    on<LoadMoreProducts>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(isLoading: true));

        try {
          final lastProduct = currentState.recommendedProducts.last;
          final newProducts =
              await _homeRepository.getMoreProducts(lastProduct.productId);

          emit(currentState.copyWith(
            recommendedProducts: [
              ...currentState.recommendedProducts,
              ...newProducts
            ],
            isLoading: false,
          ));
        } catch (e) {
          print('Error loading more products: $e');
          emit(currentState.copyWith(isLoading: false));
        }
      }
    });
    on<AddToCart>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        try {
          await _cartRepository.addToCart(event.productId);
          emit(HomeSuccess('장바구니에 담겼습니다.')); // 성공 상태 추가
          emit(currentState);
        } catch (e) {
          emit(HomeError(e.toString()));
          emit(currentState);
        }
      }
    });
  }
}
