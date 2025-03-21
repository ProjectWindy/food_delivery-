import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/view/admin/User_manager.dart';
import 'package:food_delivery/view/admin/product_manager%20copy.dart';
import 'package:food_delivery/view/more/about_us_view.dart';
import 'package:food_delivery/view/more/inbox_view.dart';
import 'package:food_delivery/view/more/order_history_view.dart';
import 'package:food_delivery/view/more/payment_details_view.dart';

import '../../common/color_extension.dart';
import '../../common/service_call.dart';
import 'notification_view.dart';
import '../../services/auth_service.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  final AuthService _authService = AuthService();
  List moreArr = [];
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    String role = await _authService.getUserRole();
    setState(() {
      userRole = role;
      moreArr = _buildMoreArr();
    });
  }

  List _buildMoreArr() {
    return [
      {
        "index": "1",
        "name": "Payment Details",
        "image": "assets/img/more_payment.png",
        "base": 0
      },
      {
        "index": "2",
        "name": "My Orders",
        "image": "assets/img/more_my_order.png",
        "base": 0
      },
      {
        "index": "3",
        "name": "Notifications",
        "image": "assets/img/more_notification.png",
        "base": 0
      },
      {
        "index": "4",
        "name": "Inbox",
        "image": "assets/img/more_inbox.png",
        "base": 0
      },
      {
        "index": "5",
        "name": "About Us",
        "image": "assets/img/more_info.png",
        "base": 0
      },
      {
        "index": "6",
        "name": "Logout",
        "image": "assets/img/more_info.png",
        "base": 0
      },
      if (userRole == 'admin') ...[
        {
          "index": "7",
          "name": "Admin Users",
          "image": "assets/img/tab_profile.png",
          "base": 0
        },
        {
          "index": "8",
          "name": "Admin Product",
          "image": "assets/img/tab_home.png",
          "base": 0
        },
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MyOrderView()));
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
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moreArr.length,
                  itemBuilder: (context, index) {
                    var mObj = moreArr[index] as Map? ?? {};
                    var countBase = mObj["base"] as int? ?? 0;
                    return InkWell(
                      onTap: () {
                        switch (mObj["index"].toString()) {
                          case "1":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentDetailsView()));
                            break;

                          case "2":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderHistoryView()));
                            break;
                          case "3":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsView()));
                            break;
                          case "4":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InboxView()));
                            break;
                          case "5":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AboutUsView()));
                            break;
                          case "6":
                            _authService.logout();
                            break;
                          case "7":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserManagementView()));
                            break;
                          case "8":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListScreen()));
                            break;
                          default:
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(5)),
                              margin: const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: TColor.placeholder,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    alignment: Alignment.center,
                                    child: Image.asset(mObj["image"].toString(),
                                        color: Colors.black,
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.contain),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      mObj["name"].toString(),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (countBase > 0)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12.5)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        countBase.toString(),
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("assets/img/btn_next.png",
                                  width: 10,
                                  height: 10,
                                  color: TColor.primaryText),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
