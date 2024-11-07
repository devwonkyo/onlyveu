import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlyveyou/blocs/mypage/order_status/order_status_bloc.dart';
import 'package:onlyveyou/blocs/mypage/order_status/order_status_event.dart';
import 'package:onlyveyou/blocs/mypage/order_status/order_status_state.dart';
import 'package:onlyveyou/config/color.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문/배송 조회'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildPurchaseTypeDropdown(context)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusDropdown(context)),
              ],
            ),
            const SizedBox(height: 250),
            const Column(
              children: [
                Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.grey,
                ),
                Text(
                  '기간 내 주문내역이 없습니다', //만약 주문 내역이 없다면
                  style: TextStyle(
                    color: AppsColor.darkGray,
                    fontSize: 20,
                  ),
                ),
                //주문 내역이 있다면 해당 주문 내역을 보여준다
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseTypeDropdown(BuildContext context) {
    final purchaseOptions = ['온라인몰 구매', '매장 구매'];
    return BlocBuilder<OrderStatusBloc, OrderStatusState>(
      builder: (context, state) {
        String? selectedPurchaseType;

        if (state is OrderStatusInitial) {
          selectedPurchaseType = state.selectedPurchaseType;
        } else if (state is PurchaseTypeSelected) {
          selectedPurchaseType = state.selectedPurchaseType;
        } else if (state is StatusSelected) {
          selectedPurchaseType = state.selectedPurchaseType;
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: purchaseOptions
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            value: selectedPurchaseType,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderStatusBloc>().add(SelectPurchaseType(value));
              }
            },
            buttonStyleData: const ButtonStyleData(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return BlocBuilder<OrderStatusBloc, OrderStatusState>(
      builder: (context, state) {
        List<String> statusOptions = [];
        String? selectedStatus;

        if (state is OrderStatusInitial) {
          statusOptions = state.statusOptions;
          selectedStatus = state.selectedStatus;
        } else if (state is PurchaseTypeSelected) {
          statusOptions = state.statusOptions;
          selectedStatus = state.statusOptions[0]; // 기본값 설정
        } else if (state is StatusSelected) {
          statusOptions = state.statusOptions;
          selectedStatus = state.selectedStatus;
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: statusOptions
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            value: selectedStatus,
            onChanged: (value) {
              if (value != null) {
                context.read<OrderStatusBloc>().add(SelectStatus(value));
              }
            },
            buttonStyleData: const ButtonStyleData(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}