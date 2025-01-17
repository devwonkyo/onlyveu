import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:onlyveyou/models/extensions/product_model_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/home/home_bloc.dart';
import '../../../models/product_model.dart';
import '../../../utils/styles.dart';
import '../../../blocs/search/recent_search/recent_search_bloc.dart';
import '../../../blocs/search/search_textfield/search_textfield_bloc.dart';
import '../../../blocs/search/search_result/search_result_bloc.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchTextFieldBloc, SearchTextFieldState>(
      listener: (context, state) {
        if (state is SearchTextFieldEmpty) {
          context.read<RecentSearchBloc>().add(LoadRecentSearches());
        }
      },
      child: BlocBuilder<SearchResultBloc, SearchResultState>(
        builder: (context, state) {
          if (state is SearchResultInitial) {
            return const SizedBox();
          } else if (state is SearchResultLoading) {
            return const ResultSkeleton();
          } else if (state is SearchResultLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '총 ${state.products.length}개',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.tune),
                            SizedBox(width: 20.w),
                            GestureDetector(
                              onTap: () {
                                _showSortOptions(context);
                              },
                              child: Text(
                                '인기순',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 0.45.r,
                        mainAxisExtent: 350.h,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) => ProductCard(
                        item: state.products[index],
                        onTap: () {
                          context.push("/product-detail",
                              extra: state.products[index].productId);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SearchResultError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SearchResultEmpty) {
            return const Center(child: Text('검색 결과가 없습니다.'));
          } else {
            return const Center(child: Text('No results found.'));
          }
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15.h),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Text(
                      '인기순',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '판매순',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '낮은 가격순',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '리뷰 많은 순',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '할인율순',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '신상품순',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ResultSkeleton extends StatelessWidget {
  const ResultSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 개',
                  style: TextStyle(fontSize: 15.sp),
                ),
                Row(
                  children: [
                    const Icon(Icons.tune),
                    SizedBox(width: 20.w),
                    Text(
                      '인기순',
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  mainAxisExtent: 300.h,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 100.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel item;
  final Function() onTap;
  const ProductCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  // 가격 포맷팅 메서드 추가
  String _formatPrice(String price) {
    try {
      return price.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    } catch (e) {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.productImageList.isNotEmpty
                    ? Image.network(
                        item.productImageList[0],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(Icons.error)); // 이미지 로딩 실패 시 아이콘 표시
                        },
                      )
                    : Image.asset(
                        'assets/default.png', // 로컬 기본 이미지
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // 상품명
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4.h),

          // 가격 정보
          Text(
            '${_formatPrice(item.price)}원',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
          if (item.discountPercent > 0)
            Text(
              '${_formatPrice(item.discountedPrice.toString())}원',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
          SizedBox(height: 6.h),

          // 별점과 리뷰 수
          Row(
            children: [
              Icon(Icons.star, size: 12.sp, color: AppStyles.mainColor),
              SizedBox(width: 2.w),
              Text(
                item.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '(${item.reviewCount})',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),

          // 좋아요와 장바구니 버튼
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .read<HomeBloc>()
                      .add(ToggleProductFavorite(item, 'userId_here'));
                },
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Icon(
                    item.isFavorite('userId_here')
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18.sp,
                    color: item.isFavorite('userId_here')
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 25.w),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 20.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
