import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/view/menu/item_details_view.dart';
import 'package:food_delivery/view/more/my_order_view.dart';
import 'package:food_delivery/common_widget/menu_item_row.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/models/cart.dart';

class MenuItem {
  String image;
  String name;
  String rate;
  String rating;
  String type;
  String foodType;

  MenuItem({
    required this.image,
    required this.name,
    required this.rate,
    required this.rating,
    required this.type,
    required this.foodType,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'rate': rate,
      'rating': rating,
      'type': type,
      'food_type': foodType,
    };
  }
}

Future<void> uploadMenuItems() async {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final DataSnapshot snapshot = await database.child('menu_items').get();

  if (snapshot.exists) {
    print("Dữ liệu đã tồn tại, không tải lên nữa.");
    return;  
  }

  print("Dữ liệu đã được tải lên Firebase thành công.");
}

class MenuItemsView extends StatefulWidget {
  final Map mObj;
  const MenuItemsView({super.key, required this.mObj});

  @override
  State<MenuItemsView> createState() => _MenuItemsViewState();
}

class _MenuItemsViewState extends State<MenuItemsView> {
  TextEditingController txtSearch = TextEditingController();
  List<Map<String, dynamic>> menuItemsArr = [];
  List<Map<String, dynamic>> filteredMenuItemsArr = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();

     txtSearch.addListener(() {
      filterMenuItems(txtSearch.text);
    });
  }

  Future<void> fetchMenuItems() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection("menu_items").get();

      List<Map<String, dynamic>> menu = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
          'image': data['image'] ?? 'assets/img/default.png',
          'name': data['name'] ?? 'Unknown',
          'rate': data['rate'] ?? '0.0',
          'rating': data['rating'] ?? '0',
          'type': data['type'] ?? 'Unknown',
          'food_type': data['food_type'] ?? 'Other',
        };
      }).toList();

      setState(() {
        menuItemsArr = menu;
        filteredMenuItemsArr = menu; // Khởi tạo danh sách hiển thị ban đầu
      });

      print("Fetched items: ${menu.length}");
    } catch (e) {
      print("Error fetching menu items: $e");
    }
  }

  void filterMenuItems(String query) {
    List<Map<String, dynamic>> filteredList = menuItemsArr.where((item) {
      return item['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredMenuItemsArr = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.mObj["name"].toString(),
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrderView(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredMenuItemsArr.length,
                itemBuilder: (context, index) {
                  var mObj = filteredMenuItemsArr[index];
                  return MenuItemRow(
                    mObj: mObj,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetailsView(
                                  item: mObj,
                                )),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
