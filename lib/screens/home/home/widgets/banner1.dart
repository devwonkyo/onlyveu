import 'package:flutter/material.dart';

class Banner1Screen extends StatelessWidget {
  const Banner1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 배너 이미지 리스트
    final List<String> bannerImages = [
      'assets/image/banner/b1.jpg', // 첫 번째 이미지
      'assets/image/banner/b2.jfif',
      'assets/image/banner/b3.jfif',
      'assets/image/banner/b4.jfif',
      'assets/image/banner/b5.jfif',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: bannerImages
              .map(
                (imagePath) => Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}