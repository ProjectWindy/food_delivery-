import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

 Future<bool> doesCollectionExist(String collectionPath) async {
  final snapshot = await firestore.collection(collectionPath).limit(1).get();
  return snapshot.docs.isNotEmpty;
}

 Future<void> uploadMenuItems() async {
  if (await doesCollectionExist("menu_items")) return;

  List<Map<String, dynamic>> menuItems = [
    {
      "image": "assets/img/offer_1.png",
      "name": "Café de Noires",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_2.png",
      "name": "Isso",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_3.png",
      "name": "Cafe Beans",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_1.png",
      "name": "Café de Noires",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_2.png",
      "name": "Isso",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_3.png",
      "name": "Cafe Beans",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  for (var item in menuItems) {
    await firestore.collection("menu_items").doc(item["name"]).set(item);
  }
}

 Future<void> uploadCategories() async {
  if (await doesCollectionExist("categories")) return;

  List<Map<String, dynamic>> catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];

  for (var item in catArr) {
    await firestore.collection("categories").doc(item["name"]).set(item);
  }
}

 Future<void> uploadPopularItems() async {
  if (await doesCollectionExist("popular_items")) return;

  List<Map<String, dynamic>> popArr = [
    {
      "image": "assets/img/res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_3.png",
      "name": "Bakes by Tella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  for (var item in popArr) {
    await firestore.collection("popular_items").doc(item["name"]).set(item);
  }
}

 Future<void> uploadMostPopularItems() async {
  if (await doesCollectionExist("most_popular_items")) return;

  List<Map<String, dynamic>> mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  for (var item in mostPopArr) {
    await firestore
        .collection("most_popular_items")
        .doc(item["name"])
        .set(item);
  }
}

 Future<void> uploadRecentItems() async {
  if (await doesCollectionExist("recent_items")) return;

  List<Map<String, dynamic>> recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza by Josh",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  for (var item in recentArr) {
    await firestore.collection("recent_items").doc(item["name"]).set(item);
  }
}

 Future<void> uploadAllDataOnFirstRun() async {
  await uploadMenuItems();
  await uploadCategories();
  await uploadPopularItems();
  await uploadMostPopularItems();
  await uploadRecentItems();
  print("Tất cả dữ liệu đã được tải lên Firestore (nếu chưa có).");
}
