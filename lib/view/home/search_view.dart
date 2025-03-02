import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/most_popular_cell.dart';
import 'package:food_delivery/view/menu/item_details_view.dart';
import 'package:food_delivery/services/product_service.dart';

class SearchView extends StatelessWidget {
  final String searchQuery;
  final ProductService _productService = ProductService();

  SearchView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm: $searchQuery'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _productService.searchProducts(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Có lỗi xảy ra!'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không tìm thấy sản phẩm nào.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var product =
                  snapshot.data![index].data() as Map<String, dynamic>;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: MostPopularCell1(
                  mObj: {
                    "image": product['image'] ?? '',
                    "name": product['name'] ?? 'Tên sản phẩm không xác định',
                    "type": product['type'] ?? '',
                    "food_type": product['food_type'] ?? '',
                    "rate": product['rate'] ?? '0',
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsView(item: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// UI San Pham
class MostPopularCell1 extends StatelessWidget {
  final Map mObj;
  final VoidCallback onTap;
  const MostPopularCell1({super.key, required this.mObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                mObj["image"].toString(),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              mObj['name'] ?? 'Tên sản phẩm không xác định',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  mObj["type"] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                ),
                Text(
                  " . ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.primary, fontSize: 12),
                ),
                Text(
                  mObj["food_type"] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                ),
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "assets/img/rate.png" ?? '',
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  mObj["rate"] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.primary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
