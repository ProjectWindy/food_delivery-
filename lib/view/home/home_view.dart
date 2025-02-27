import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/models/home.dart';
import 'package:food_delivery/view/home/search_view.dart';
import 'package:food_delivery/view/menu/item_details_view.dart';
import 'package:provider/provider.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();

  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: homeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 46),
                      GestureDetector(
                        onTap: () {
                          if (txtSearch.text.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchView(searchQuery: txtSearch.text),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RoundTextfield(
                            hintText: "Search Food",
                            controller: txtSearch,
                            left: Container(
                              alignment: Alignment.center,
                              width: 30,
                              child: Image.asset("assets/img/search.png",
                                  width: 20, height: 20),
                            ),
                            IconButton1: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                if (txtSearch.text.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchView(
                                          searchQuery: txtSearch.text),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: catArr.length,
                          itemBuilder: ((context, index) {
                            var cObj = catArr[index] as Map? ?? {};
                            return CategoryCell(
                              cObj: cObj,
                              onTap: () {},
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ViewAllTitleRow(
                            title: "Popular Restaurants", onView: () {}),
                      ),
                    ],
                  ),
                ),

                 SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var pObj = homeProvider.popularRestaurants[index];
                      return PopularRestaurantRow(
                        pObj: pObj,
                        onTap: () {
                     
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailsView(
                                  item:
                                      pObj) 
                            ),
                          );
                        },
                      );
                    },
                    childCount: homeProvider.popularRestaurants.length,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        ViewAllTitleRow(title: "Most Popular", onView: () {}),
                  ),
                ),

            
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: homeProvider.mostPopular.length,
                      itemBuilder: (context, index) {
                        var mObj = homeProvider.mostPopular[index];
                        return MostPopularCell(
                          mObj: mObj,
                          onTap: () {
                        
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsView(
                                    item:
                                        mObj), 
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        ViewAllTitleRow(title: "Recent Items", onView: () {}),
                  ),
                ),

                 SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var rObj = homeProvider.recentItems[index];
                      return RecentItemRow(
                        rObj: rObj,
                        onTap: () {
                         
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailsView(
                                  item:
                                      rObj),  
                            ),
                          );
                        },
                      );
                    },
                    childCount: homeProvider.recentItems.length,
                  ),
                ),
              ],
            ),
    );
  }
}
