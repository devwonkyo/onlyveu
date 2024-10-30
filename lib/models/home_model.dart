import 'dart:ui'; // 색상 처리를 위한 Color 클래스 사용

// 배너 아이템 모델 클래스
class BannerItem {
  final String title; // 배너의 주요 제목
  final String subtitle; // 배너의 부제목
  final Color backgroundColor; // 배너의 배경 색상

  // 배너 아이템 생성자
  BannerItem({
    required this.title, // 제목 필수 입력
    required this.subtitle, // 부제목 필수 입력
    required this.backgroundColor, // 배경 색상 필수 입력
  });
}
///////////////////////////////////////////
// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final int stock;
//   final String category;
//   final double rating;
//   final int reviewCount;
//   final String imageUrl;
//   final bool isPopular;
//   final bool isRecommended;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.stock,
//     required this.category,
//     required this.rating,
//     required this.reviewCount,
//     required this.imageUrl,
//     this.isPopular = false,
//     this.isRecommended = false,
//   });
//
//   factory Product.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;
//     return Product(
//       id: doc.id,
//       name: data['name'] ?? '',
//       description: data['description'] ?? '',
//       price: data['price']?.toDouble() ?? 0.0,
//       stock: data['stock'] ?? 0,
//       category: data['category'] ?? '',
//       rating: data['rating']?.toDouble() ?? 0.0,
//       reviewCount: data['reviewCount'] ?? 0,
//       imageUrl: data['imageUrl'] ?? '',
//       isPopular: data['isPopular'] ?? false,
//       isRecommended: data['isRecommended'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'description': description,
//       'price': price,
//       'stock': stock,
//       'category': category,
//       'rating': rating,
//       'reviewCount': reviewCount,
//       'imageUrl': imageUrl,
//       'isPopular': isPopular,
//       'isRecommended': isRecommended,
//     };
//   }
// }

////////////////////////////////////
// Stream<List<Product>> fetchPopularProducts() {
//   return FirebaseFirestore.instance
//       .collection('products')
//       .where('isPopular', isEqualTo: true)
//       .snapshots()
//       .map((snapshot) =>
//       snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
// }
/////////////////////////////////////
// Stream<List<Product>> fetchRecommendedProducts() {
//   return FirebaseFirestore.instance
//       .collection('products')
//       .where('isRecommended', isEqualTo: true)
//       .snapshots()
//       .map((snapshot) =>
//       snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
// }
///////////////////////////////
// class BannerItem {
//   final String title;
//   final String subtitle;
//   final String imageUrl;
//   final String link;
//
//   BannerItem({
//     required this.title,
//     required this.subtitle,
//     required this.imageUrl,
//     required this.link,
//   });
//
//   factory BannerItem.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;
//     return BannerItem(
//       title: data['title'] ?? '',
//       subtitle: data['subtitle'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//       link: data['link'] ?? '',
//     );
//   }
// }
//////////////////////
// Stream<List<BannerItem>> fetchBannerItems() {
//   return FirebaseFirestore.instance
//       .collection('banners')
//       .snapshots()
//       .map((snapshot) =>
//       snapshot.docs.map((doc) => BannerItem.fromFirestore(doc)).toList());
// }
