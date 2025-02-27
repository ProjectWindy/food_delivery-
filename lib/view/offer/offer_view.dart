import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../more/my_order_view.dart';
import '../menu/item_details_view.dart';  

class OfferView extends StatefulWidget {
  const OfferView({super.key});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  List<Map<String, dynamic>> offerArr = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection("menu_items").get();

      List<Map<String, dynamic>> offers = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
          'image': data['image'] ?? 'assets/img/default.png',
          'name': data['name'] ?? 'Unknown',
          'rate': data['rate'] ?? '0.0',
          'rating': data['rating'] ?? '0',
          'type': data['type'] ?? 'Unknown',
          'food_type': data['food_type'] ?? 'Other',
           'description': data['description'] ?? '',
          'price': data['price'] ?? '0.0',
        };
      }).toList();

      setState(() {
        offerArr = offers;
        isLoading = false;
      });

      print("Fetched menu items for offers: ${offers.length}");
    } catch (e) {
      print("Error fetching menu items: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/img/shopping_cart.png", width: 25),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrderView()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Latest Offers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Find discounts, Offers special meals and more!",
              style: TextStyle(color: TColor.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 140,
              height: 30,
              child: RoundButton(
                title: "Refresh",
                fontSize: 12,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  fetchMenuItems();
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : offerArr.isEmpty
                      ? const Center(child: Text("No offers available"))
                      : ListView.builder(
                          itemCount: offerArr.length,
                          itemBuilder: (context, index) {
                            var mObj = offerArr[index];
                            return PopularRestaurantRow(
                              pObj: mObj,
                              onTap: () {
                                // Chuyển đến ItemDetailsView khi nhấn vào item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailsView(
                                      item: mObj,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
