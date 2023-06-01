import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/home/shimmer/home_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = [];
  late CategoriesCubit cubit;
  final _checker = AppVersionChecker();

  @override
  void initState() {
    super.initState();
    cubit = CategoriesCubit.get(context);
    CheckoutCubit.get(context).fetchCartList(context);
    checkAppVersion();
  }

  Future<void> checkAppVersion() async {
    await _checker.checkUpdate().then((value) async {
      print(value.canUpdate); //return true if update is available
      print(value.currentVersion); //return current app version
      print(value.newVersion); //return the new app version
      print(value.appURL); //return the app url
      print(value
          .errorMessage); //return error message if found else it will return null
      if (value.canUpdate) {
        return await AppUtil.dialog2(
          context,
          "versionTitle".tr(),
          [
            ElevatedButton(
              onPressed: () async {
                await launchUrlString(
                  value.appURL!,
                );
              },
              child: CustomText(
                text: "updateNow".tr(),
                textAlign: TextAlign.center,
                color: Colors.white,
              ),
            ),
          ],
          barrierDismissible: false,
          showClose: false,
        );
      }
    });
  }

  // List<String> bannersText = [
  //   "Thobe",
  //   "Headgear",
  //   "Outerwear",
  //   "Loungewear",
  //   "UnderWear",
  //   "Ihram",
  //   "Accessories",
  //   "Versace",
  //   "Generation"
  // ];

  @override
  Widget build(BuildContext context) {
    // final cubit = CategoriesCubit.get(context);

    return CheckNetwork(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            /*  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                  height: 60,
                  child: CustomInput(
                    controller: TextEditingController(),
                    hint: "searchHere".tr(),
                    textInputType: TextInputType.text,
                    borderColor: Color(0xffFAFAFA),
                    fillColor: Color(0xffFAFAFA),
                    prefixIcon: Image.asset("${AppUI.imgPath}search.png"),
                    readOnly: true,
                    onTap: () {
                      AppUtil.mainNavigator(context,
                          const ProductsScreen(catId: 0, catName: 'products'));
                    },
                  )),
            ),*/
            Expanded(
              child: BlocConsumer<CategoriesCubit, CategoriesState>(
                  buildWhen: (context, state) {
                    return state is CategoriesLoadingState ||
                        state is CategoriesEmptyState ||
                        state is CategoriesErrorState ||
                        state is CategoriesLoadedState;
                  },
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is CategoriesLoadingState) {
                      return const HomeShimmer();
                    }
                    if (state is CategoriesEmptyState) {
                      return Center(
                        child: CustomText(
                          text: "noProductsAvailable".tr(),
                          fontSize: 24,
                        ),
                      );
                    }

                    if (state is CategoriesErrorState) {
                      return Center(
                        child: CustomText(
                          text: "error".tr(),
                          fontSize: 24,
                        ),
                      );
                    }
                    cubit.tapBarController ??= TabController(
                        length: cubit.categoriesModel.length, vsync: this);

                    tabs.clear();
                    for (var element in cubit.categoriesModel) {
                      tabs.add(
                        Tab(
                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text("${element.name}",
                          // style: TextStyle(
                          //     color: AppUI.alshiakaColor, fontSize: 14),
                          // textAlign: TextAlign.center),
                          //     SizedBox(
                          //       width: 35,
                          //     ),
                          //     Text(
                          //       "|",
                          //       style: TextStyle(color: Colors.black12),
                          //     )
                          //   ],
                          // ),
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Text(
                              "${element.name}",
                              style: TextStyle(
                                color: AppUI.alshiakaColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    return DefaultTabController(
                      length: tabs.length,
                      initialIndex: cubit.initialIndex,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              color: AppUI.whiteColor,
                              child: Row(
                                children: [
                                  // Container(
                                  //     width: MediaQuery.of(context).size.width*.03-2,
                                  //     alignment: Alignment.center,
                                  //     child: Icon(Icons.arrow_back_ios,size: 16,)),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .94,
                                    child: TabBar(
                                        controller: cubit.tapBarController,
                                        onTap: (index) {
                                          AppUtil.mainNavigator(
                                              context,
                                              ProductsScreen(
                                                  catId: cubit
                                                      .categoriesModel[index]
                                                      .id!,
                                                  catName: cubit
                                                      .categoriesModel[index]
                                                      .name!));
                                          // cubit.tapBarController!.index = 0;
                                          // cubit.tapBarController!.index = cubit.tapBarController!.previousIndex;
                                          // cubit.initialIndex = index;
                                          // cubit.fetchNewArrivalProductsByCategory(catId: cubit.categoriesModel[index].id, page: 1, perPage: 20,ratingCount: 1,);
                                        },
                                        // indicator: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppUI.mainColor,),
                                        //indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                                        indicatorWeight: 1,
                                        indicatorColor: AppUI.whiteColor,
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.black38,
                                        unselectedLabelStyle: TextStyle(
                                          color: Colors.black38,
                                          fontFamily:
                                              AppUtil.rtlDirection(context)
                                                  ? "cairo"
                                                  : "Tajawal",
                                        ),
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 10,
                                        ),
                                        physics: const BouncingScrollPhysics(),
                                        tabs: tabs),
                                  ),
                                  // Container(
                                  //     width: MediaQuery.of(context).size.width *
                                  //             .03 -
                                  //         2,
                                  //     alignment: Alignment.center,
                                  //     child: Icon(
                                  //       Icons.arrow_forward_ios,
                                  //       size: 16,
                                  //     )),
                                ],
                              )),
                          Expanded(
                            child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(tabs.length, (index) {
                                  return HomeTab(
                                      catId: cubit.categoriesModel[index].id);
                                })),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
