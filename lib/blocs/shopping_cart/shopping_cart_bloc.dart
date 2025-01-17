import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlyveyou/models/cart_model.dart';
import 'package:onlyveyou/models/order_model.dart';
import 'package:onlyveyou/repositories/shopping_cart_repository.dart';
import 'package:onlyveyou/utils/shared_preference_util.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class UpdateItemSelection extends CartEvent {
  final String productId;
  final bool isSelected;
  const UpdateItemSelection(this.productId, this.isSelected);
  @override
  List<Object> get props => [productId, isSelected];
}

class UpdateItemQuantity extends CartEvent {
  final String productId;
  final bool increment;
  final bool isPickup;
  const UpdateItemQuantity(this.productId, this.increment, this.isPickup);
  @override
  List<Object> get props => [productId, increment, isPickup];
}

class RemoveItem extends CartEvent {
  final String productId;
  final bool isPickup;
  const RemoveItem(this.productId, this.isPickup);
  @override
  List<Object> get props => [productId, isPickup];
}

class SelectAllItems extends CartEvent {
  final bool value;
  final bool isPickup;
  const SelectAllItems(this.value, this.isPickup);
  @override
  List<Object> get props => [value, isPickup];
}

class DeleteSelectedItems extends CartEvent {
  final bool isPickup;
  const DeleteSelectedItems(this.isPickup);
  @override
  List<Object> get props => [isPickup];
}

class MoveToPickup extends CartEvent {
  final List<String> productIds;
  const MoveToPickup(this.productIds);
  @override
  List<Object> get props => [productIds];
}

class MoveToRegularDelivery extends CartEvent {
  final List<String> productIds;
  const MoveToRegularDelivery(this.productIds);
  @override
  List<Object> get props => [productIds];
}

class UpdateCurrentTab extends CartEvent {
  final bool isRegularDelivery;
  const UpdateCurrentTab(this.isRegularDelivery);
  @override
  List<Object> get props => [isRegularDelivery];
}

// State
class CartState extends Equatable {
  final List<CartModel> regularDeliveryItems;
  final List<CartModel> pickupItems;
  final Map<String, bool> selectedItems;
  final Map<String, int> itemQuantities;
  final bool isAllSelected;
  final bool isLoading;
  final String? error;
  final bool isRegularDeliveryTab;

  const CartState({
    this.regularDeliveryItems = const [],
    this.pickupItems = const [],
    this.selectedItems = const {},
    this.itemQuantities = const {},
    this.isAllSelected = true,
    this.isLoading = false,
    this.error,
    this.isRegularDeliveryTab = true,
  });

  CartState copyWith({
    List<CartModel>? regularDeliveryItems,
    List<CartModel>? pickupItems,
    Map<String, bool>? selectedItems,
    Map<String, int>? itemQuantities,
    bool? isAllSelected,
    bool? isLoading,
    String? error,
    bool? isRegularDeliveryTab,
  }) {
    return CartState(
      regularDeliveryItems: regularDeliveryItems ?? this.regularDeliveryItems,
      pickupItems: pickupItems ?? this.pickupItems,
      selectedItems: selectedItems ?? this.selectedItems,
      itemQuantities: itemQuantities ?? this.itemQuantities,
      isAllSelected: isAllSelected ?? this.isAllSelected,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRegularDeliveryTab: isRegularDeliveryTab ?? this.isRegularDeliveryTab,
    );
  }

  @override
  List<Object?> get props => [
        regularDeliveryItems,
        pickupItems,
        selectedItems,
        itemQuantities,
        isAllSelected,
        isLoading,
        error,
        isRegularDeliveryTab,
      ];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final ShoppingCartRepository _cartRepository;

  CartBloc({required ShoppingCartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateItemSelection>(_onUpdateItemSelection);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItem>(_onRemoveItem);
    on<SelectAllItems>(_onSelectAllItems);
    on<DeleteSelectedItems>(_onDeleteSelectedItems);
    on<MoveToPickup>(_onMoveToPickup);
    on<MoveToRegularDelivery>(_onMoveToRegularDelivery);
    on<UpdateCurrentTab>(_onUpdateCurrentTab);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final cartData = await _cartRepository.loadCartItems();

      final initialSelectedItems = Map.fromEntries(
        [...cartData['regular']!, ...cartData['pickup']!]
            .map((item) => MapEntry(item.productId, true)),
      );

      final initialQuantities = Map.fromEntries(
        [...cartData['regular']!, ...cartData['pickup']!]
            .map((item) => MapEntry(item.productId, item.quantity)),
      );

      emit(state.copyWith(
        regularDeliveryItems: cartData['regular'],
        pickupItems: cartData['pickup'],
        selectedItems: initialSelectedItems,
        itemQuantities: initialQuantities,
        isLoading: false,
        isAllSelected: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onUpdateItemSelection(
      UpdateItemSelection event, Emitter<CartState> emit) {
    final updatedSelectedItems = Map<String, bool>.from(state.selectedItems);
    updatedSelectedItems[event.productId] = event.isSelected;

    final currentItems = state.isRegularDeliveryTab
        ? state.regularDeliveryItems
        : state.pickupItems;

    final isAllSelected = currentItems.every(
      (item) => updatedSelectedItems[item.productId] == true,
    );

    emit(state.copyWith(
      selectedItems: updatedSelectedItems,
      isAllSelected: isAllSelected,
    ));
  }

  Future<void> _onUpdateItemQuantity(
      UpdateItemQuantity event, Emitter<CartState> emit) async {
    final updatedQuantities = Map<String, int>.from(state.itemQuantities);
    final currentQuantity = updatedQuantities[event.productId] ?? 1;

    bool quantityUpdated = false;
    if (event.increment && currentQuantity < 99) {
      updatedQuantities[event.productId] = currentQuantity + 1;
      quantityUpdated = true;
    } else if (!event.increment && currentQuantity > 1) {
      updatedQuantities[event.productId] = currentQuantity - 1;
      quantityUpdated = true;
    }

    if (quantityUpdated) {
      try {
        await _cartRepository.updateProductQuantity(
          event.productId,
          updatedQuantities[event.productId]!,
          event.isPickup, // 여기에 isPickup 파라미터 추가
        );
        emit(state.copyWith(itemQuantities: updatedQuantities));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.removeProduct(event.productId, event.isPickup);

      List<CartModel> updatedRegularItems =
          List.from(state.regularDeliveryItems);
      List<CartModel> updatedPickupItems = List.from(state.pickupItems);

      if (event.isPickup) {
        updatedPickupItems
            .removeWhere((item) => item.productId == event.productId);
      } else {
        updatedRegularItems
            .removeWhere((item) => item.productId == event.productId);
      }

      final updatedSelectedItems = Map<String, bool>.from(state.selectedItems)
        ..remove(event.productId);
      final updatedQuantities = Map<String, int>.from(state.itemQuantities)
        ..remove(event.productId);

      final currentItems =
          event.isPickup ? updatedPickupItems : updatedRegularItems;
      final isAllSelected = currentItems.isNotEmpty &&
          currentItems
              .every((item) => updatedSelectedItems[item.productId] == true);

      emit(state.copyWith(
        regularDeliveryItems: updatedRegularItems,
        pickupItems: updatedPickupItems,
        selectedItems: updatedSelectedItems,
        itemQuantities: updatedQuantities,
        isAllSelected: isAllSelected,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onSelectAllItems(SelectAllItems event, Emitter<CartState> emit) {
    final currentItems =
        event.isPickup ? state.pickupItems : state.regularDeliveryItems;

    final updatedSelectedItems = Map<String, bool>.from(state.selectedItems);
    for (var item in currentItems) {
      updatedSelectedItems[item.productId] = event.value;
    }

    emit(state.copyWith(
      selectedItems: updatedSelectedItems,
      isAllSelected: event.value,
    ));
  }

  Future<void> _onDeleteSelectedItems(
      DeleteSelectedItems event, Emitter<CartState> emit) async {
    try {
      final selectedIds =
          (event.isPickup ? state.pickupItems : state.regularDeliveryItems)
              .where((item) => state.selectedItems[item.productId] == true)
              .map((item) => item.productId)
              .toList();

      if (selectedIds.isEmpty) return;

      await _cartRepository.removeSelectedProducts(selectedIds, event.isPickup);

      final updatedRegularItems = event.isPickup
          ? state.regularDeliveryItems
          : state.regularDeliveryItems
              .where((item) => !selectedIds.contains(item.productId))
              .toList();

      final updatedPickupItems = event.isPickup
          ? state.pickupItems
              .where((item) => !selectedIds.contains(item.productId))
              .toList()
          : state.pickupItems;

      emit(state.copyWith(
        regularDeliveryItems: updatedRegularItems,
        pickupItems: updatedPickupItems,
        selectedItems: Map.from(state.selectedItems)
          ..removeWhere((key, _) => selectedIds.contains(key)),
        itemQuantities: Map.from(state.itemQuantities)
          ..removeWhere((key, _) => selectedIds.contains(key)),
        isAllSelected: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onMoveToPickup(
      MoveToPickup event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.moveToPickup(event.productIds);

      final itemsToMove = state.regularDeliveryItems
          .where((item) => event.productIds.contains(item.productId))
          .toList();

      final updatedRegularItems = state.regularDeliveryItems
          .where((item) => !event.productIds.contains(item.productId))
          .toList();

      final updatedPickupItems = [...state.pickupItems, ...itemsToMove];

      emit(state.copyWith(
        regularDeliveryItems: updatedRegularItems,
        pickupItems: updatedPickupItems,
        selectedItems: Map.from(state.selectedItems)
          ..removeWhere((key, _) => event.productIds.contains(key)),
        isAllSelected: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onMoveToRegularDelivery(
      MoveToRegularDelivery event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.moveToRegularDelivery(event.productIds);

      final itemsToMove = state.pickupItems
          .where((item) => event.productIds.contains(item.productId))
          .toList();

      final updatedPickupItems = state.pickupItems
          .where((item) => !event.productIds.contains(item.productId))
          .toList();

      final updatedRegularItems = [
        ...state.regularDeliveryItems,
        ...itemsToMove
      ];

      emit(state.copyWith(
        regularDeliveryItems: updatedRegularItems,
        pickupItems: updatedPickupItems,
        selectedItems: Map.from(state.selectedItems)
          ..removeWhere((key, _) => event.productIds.contains(key)),
        isAllSelected: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateCurrentTab(UpdateCurrentTab event, Emitter<CartState> emit) {
    final currentItems = event.isRegularDelivery
        ? state.regularDeliveryItems
        : state.pickupItems;

    final updatedSelectedItems = Map<String, bool>.from(state.selectedItems);
    for (var item in currentItems) {
      updatedSelectedItems[item.productId] = true;
    }

    emit(state.copyWith(
      isRegularDeliveryTab: event.isRegularDelivery,
      selectedItems: updatedSelectedItems,
      isAllSelected: currentItems.isNotEmpty,
    ));
  }

//
// (2) 오더모델 담기. 오더모델 반환, 블럭에서 객체 생성
  Future<OrderModel> getSelectedOrderItems() async {
    print(
        'Getting seleted items from ${state.isRegularDeliveryTab ? "Regular Delivery" : "Pickup"}');
    try {
      // 1. Repository에서 OrderItemModel 리스트 가져오기
      final orderItems = await _cartRepository
          .getSelectedOrderItems(state.isRegularDeliveryTab);
      print('Successfully got ${orderItems.length} order items');
      // 2. 현재 로그인한 사용자 ID 가져오기
      final userId = await OnlyYouSharedPreference().getCurrentUserId();
      // 3. OrderModel 객체 생성
      final order = OrderModel(
        id: '', // userId 대신 빈 문자열 사용 :제일 안정
        userId: userId, // 실제 사용자 ID는 여기서 사용
        items: orderItems,
        orderType:
            state.isRegularDeliveryTab ? OrderType.delivery : OrderType.pickup,
      );
      print('Created order object for user: $userId');
      print('Order type: ${order.orderType}');
      print('Total items: ${order.items.length}');
      print('Total price: ${order.totalPrice}');

      return order;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }
}
// 오더모델로 데이터 전달하는 과정이 없이
//아이템즈만 리턴하는중
// OrderModel 객체를 생성하고 반환하는 비동기 함수
// CartBloc 내에 위치하며, 선택된 카트 아이템을 주문 형태로 변환
// Future<OrderModel> getSelectedOrderItems() async {
//   // state.isRegularDeliveryTab: CartBloc의 현재 상태에서 일반배송 탭인지 여부를 확인
//   // 디버깅을 위해 현재 처리 중인 배송 타입을 로그로 출력
//   print(
//       'Getting selected items from ${state.isRegularDeliveryTab ? "Regular Delivery" : "Pickup"}');
//
//   try {
//     // 1. ShoppingCartRepository의 메서드를 호출하여 선택된 상품들의 OrderItemModel 리스트를 가져옴
//     // _cartRepository: CartBloc에 주입된 ShoppingCartRepository 인스턴스
//     final orderItems = await _cartRepository
//         .getSelectedOrderItems(state.isRegularDeliveryTab);
//     print('Successfully got ${orderItems.length} order items'); // 변환된 아이템 수 확인
//
//     // 2. SharedPreferences에서 현재 로그인한 사용자의 고유 ID를 비동기로 가져옴
//     final userId = await OnlyYouSharedPreference().getCurrentUserId();
//
//     // 3. 가져온 정보를 바탕으로 완전한 OrderModel 객체를 생성
//     final order = OrderModel(
//       id: userId, // 주문의 고유 식별자로 현재 사용자 ID를 사용
//       userId: userId, // 주문을 생성한 사용자의 ID
//       items: orderItems, // Repository에서 변환된 주문 상품 리스트
//       orderType: // 현재 탭 상태에 따라 배송 타입을 결정
//       state.isRegularDeliveryTab ? OrderType.delivery : OrderType.pickup,
//     );
//
//     // 생성된 주문 객체의 상세 정보를 디버깅용으로 로그에 출력
//     print('Created order object for user: $userId');
//     print('Order type: ${order.orderType}'); // delivery 또는 pickup
//     print('Total items: ${order.items.length}'); // 주문에 포함된 총 상품 수
//     print('Total price: ${order.totalPrice}'); // 총 주문 금액 (자동 계산됨)
//
//     // 생성된 OrderModel 객체를 호출자에게 반환
//     return order;
//   } catch (e) {
//     // 주문 객체 생성 과정에서 발생한 모든 예외를 로그로 출력
//     print('Error creating order: $e');
//     // rethrow: 발생한 예외를 상위 계층(UI)으로 전파하여 적절한 에러 처리가 가능하도록 함
//     rethrow;
//   }
// }
