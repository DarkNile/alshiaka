import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products/product_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/components.dart';
import '../../../../utilities/app_ui.dart';
import '../../../../utilities/app_util.dart';
import 'home/shimmer/home_shimmer.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategoriesCubit.get(context).fetchFavProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
        child: Scaffold(
      backgroundColor: Colors.black12.withOpacity(.03),
      appBar: AppBar(
        title: Text(
          "wishList".tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          top: 16,
        ),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
            buildWhen: (_, state) =>
                state is ChangeFavState ||
                state is FavLoadingState ||
                state is FavEmptyState ||
                state is FavLoadedState ||
                state is FavErrorState,
            builder: (context, state) {
              final cubit = CategoriesCubit.get(context);
              if (state is FavLoadingState) {
                return Shimmer.fromColors(
                    baseColor: AppUI.shimmerColor,
                    highlightColor: AppUI.whiteColor,
                    direction: AppUtil.rtlDirection(context)
                        ? ShimmerDirection.rtl
                        : ShimmerDirection.ltr,
                    child: const ProductsShimmer(
                      type: "list",
                    ));
              }
              if (state is FavEmptyState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("${AppUI.imgPath}emptyBag.png", height: 200),
                      const SizedBox(
                        height: 50,
                        width: double.infinity,
                      ),
                      CustomText(
                        text: "noProductsFound".tr(),
                        fontSize: 18,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomText(
                        text: "shoppingInOurApp".tr(),
                        textAlign: TextAlign.center,
                        color: AppUI.iconColor,
                      )
                    ],
                  ),
                );
              }

              if (state is FavErrorState) {
                return Center(
                  child: CustomText(
                    text: "error".tr(),
                    fontSize: 24,
                  ),
                );
              }
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: List.generate(cubit.favProducts.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    padding:
                        EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        ProductCard(
                            type: "list",
                            isAddToCartShow: false,
                            product: cubit.favProducts[index],
                            onDelete: () {
                              cubit.removeFromFav(
                                  cubit.favProducts[index], context);
                            },
                            addToCart: () {
                              AppUtil.mainNavigator(
                                  context,
                                  ProductDetailsScreen(
                                      product: cubit.favProducts[index]));
                            }

                            //  () async {

                            //   List variant = await cubit.getVariationId(
                            //       cubit.variations, context,
                            //       fromFav: true);
                            //   if (variant[0] == -1) {
                            //     cubit.favProducts[index].qty = 1;
                            //   }
                            //   if (variant[0] != 0) {
                            //     for (var element in cubit.variations) {
                            //       if (element.id == variant[0]) {
                            //         element.name = cubit.favProducts[index].name;
                            //         element.mainProductId =
                            //             cubit.favProducts[index].id.toString();
                            //         if (!mounted) return;
                            //         cubit.addToCart(context, element);
                            //       }
                            //     }
                            //   } else {
                            //     bool exists = await cubit.fetchItemInCart(
                            //         id: cubit.favProducts[index].id.toString());
                            //     if (!exists) {
                            //       cubit.favProducts[index].qty = 1;
                            //     }
                            //     cubit.favProducts[index].mainProductId =
                            //         cubit.favProducts[index].id.toString();
                            //     if (!mounted) return;
                            //     cubit.addToCart(
                            //         context, cubit.favProducts[index]);
                            //   }
                            //   cubit.removeFromFav(
                            //       cubit.favProducts[index], context);
                            // },
                            ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     children: [
                        // InkWell(
                        //   onTap: (){
                        //     int variationId = cubit.getVariationId(cubit.favProducts[index]);
                        //     for (var element in cubit.favProducts[index].variations!) {
                        //       if(element.id == variationId){
                        //         cubit.addToCart(context, element);
                        //       }
                        //     }
                        //     },
                        //   child: Row(
                        //     children: [
                        //       Image.asset("${AppUI.imgPath}bag.png",color: AppUI.mainColor,),
                        //       const SizedBox(width: 5,),
                        //       CustomText(text: "addToBag".tr(),color: AppUI.mainColor,),
                        //     ],
                        //   ),
                        // ),
                        // const Spacer(),
                        // Image.asset("${AppUI.imgPath}edit.png"),
                        // const SizedBox(width: 10,),
                        // InkWell(
                        //   onTap: (){
                        //         cubit.removeFromFav(cubit.favProducts[index],cubit.productModel);
                        //   },
                        //     child: Image.asset("${AppUI.imgPath}trash.png")),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                        //const Divider(),
                        //const SizedBox(height: 5,)
                      ],
                    ),
                  );
                }),
              );
            }),
      ),
    ));
  }
}
