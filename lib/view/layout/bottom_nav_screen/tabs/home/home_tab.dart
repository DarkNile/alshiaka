import 'dart:convert';

import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_carousel/main/light_carousel.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_states.dart';
import '../../../../../shared/components.dart';
import '../../../../../utilities/app_util.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  final int? catId;

  const HomeTab({Key? key, this.catId}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Widget> banners = [];
  late CategoriesCubit cubit;
  List<Widget> homeTapWidgets = [];
  Future<String> getImage() async {
    var url =
        "https://alshiaka.com/wp-json/settings/addon/shiaka_addon?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b";
    print(url);
    var response;
    try {
      response = await http.get(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      print("######################################################3333");
      if (response.statusCode == 200 && response.body != null) {
        print(response.body);
        print(
            "*********************************************************************************************");
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    print(json.decode(response.body)["sh_banner_image_apis"]);
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return json.decode(response.body)["sh_banner_image_apis"];
  }

  String banner = "";
  @override
  void initState() {
    super.initState();
    cubit = CategoriesCubit.get(context);
    loadData();
    // homeTapWidgets.add(SizedBox());
    // cubit.homeScrollController.addListener(() async {
    //   if (cubit.homeScrollController.position.pixels ==
    //       cubit.homeScrollController.position.maxScrollExtent) {
    // if(cubit.homeScrollController.position.pixels == 100) {
    // }

    // if(cubit.categoriesModel.length != homeTapWidgets.length) {
    //   cubit.tapBarController!.animateTo(cubit.tapBarController!.index+1);
    //   cubit.initialIndex = homeTapWidgets.length;
    //   await cubit.fetchNewArrivalProductsByCategory(catId: cubit.categoriesModel[homeTapWidgets.length].id, page: 1, perPage: 20,ratingCount: 1,);
    //   cubit.homeScrollController.jumpTo(cubit.homeScrollController.position.pixels+600);
    //   homeTapWidgets.add(SizedBox());
    // }
    // }
    // });
  }

  loadData() async {
    banner = await getImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print(width);
    print(height * 0.53);
    final cubit = CategoriesCubit.get(context);
    banners.clear();
    for (var element in cubit.bannerModel) {
      banners.add(
        InkWell(
          onTap: () {
            // launch(element.i)
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: element.image!,
              fit: BoxFit.fill,
              placeholder: (context, url) => Image.asset(
                "${AppUI.imgPath}product_background.png",
                fit: BoxFit.fill,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "${AppUI.imgPath}product_background.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    }
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        buildWhen: (_, state) =>
            state is ProductsLoadedState ||
            state is FavLoadedState ||
            state is ChangeFavState,
        builder: (context, state) {
          // return ListView(
          //   controller: cubit.homeScrollController,
          //   children: List.generate(homeTapWidgets.length, (index) {
          //     return VisibilityDetector(
          //       key: Key(index.toString()),
          //       onVisibilityChanged: (visibilityInfo) {
          //         var visiblePercentage = visibilityInfo.visibleFraction;
          //         if(visiblePercentage > 0.6){
          //           cubit.tapBarController!.animateTo(int.parse(visibilityInfo.key.toString().substring(3,4)));
          //         }
          //         debugPrint(
          //             'Widget ${visibilityInfo.key.toString().substring(3,4)} is ${visiblePercentage}% visible');
          //       },
          //       child:
          return CheckNetwork(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (banners.isNotEmpty)
                    SizedBox(
                        height: height * 0.53,
                        width: width,
                        child: LightCarousel(
                          images: banners,
                          dotSize: 5.0,
                          dotSpacing: 15.0,
                          dotColor: AppUI.whiteColor,
                          dotIncreasedColor: AppUI.mainColor,
                          indicatorBgPadding: 20.0,
                          dotBgColor: Colors.purple.withOpacity(0.0),
                          borderRadius: true,
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      AppUtil.mainNavigator(context,
                          ProductsScreen(catId: 0, catName: "newArrival".tr()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CustomText(
                            text: "newArrival".tr(),
                            fontSize: 18,
                          ),
                          const Spacer(),
                          CustomText(
                            text: "seeMore".tr(),
                            color: AppUI.mainColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppUtil.rtlDirection(context) ? 0 : 10,
                        right: AppUtil.rtlDirection(context) ? 10 : 0),
                    child: SizedBox(
                      height: 350,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(cubit.newArrivalProduct.length,
                            (index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 170,
                                child: ProductCard(
                                  product: cubit.newArrivalProduct[index],
                                  onFav: () {
                                    cubit.favProduct(
                                        cubit.newArrivalProduct[index],
                                        context);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  // InkWell(
                  //   onTap: (){
                  //     AppUtil.mainNavigator(context, ProductsScreen(catId: 0, catName: "recommendedForYour".tr()));
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Row(
                  //       children: [
                  //         CustomText(
                  //           text: "recommendedForYour".tr(),
                  //           fontSize: 18,
                  //         ),
                  //         const Spacer(),
                  //         CustomText(text: "seeMore".tr(),color: AppUI.mainColor,)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 10,),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: SizedBox(
                  //     height: 320,
                  //     child: ListView(
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       children:
                  //       List.generate(cubit.recommendedProduct.length, (index) {
                  //         return Row(
                  //           children: [
                  //             SizedBox(
                  //               width: 170,
                  //               child: ProductCard(
                  //                 product: cubit.recommendedProduct[index],
                  //                 onFav: () {
                  //                   cubit.favProduct(cubit.recommendedProduct[index],context);
                  //                 },
                  //               ),
                  //             ),
                  //             const SizedBox( width: 20,)
                  //           ],
                  //         );
                  //       }),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 150.0,
                      // color: Colors.yellow,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: LightCarousel(
                        images: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: banner,
                              height: 160,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(
                                "${AppUI.imgPath}banner3.jpg",
                                //height: 200,
                                //width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "${AppUI.imgPath}banner3.jpg",
                                //  height: 200,
                                //   width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        dotSize: 0.0,
                        dotSpacing: 15.0,
                        dotColor: AppUI.whiteColor,
                        dotIncreasedColor: AppUI.mainColor,
                        indicatorBgPadding: 20.0,
                        dotBgColor: Colors.purple.withOpacity(0.0),
                        borderRadius: true,
                      )),
                  const SizedBox(
                    height: 0,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        List.generate(cubit.homeMenuModel.length, (index) {
                      if (cubit.homeMenuModel[index].isEmpty) {
                        return const SizedBox();
                      }
                      return index == 0
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(cubit.linkList[index].title);
                                    print(
                                        "****************************************************************");
                                    AppUtil.mainNavigator(
                                        context,
                                        ProductsScreen(
                                            catId: cubit.homeMenuModel[index][0]
                                                .categoriesIds[0]!,
                                            catName:
                                                cubit.linkList[index].title!));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: cubit.linkList[index].title,
                                          fontSize: 18,
                                        ),
                                        const Spacer(),
                                        CustomText(
                                          text: "seeMore".tr(),
                                          color: AppUI.mainColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: AppUtil.rtlDirection(context)
                                          ? 0
                                          : 10,
                                      right: AppUtil.rtlDirection(context)
                                          ? 10
                                          : 0),
                                  child: SizedBox(
                                    height: 350,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          cubit.homeMenuModel[index].length,
                                          (index2) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: 170,
                                              child: ProductCard(
                                                product:
                                                    cubit.homeMenuModel[index]
                                                        [index2],
                                                onFav: () {
                                                  cubit.favProduct(
                                                      cubit.homeMenuModel[index]
                                                          [index2],
                                                      context);
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }),
                  )
                ],
                // ),
                // );
                // }),
              ),
            ),
          );
        });
  }
}
