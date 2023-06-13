import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/sub_sub_category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_carousel/main/light_carousel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../shared/components.dart';
import '../../../../../utilities/app_ui.dart';
import '../home/shimmer/home_shimmer.dart';

class CategoriesTab extends StatefulWidget {
  final int catId;

  const CategoriesTab({Key? key, required this.catId}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  ScrollController _scrollController = ScrollController();
  List<Widget> banners = [];
  late CategoriesCubit cubit;

  void initState() {
    super.initState();
    cubit = CategoriesCubit.get(context);
    Future.delayed(Duration.zero, () async {
      cubit.fetchSubCategories(widget.catId);
      await cubit.getProductsCount(catId: widget.catId);
      cubit.productPage = 1;
      cubit.fetchProductsByCategory(
          catId: widget.catId, page: cubit.productPage, perPage: 10);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (10 * cubit.productPage < cubit.productsCount!.count!) {
            cubit.productPage++;
            cubit.fetchProductsByCategory(
                catId: widget.catId, page: cubit.productPage, perPage: 10);
          }
        }
      });
    });
    print(cubit.categoriesModel[cubit.catInitIndex].image);
    print("ssssssssssssssssssssssssssssssssssssssssssssssssssssss");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //final cubit = CategoriesCubit.get(context);
    banners.clear();
    // for (var element in cubit.bannerModel) {
    banners.add(
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: "",
          height: 160,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.asset(
            "${AppUI.imgPath}banner.png",
            height: 150,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            "${AppUI.imgPath}banner.png",
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    // }
    return CheckNetwork(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              SizedBox(
                height: cubit.subCategoriesModel.isEmpty ? 0 : 65, //130
                child: BlocBuilder<CategoriesCubit, CategoriesState>(
                    buildWhen: (context, state) =>
                        state is SubCategoriesChangeState,
                    builder: (context, state) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: List.generate(cubit.subCategoriesModel.length,
                            (index) {
                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  cubit.fetchSubSubCategories(
                                      cubit.subCategoriesModel[index].id);
                                  if (cubit.subCategoriesModel[index].id! !=
                                      2570) {
                                    if (cubit.subSubCategoriesModel.isEmpty) {
                                      AppUtil.mainNavigator(
                                          context,
                                          ProductsScreen(
                                            catId: cubit
                                                .subCategoriesModel[index].id!,
                                            catName: cubit
                                                .subCategoriesModel[index]
                                                .name!,
                                          ));
                                    } else {
                                      AppUtil.mainNavigator(
                                          context,
                                          SubSubCategoryScreen(
                                            catName: cubit
                                                .subCategoriesModel[index]
                                                .name!,
                                          ));
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    if (cubit.subCategoriesModel[index].image !=
                                        null)
                                      CircleAvatar(
                                        radius: 38,
                                        backgroundColor: AppUI.blackColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 38,
                                            backgroundColor: AppUI.whiteColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: cubit
                                                              .subCategoriesModel[
                                                                  index]
                                                              .image!["src"] ==
                                                          null
                                                      ? ""
                                                      : cubit
                                                          .subCategoriesModel[
                                                              index]
                                                          .image!["src"],
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    "${AppUI.imgPath}story.png",
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    "${AppUI.imgPath}story.png",
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (cubit.subCategoriesModel[index].image !=
                                        null)
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    if (cubit.subCategoriesModel[index].id! !=
                                        2570)
                                      CustomText(
                                          text: cubit
                                              .subCategoriesModel[index].name)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          );
                        }),
                      );
                    }),
              ),
              cubit.subCategoriesModel.isEmpty ||
                      cubit.categoriesModel[cubit.catInitIndex].image == null
                  ? SizedBox()
                  : Container(
                      height: 130.0,
                      margin: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: LightCarousel(
                        images: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: cubit
                                  .categoriesModel[cubit.catInitIndex]
                                  .image!["src"],
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              // placeholder: (context, url) => Image.asset(
                              //   "${AppUI.imgPath}thope.png",
                              //   // height: 150,
                              //   fit: BoxFit.fill,
                              // ),
                              errorWidget: (context, url, error) => Image.asset(
                                "${AppUI.imgPath}thope.png",
                                // height: 170,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        dotSize: 5.0,
                        dotSpacing: 15.0,
                        dotColor: AppUI.whiteColor,
                        dotIncreasedColor: Colors.transparent,
                        indicatorBgPadding: 10.0,
                        dotBgColor: Colors.purple.withOpacity(0.0),
                        borderRadius: true,
                      )),
              BlocBuilder<CategoriesCubit, CategoriesState>(
                  buildWhen: (_, state) =>
                      state is ProductsLoadingState ||
                      state is ProductsLoadingPaginateState ||
                      state is ProductsEmptyState ||
                      state is ProductsErrorState ||
                      state is ProductsLoadedState ||
                      state is ChangeFavState,
                  builder: (context, state) {
                    if (state is ProductsLoadingState) {
                      return Shimmer.fromColors(
                          baseColor: AppUI.shimmerColor,
                          highlightColor: AppUI.whiteColor,
                          direction: AppUtil.rtlDirection(context)
                              ? ShimmerDirection.rtl
                              : ShimmerDirection.ltr,
                          child: const ProductsShimmer());
                    }
                    if (state is ProductsEmptyState) {
                      return Center(
                        child: CustomText(
                          text: "noProductsAvailable".tr(),
                          fontSize: 24,
                        ),
                      );
                    }

                    if (state is ProductsErrorState) {
                      return Center(
                        child: CustomText(
                          text: "error".tr(),
                          fontSize: 24,
                        ),
                      );
                    }
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.count(
                            controller: _scrollController,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            padding: const EdgeInsets.all(0),
                            crossAxisSpacing: 4.8,
                            childAspectRatio: (160 / 320),
                            children: List.generate(cubit.productModel.length,
                                (index) {
                              return ProductCard(
                                product: cubit.productModel[index],
                                onFav: () {
                                  cubit.favProduct(
                                      cubit.productModel[index], context);
                                },
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height:
                              state is ProductsLoadingPaginateState ? 90 : 0,
                          width: double.infinity,
                          child: Center(
                            child:
                                cubit.productPage == cubit.productModel.length
                                    ? const Text("No More Data")
                                    : const LoadingWidget(),
                          ),
                        )
                      ],
                    );
                  }),
              const SizedBox(
                height: 12,
              ),
              cubit.subCategoriesModel.isEmpty ||
                      cubit.categoriesModel[cubit.catInitIndex].image == null
                  ? SizedBox()
                  : Container(
                      height: 130.0,
                      width: double.infinity,
                      child: LightCarousel(
                        images: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: cubit
                                  .categoriesModel[cubit.catInitIndex]
                                  .image!["src"],
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                              // placeholder: (context, url) => Image.asset(
                              //   "${AppUI.imgPath}thope.png",
                              //   // height: 150,
                              //   fit: BoxFit.fill,
                              // ),
                              errorWidget: (context, url, error) => Image.asset(
                                "${AppUI.imgPath}thope.png",
                                // height: 170,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                        dotSize: 5.0,
                        dotSpacing: 15.0,
                        dotColor: AppUI.whiteColor,
                        dotIncreasedColor: Colors.transparent,
                        indicatorBgPadding: 10.0,
                        dotBgColor: Colors.purple.withOpacity(0.0),
                        borderRadius: true,
                      )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //cubit.productScrollController.dispose();
    // cubit.searchController.dispose();
    cubit.productModel.clear();
    //cubit.categoriesModel.clear();
    // cubit.allSubCategoriesModel.clear();
    cubit.productPage = 1;
  }
}
