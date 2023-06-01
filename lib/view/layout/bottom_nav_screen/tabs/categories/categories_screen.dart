import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import '../../../../../bloc/layout_cubit/categories_cubit/categories_states.dart';
import '../../../../../shared/components.dart';
import '../../../../../utilities/app_ui.dart';
import '../../../../../utilities/app_util.dart';
import '../home/shimmer/home_shimmer.dart';
import 'categories_tab.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Widget> tabs = [];
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              SizedBox(
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: AppUtil.responsiveHeight(context),
                child: BlocConsumer<CategoriesCubit, CategoriesState>(
                    buildWhen: (context, state) {
                      return state is CategoriesLoadingState ||
                          state is CategoriesEmptyState ||
                          state is CategoriesErrorState ||
                          state is CategoriesLoadedState;
                    },
                    listener: (context, state) {},
                    builder: (context, state) {
                      final cubit = CategoriesCubit.get(context);
                      if (state is CategoriesLoadingState) {
                        return const HomeShimmer();
                      }

                      if (state is CategoriesEmptyState) {
                        return Center(
                          child: CustomText(
                            text: "noCatAvailable".tr(),
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
                      tabs.clear();
                      for (var element in cubit.categoriesModel) {
                        tabs.add(
                          Tab(
                              child: Column(
                            children: [
                              Text(element.name!,
                                  style: TextStyle(
                                      color: AppUI.alshiakaColor,
                                      fontSize: 16,
                                      height: 1.3,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                              selected == element.name!
                                  ? Container(
                                      height: 5,
                                      margin: EdgeInsets.only(top: 5),
                                      width: double.parse(
                                          (element.name!.length * 10)
                                              .toString()),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  : SizedBox()
                            ],
                          )),
                        );
                      }
                      return DefaultTabController(
                        length: tabs.length,
                        initialIndex: cubit.catInitIndex,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: AppUI.whiteColor,
                              height: 39,
                              child: TabBar(
                                  onTap: (index) {
                                    cubit.catInitIndex = index;
                                    print(cubit.categoriesModel[index].id);
                                    selected =
                                        cubit.categoriesModel[index].name!;
                                    setState(() {});
                                    cubit.fetchSubCategories(
                                        cubit.categoriesModel[index].id);
                                    // cubit.fetchProductsByCategory(catId:  cubit.categoriesModel[index].id!, page: 1, perPage: 10);
                                    print(selected);
                                    print(
                                        "**********************************************************");
                                  },
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  indicatorPadding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtil.responsiveWidth(context) *
                                              0.01),
                                  indicatorWeight: 4,
                                  indicatorColor: AppUI.mainColor,
                                  isScrollable: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  physics: const BouncingScrollPhysics(),
                                  tabs: tabs),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black12.withOpacity(.1),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(tabs.length, (index) {
                                  return CategoriesTab(
                                      catId: cubit.categoriesModel[index].id!);
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
