import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import 'widgets/cart_bottombar_widget.dart';
import 'widgets/cart_tab_header_widget.dart';
//스크린에서 1탭헤더. 2바텀바만 쓰고
//스크린 ㅡ A탭헤더에서 C프라이스 위젯쓰고, D프로덕트리스트 위젯쓴다.
///     ㄴ B바텀바에서 C프라이스 위젯 쓴다

// 유저에 좋아요리스트 , 장바구니 리스트( 일반배송 픽업 구분)
class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
//상단탭 2개
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<CartBloc>().add(LoadCart());

    // 탭 변경 시 해당 탭의 아이템들 선택 상태 초기화
    _tabController.addListener(() {
      final cartBloc = context.read<CartBloc>();
      cartBloc.add(SelectAllItems(true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            //앱바
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '장바구니',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () => context.go('/search'),
              ),
              IconButton(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
          body: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : CartTabHeaderWidget(
                  //헤더 위젯 - 그쪽 페이지로 가자
                  regularDeliveryItems: state.regularDeliveryItems,
                  pickupItems: state.pickupItems,
                  selectedItems: state.selectedItems,
                  itemQuantities: state.itemQuantities,
                  isAllSelected: state.isAllSelected,
                  onSelectAll: (value) {
                    //이벤트 로직들이 블록에 가있음
                    context.read<CartBloc>().add(SelectAllItems(value ?? true));
                  },
                  onRemoveItem: (item) {
                    context.read<CartBloc>().add(RemoveItem(item));
                  },
                  updateQuantity: (productId, increment) {
                    context
                        .read<CartBloc>()
                        .add(UpdateItemQuantity(productId, increment));
                  },
                  onUpdateSelection: (productId, value) {
                    context
                        .read<CartBloc>()
                        .add(UpdateItemSelection(productId, value ?? true));
                  },
                  onDeleteSelected: () {
                    context
                        .read<CartBloc>()
                        .add(DeleteSelectedItems(_tabController.index == 0));
                  },
                  moveToPickup: () {
                    context.read<CartBloc>().add(MoveToPickup());
                  },
                  moveToRegularDelivery: () {
                    context.read<CartBloc>().add(MoveToRegularDelivery());
                  },
                  tabController: _tabController,
                ),
          bottomNavigationBar: state.isLoading
              ? null
              : CartBottomBarWidget(
                  //바텀 위젯
                  currentItems: _tabController.index == 0
                      ? state.regularDeliveryItems
                      : state.pickupItems,
                  selectedItems: state.selectedItems,
                  itemQuantities: state.itemQuantities,
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
