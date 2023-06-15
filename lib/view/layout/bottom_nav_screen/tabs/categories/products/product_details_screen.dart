import 'package:ahshiaka/models/categories/products_model.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products/size_guide_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products/tabs/details.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products/tabs/info_and_care.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_carousel/main/light_carousel.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import '../../../../../../bloc/layout_cubit/categories_cubit/categories_states.dart';
import '../../../../../../shared/components.dart';
import '../products_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  CategoriesCubit? cubit;
  //ProductModel? product = ProductModel();
  List<List<bool>> optionVisibility = [];
  loadData() {
    print(widget.product.toJson());
    print(
        "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    // print(widget.product.categories[0]["id"]);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2");
    var cubit = CategoriesCubit.get(context);
    String cat = "";
    for (int i = 0; i < widget.product.categories.length; i++) {
      cat += widget.product.categories[i]["id"].toString();
      if (i != widget.product.categories.length - 1) {
        cat += "_";
      }
    }
    print(cat);
    print(
        "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    Future.delayed(Duration.zero, () async {
      cubit.fetchProductsByCategory2(
          catId: cat, page: cubit.productPage, perPage: 10);
      print(cubit.productModel.length);
      print(
          "lengthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      cubit.productPage = 1;
/*      cubit.productScrollController2.addListener(() {
        if (cubit.productScrollController2.position.pixels ==
            cubit.productScrollController2.position.maxScrollExtent) {
          if( 10 * cubit.productPage <  cubit.productsCount!.count!){
            cubit.productPage++;
            cubit.fetchProductsByCategory2(
                catId:  cat, page: cubit.productPage, perPage: 10);
          }
        }
      });*/
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //product = widget.product;
    cubit = CategoriesCubit.get(context);
    print(widget.product.id);
    if (widget.product.categories != null) {
      loadData();
    }
    print(
        "------------------------------------------------------------------------------------------");
    // widget.product.attributes!.removeWhere(
    //     (element) => element.variation == null ? false : !element.variation!);
    getCustomizations();
    CategoriesCubit.get(context).fetchProductVariations(widget.product.id);
    CategoriesCubit.get(context).fetchProductsReview(widget.product.id);
    CategoriesCubit.get(context).fetchRelatedProducts(
        catId: widget.product.categories == null ||
                widget.product.categories.isEmpty
            ? 0
            : widget.product.categories[0]['id'],
        page: 1,
        perPage: 15);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit!.productModel2 = [];
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    cubit = CategoriesCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppUI.backgroundColor,
                height: AppUtil.responsiveHeight(context) * .6,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (widget.product.images != null &&
                        widget.product.images!.isNotEmpty)
                      SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.6,
                          width: double.infinity,
                          child: LightCarousel(
                            images: List.generate(widget.product.images!.length,
                                (index) {
                              return CachedNetworkImage(
                                imageUrl: widget.product.image != null
                                    ? widget.product.image!['src']!
                                    : widget.product.images != null &&
                                            widget.product.images!.isNotEmpty
                                        ? widget.product.images![index].src
                                        : "",
                                height: AppUtil.responsiveHeight(context) * 0.8,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                // placeholder: (context, url) =>
                                //     const LoadingWidget(),
                                // placeholder: (context, url) => Image.asset(
                                //   "${AppUI.imgPath}men.png",
                                //   height: AppUtil.responsiveHeight(context) * 0.4,
                                //   width: double.infinity,
                                //   fit: BoxFit.fill,
                                // ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "${AppUI.imgPath}men.png",
                                  height:
                                      AppUtil.responsiveHeight(context) * 0.4,
                                  width: double.infinity,
                                ),
                              );
                            }),
                            dotSize: 7.0,
                            dotSpacing: 25.0,
                            dotColor: AppUI.mainColor.withOpacity(0.3),
                            dotPosition: AppUtil.rtlDirection(context)
                                ? DotPosition.bottomRight
                                : DotPosition.bottomLeft,
                            dotHorizontalPadding: 20,
                            dotIncreasedColor: AppUI.mainColor,
                            indicatorBgPadding: 0.0,
                            dotBgColor: Colors.purple.withOpacity(0.0),
                            borderRadius: true,
                          )),
                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: AppUtil.rtlDirection(context) ? null : 20,
                      right: AppUtil.rtlDirection(context) ? 20 : null,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: AppUI.whiteColor,
                          child: Center(
                              child: Icon(
                            AppUtil.rtlDirection(context)
                                ? Icons.arrow_back_ios
                                : Icons.arrow_back_ios_new,
                            color: AppUI.blackColor,
                            size: 17,
                          )),
                        ),
                      ),
                    ),
                    if (widget.product.salePrice != "")
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 30,
                        left: !AppUtil.rtlDirection(context) ? null : 20,
                        right: !AppUtil.rtlDirection(context) ? 20 : null,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomCard(
                              height: 30,
                              width: 50,
                              elevation: 0,
                              radius: 5,
                              color: AppUI.errorColor.withOpacity(0.13),
                              child: const SizedBox(),
                            ),
                            CustomText(
                              text:
                                  "${int.parse((100 - (int.parse(widget.product.salePrice!) / int.parse(widget.product.regularPrice == "" ? widget.product.price! : widget.product.regularPrice!)) * 100).round().toString())}%",
                              color: AppUI.errorColor,
                              fontSize: 10,
                            )
                          ],
                        ),
                      ),
                    Positioned(
                      bottom: 30,
                      left: !AppUtil.rtlDirection(context) ? null : 20,
                      right: !AppUtil.rtlDirection(context) ? 20 : null,
                      child: Column(
                        children: [
                          // CircleAvatar(
                          //   backgroundColor: AppUI.whiteColor,
                          //   child: Image.asset("${AppUI.imgPath}bag.png",color: AppUI.blackColor,),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<CategoriesCubit, CategoriesState>(
                              buildWhen: (context, state) {
                            return state is ChangeFavState;
                          }, builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                cubit!.favProduct(widget.product, context);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppUI.whiteColor,
                                child: Icon(
                                  widget.product.fav!
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.product.fav!
                                      ? AppUI.errorColor
                                      : AppUI.blackColor,
                                  size: 19,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              await FlutterShare.share(
                                  title: widget.product.name!,
                                  linkUrl: widget.product.permalink ??
                                      "https://alshiaka.com/en/product/rethobe-boys-2263-white/",
                                  chooserTitle: 'Share ${widget.product.name}');
                            },
                            child: CircleAvatar(
                              backgroundColor: AppUI.whiteColor,
                              child: Icon(
                                Icons.share,
                                color: AppUI.blackColor,
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      text: widget.product.name,
                      color: AppUI.iconColor.withOpacity(0.8),
                      fontSize: 13,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text:
                                  "${widget.product.salePrice == "" ? widget.product.price : widget.product.salePrice} SAR",
                              // color: widget.product.salePrice == ""
                              //     ? AppUI.mainColor
                              //     : AppUI.orangeColor,
                              color: widget.product.salePrice == ""
                                  ? Color(0xff13304f)
                                  : AppUI.orangeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            if (widget.product.salePrice != "")
                              CustomText(
                                text: "${widget.product.price} SAR",
                                color: AppUI.iconColor,
                                textDecoration: TextDecoration.lineThrough,
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: SizeConfig.iconSize,
                              width: SizeConfig.iconSize,
                              child: InkWell(
                                onTap: () {
                                  launch("https://www.facebook.com/Alshiakaa/");
                                },
                                child: SvgPicture.asset(
                                    "${AppUI.iconPath}face.svg"),
                              ),
                            ),
                            SizedBox(width: SizeConfig.padding / 4),
                            SizedBox(
                              height: SizeConfig.iconSize,
                              width: SizeConfig.iconSize,
                              child: InkWell(
                                onTap: () {
                                  launch("https://www.instagram.com/alshiaka/");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "${AppUI.iconPath}insta.svg",
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.instagram,
                                      color: AppUI.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.padding / 4),
                            SizedBox(
                              height: SizeConfig.iconSize,
                              width: SizeConfig.iconSize,
                              child: InkWell(
                                onTap: () {
                                  launch("https://twitter.com/alshiaka");
                                },
                                child: SvgPicture.asset(
                                  "${AppUI.iconPath}twitter.svg",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.padding / 4,
                            ),
                            SizedBox(
                              height: SizeConfig.iconSize,
                              width: SizeConfig.iconSize,
                              child: InkWell(
                                  onTap: () {
                                    launch(
                                        "https://www.youtube.com/channel/UC2mRhWAq9Jl5ByZssef3KKA");
                                  },
                                  child: SvgPicture.asset(
                                    "${AppUI.iconPath}youtube.svg",
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        width: AppUtil.responsiveWidth(context) * 0.9,
                        child: CustomText(
                          text: widget.product.description!.length < 3
                              ? widget.product.description
                              : widget.product.description!.substring(
                                  3, widget.product.description!.length - 5),
                          color: AppUI.blackColor,
                          fontSize: 16,
                        )),
                    //if(widget.product!.attributes!.isNotEmpty&&widget.product!.attributes![0].options!=null || widget.product!.attributes!.isEmpty)
                    //   BlocBuilder<CategoriesCubit,CategoriesState>(
                    //   buildWhen: (_,state) => state is ReviewsLoadedState,
                    //   builder: (context, state) {
                    //     return Row(
                    //       children: [
                    //         RatingBar.builder(
                    //           initialRating: double.parse(cubit!.averageCount.toString()),
                    //           minRating: 1,
                    //           direction: Axis.horizontal,
                    //           allowHalfRating: true,
                    //           itemCount: 5,
                    //           ignoreGestures: true,
                    //           itemSize: 18,
                    //           unratedColor: AppUI.iconColor.withOpacity(0.1),
                    //           onRatingUpdate: (rating) {
                    //             // cubit.setRate(rating);
                    //           },
                    //           itemBuilder: (BuildContext context, int index) {return const Icon(Icons.star,size: 30,color: Colors.amber,) ; },
                    //         ),
                    //         const SizedBox(width: 10,),
                    //         CustomText(text: "(${cubit!.averageCount.round()})",fontSize: 12,),
                    //       ],
                    //     );
                    //   }
                    // ),
                    //const SizedBox(height: 15,),
                    // Row(
                    //   children: [
                    //     CustomText(text: "${"color".tr()}: ",color: AppUI.iconColor,),
                    //     const CustomText(text: "Black",color: Colors.black,fontWeight: FontWeight.w500,),
                    //   ],
                    // ),
                    // const SizedBox(height: 5,),
                    // BlocBuilder<ProductCubit,ProductStates>(
                    //   builder: (context, state) {
                    //   final cubit = ProductCubit.get(context);
                    //     return SizedBox(
                    //       height: 80,
                    //       child: ListView(
                    //         shrinkWrap: true,
                    //         scrollDirection: Axis.horizontal,
                    //         children: List.generate(3, (index) {
                    //           return Row(
                    //             children: [
                    //               CustomCard(
                    //                 onTap: (){
                    //                   cubit.setSelectedColorIndex(index);
                    //                 },
                    //                 elevation: 0,height: 80,width: 60,radius: 10,padding: 0.0,
                    //                 border: cubit.selectedColorIndex==index?AppUI.mainColor:null,color: AppUI.backgroundColor,
                    //                 child: Image.asset("${AppUI.imgPath}men.png"),
                    //               ),
                    //               const SizedBox(width: 10,),
                    //             ],
                    //           );
                    //         }),
                    //       ),
                    //     );
                    //   }
                    // ),
                    // const SizedBox(height: 15,),
                    BlocBuilder<CategoriesCubit, CategoriesState>(
                        builder: (context, state) {
                      //TODO remove loading
                      if (cubit!.isLoading) {
                        return const Center(
                          child: LoadingWidget(),
                        );
                      }

                      // cubit = CategoriesCubit.get(context);
                      // return SizedBox(
                      //   width: AppUtil.responsiveWidth(context) * 0.9,
                      //   child: ListView(
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     children: List.generate(
                      //         widget.product.attributes!.length, (mainIndex) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     if (widget.product.attributes![mainIndex]
                          //             .options !=
                          //         null)
                          // CustomText(
                          //   text:
                          //       "${widget.product.attributes![mainIndex].name}: ${cubit!.selectedAttributeIndex.isEmpty ? widget.product.attributes![mainIndex].options![0] : cubit!.selectedAttributeIndex[mainIndex]['name']}",
                          //   color: AppUI.iconColor,
                          // )
                          //     else
                          //       CustomText(
                          //         text:
                          //             "${widget.product.attributes![mainIndex].name}: ${cubit!.selectedAttributeIndex.isEmpty ? widget.product.attributes![mainIndex].option : cubit!.selectedAttributeIndex[mainIndex]['name']}",
                          //         color: AppUI.iconColor,
                          //       ),
                          //     const Spacer(),
                          //     if (widget.product.attributes![mainIndex]
                          //             .name ==
                          //         "Size")
                          //       InkWell(
                          //           onTap: () {
                          //             AppUtil.mainNavigator(
                          //                 context,
                          //                 SizeGuideScreen(
                          //                   title: widget.product.name,
                          //                   options: widget
                          //                           .product
                          //                           .attributes![
                          //                               mainIndex]
                          //                           .options ??
                          //                       [
                          //                         widget
                          //                             .product
                          //                             .attributes![
                          //                                 mainIndex]
                          //                             .option!
                          //                       ],
                          //                   productId: widget.product.id
                          //                       .toString(),
                          //                 ));
                          //           },
                          //           child: CustomText(
                          //             text: "sizeGuide".tr(),
                          //             fontSize: 12,
                          //             color: AppUI.mainColor,
                          //           ))
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 7,
                          // ),
                          if (length > 1)
                            CustomText(
                              text: "Width".tr() + ': ' + size,
                              color: AppUI.iconColor,
                              fontWeight: FontWeight.bold,
                            ),
                          if (length > 1)
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      customizationMap.keys.toList().length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        CustomCard(
                                            onTap: () {
                                              setState(() {
                                                isSizeSelectedMap.clear();
                                                isTallSelectedMap.clear();
                                                tall = "selectLength".tr();
                                                isSizeSelectedMap.addAll({
                                                  index: true,
                                                });
                                                size = customizationMap.keys
                                                    .toList()[index];
                                                customizationValues =
                                                    customizationMap.values
                                                        .toList()[index]
                                                      ..removeWhere((element) =>
                                                          element
                                                              .last['status'] ==
                                                          'outofvariation');
                                              });
                                              cubit!.setCustomizations(
                                                  widget.product.id!,
                                                  null,
                                                  size,
                                                  '');
                                            },
                                            elevation: 0,
                                            height: 35,
                                            width: -1,
                                            radius: 10,
                                            padding: 0.0,
                                            color: AppUI.backgroundColor,
                                            border:
                                                isSizeSelectedMap[index] == true
                                                    ? AppUI.mainColor
                                                    : null,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: CustomText(
                                                textAlign: TextAlign.center,
                                                text: customizationMap.keys
                                                    .toList()[index],
                                              ),
                                            )),
                                      ],
                                    );
                                  }),
                            ),
                          if (isSizeSelectedMap.isNotEmpty)
                            const SizedBox(
                              height: 10,
                            ),
                          if (isSizeSelectedMap.isNotEmpty || length == 1)
                            CustomText(
                              text: int.tryParse(
                                          customizationValues.first.first) ==
                                      null
                                  ? "Width".tr() + ': ' + size
                                  : "Length".tr() + ': ' + tall,
                              color: AppUI.iconColor,
                              fontWeight: FontWeight.bold,
                            ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: customizationValues.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CustomCard(
                                          onTap: customizationValues[index]
                                                      .last['status'] ==
                                                  'outofstock'
                                              ? null
                                              : () {
                                                  setState(() {
                                                    isTallSelectedMap.clear();
                                                    isTallSelectedMap.addAll({
                                                      index: true,
                                                    });
                                                    variantId =
                                                        customizationValues[
                                                                index]
                                                            .last['id'];
                                                    print(variantId);
                                                    //
                                                    if (int.tryParse(
                                                            customizationValues
                                                                .first.first) ==
                                                        null) {
                                                      size =
                                                          customizationValues[
                                                                  index]
                                                              .first;
                                                    } else {
                                                      tall =
                                                          customizationValues[
                                                                  index]
                                                              .first;
                                                    }
                                                  });
                                                  if (length == 1) {
                                                    if (int.tryParse(
                                                            customizationValues
                                                                .first.first) ==
                                                        null) {
                                                      cubit!.setCustomizations(
                                                          widget.product.id!,
                                                          variantId,
                                                          size,
                                                          '');
                                                    } else {
                                                      cubit!.setCustomizations(
                                                          widget.product.id!,
                                                          variantId,
                                                          '',
                                                          tall);
                                                    }
                                                  } else {
                                                    cubit!.setCustomizations(
                                                        widget.product.id!,
                                                        variantId,
                                                        size,
                                                        tall);
                                                  }
                                                },
                                          elevation: 0,
                                          height: 35,
                                          width: -1,
                                          radius: 10,
                                          padding: 0.0,
                                          color: AppUI.backgroundColor,
                                          border:
                                              isTallSelectedMap[index] == true
                                                  ? AppUI.mainColor
                                                  : null,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              customizationValues[index].first,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                decoration: customizationValues[
                                                                index]
                                                            .last['status'] ==
                                                        'outofstock'
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          )),
                                    ],
                                  );
                                }),
                          ),
                          // SizedBox(
                          //   height: 40,
                          //   child: ListView(
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.horizontal,
                          //     children: List.generate(
                          //         widget.product.attributes![mainIndex]
                          //                     .options !=
                          //                 null
                          //             ? widget
                          //                 .product
                          //                 .attributes![mainIndex]
                          //                 .options!
                          //                 .length
                          //             : 1, (index) {
                          //       if (!optionVisibility[mainIndex][index]) {
                          //         return const SizedBox();
                          //       }
                          //       return Row(
                          //         children: [
                          //           CustomCard(
                          //             onTap: () {
                          //               cubit!.setSelectedAttributesIndex(
                          //                   index,
                          //                   mainIndex,
                          //                   widget
                          //                               .product
                          //                               .attributes![
                          //                                   mainIndex]
                          //                               .options !=
                          //                           null
                          //                       ? widget
                          //                           .product
                          //                           .attributes![
                          //                               mainIndex]
                          //                           .options![index]
                          //                       : widget
                          //                           .product
                          //                           .attributes![
                          //                               mainIndex]
                          //                           .option,
                          //                   widget
                          //                       .product
                          //                       .attributes![mainIndex]
                          //                       .id!);
                          //               int i = 0;
                          //               for (var element
                          //                   in optionVisibility[1]) {
                          //                 optionVisibility[1]
                          //                     .insert(i, false);
                          //                 optionVisibility[1]
                          //                     .removeAt(i + 1);
                          //                 i++;
                          //               }
                          //               print(optionVisibility[1]);
                          //               if (widget.product.attributes!
                          //                       .length >=
                          //                   2) {
                          //                 for (var element
                          //                     in cubit!.variations) {
                          //                   int y = 0;
                          //                   for (var element2
                          //                       in element.attributes!) {
                          //                     if (y > 0) {
                          //                       for (int i = 0;
                          //                           i <
                          //                               widget
                          //                                   .product
                          //                                   .attributes![
                          //                                       1]
                          //                                   .options!
                          //                                   .length;
                          //                           i++) {
                          //                         if (StringSimilarity.compareTwoStrings(
                          //                                     element2
                          //                                         .option!
                          //                                         .toLowerCase(),
                          //                                     widget
                          //                                         .product
                          //                                         .attributes![
                          //                                             1]
                          //                                         .options![
                          //                                             i]
                          //                                         .toLowerCase()) >
                          //                                 0.4 &&
                          //                             element2.option!
                          //                                     .length >=
                          //                                 widget
                          //                                     .product
                          //                                     .attributes![
                          //                                         1]
                          //                                     .options![i]
                          //                                     .length &&
                          //                             cubit!.selectedAttributeIndex[
                          //                                         0]
                          //                                     ['name'] ==
                          //                                 element
                          //                                     .attributes![
                          //                                         y - 1]
                          //                                     .option) {
                          //                           optionVisibility[1]
                          //                               [i] = true;
                          //                         }
                          //                       }
                          //                     }
                          //                     y++;
                          //                   }
                          //                 }
                          //               }
                          //             },
                          // elevation: 0,
                          // height: 35,
                          // width: -1,
                          // radius: 10,
                          // padding: 0.0,
                          // border:
                          //     cubit!.selectedAttributeIndex[
                          //                     mainIndex]
                          //                 ['index'] ==
                          //             index
                          //         ? AppUI.mainColor
                          //         : null,
                          // color: AppUI.backgroundColor,
                          //             child: Padding(
                          //               padding:
                          //                   const EdgeInsets.symmetric(
                          //                       horizontal: 20),
                          //               child: CustomText(
                          //                   text: widget
                          //                               .product
                          //                               .attributes![
                          //                                   mainIndex]
                          //                               .options !=
                          //                           null
                          //                       ? widget
                          //                           .product
                          //                           .attributes![
                          //                               mainIndex]
                          //                           .options![index]
                          //                       : widget
                          //                           .product
                          //                           .attributes![
                          //                               mainIndex]
                          //                           .option),
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 10,
                          //           ),
                          //         ],
                          //       );
                          //     }),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      );
                      // }),
                      //   ),
                      // );
                    }),
                  ],
                ),
              ),
              Container(
                height: 30,
                color: AppUI.backgroundColor,
                width: AppUtil.responsiveWidth(context),
              ),
              SizedBox(
                height: 200,
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                          indicatorWeight: 2,
                          indicatorColor: AppUI.mainColor,
                          unselectedLabelColor: AppUI.blackColor,
                          labelColor: AppUI.mainColor,
                          isScrollable: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: const BouncingScrollPhysics(),
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                "details".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Tab(
                              child: Text(
                                "infoAndCare".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                      Expanded(
                        child: TabBarView(children: <Widget>[
                          Details(
                            product: widget.product,
                            variantId: variantId,
                          ),
                          InfoAndCare(product: widget.product),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                color: AppUI.backgroundColor,
                width: AppUtil.responsiveWidth(context),
              ),
              //if(widget.product!.attributes!.isNotEmpty&&widget.product!.attributes![0].options!=null || widget.product!.attributes!.isEmpty)
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const SizedBox(height: 20,),
              //     BlocBuilder<CategoriesCubit,CategoriesState>(
              //         buildWhen: (_,state) => state is ReviewsLoadingState || state is ReviewsLoadedState || state is ReviewsErrorState || state is ReviewsEmptyState,
              //         builder: (context, state) {
              //           if(state is ReviewsLoadingState) {
              //             return const LoadingWidget();
              //           }
              //           if(state is ReviewsErrorState) {
              //             return Center(child: CustomText(
              //               text: "errorFetch".tr(), fontSize: 18,));
              //           }
              //           if(state is ReviewsEmptyState) {
              //             return Center(child: CustomText(text: "noReviewsAvailable".tr(),fontSize: 18,));
              //           }
              //
              //           return Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 CustomText(text: "rating".tr()),
              //                 const Divider(thickness: 1,),
              //                 const SizedBox(height: 10,),
              //                 Row(
              //                   children: [
              //                     Column(
              //                       children: [
              //                         CustomText(text: cubit!.averageCount.round().toString(),fontSize: 30,fontWeight: FontWeight.w600,),
              //                         CustomText(text: "${cubit!.reviewsModel.length} ${"rating".tr()}",),
              //                       ],
              //                     ),
              //                     const SizedBox(width: 30,),
              //                     Column(
              //                       children: [
              //                         SizedBox(
              //                           width: AppUtil.responsiveWidth(context)*0.7,
              //                           child: Row(
              //                             children: [
              //                               const CustomText(text: "5",fontSize: 18,),
              //                               const SizedBox(width: 2,),
              //                               Icon(Icons.star,color: AppUI.ratingColor,),
              //                               const SizedBox(width: 7,),
              //                               Expanded(
              //                                 flex: 9,
              //                                 child: ClipRRect(
              //                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
              //                                     child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppUI.ratingColor),minHeight: 12,value: cubit!.reviewsModel.isEmpty?0:cubit!.rating5/cubit!.reviewsModel.length,backgroundColor: AppUI.backgroundColor,)),
              //                               ),
              //                               const SizedBox(width: 10,),
              //                               Expanded(flex: 3,child: CustomText(text: cubit!.reviewsModel.isEmpty?"0 %":"${((cubit!.rating5/cubit!.reviewsModel.length)*100).round()} %",fontSize: 18,)),
              //                             ],
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: AppUtil.responsiveWidth(context)*0.7,
              //                           child: Row(
              //                             children: [
              //                               CustomText(text: "4",fontSize: 18,),
              //                               const SizedBox(width: 2,),
              //                               Icon(Icons.star,color: AppUI.ratingColor,),
              //                               const SizedBox(width: 7,),
              //                               Expanded(
              //                                 flex: 9,
              //                                 child: ClipRRect(
              //                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
              //                                     child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppUI.ratingColor),minHeight: 12,value: cubit!.reviewsModel.isEmpty?0:cubit!.rating4/cubit!.reviewsModel.length,backgroundColor: AppUI.backgroundColor,)),
              //                               ),
              //                               const SizedBox(width: 10,),
              //                               Expanded(flex: 3,child: CustomText(text: cubit!.reviewsModel.isEmpty?"0 %":"${((cubit!.rating4/cubit!.reviewsModel.length)*100).round()} %",fontSize: 18,)),
              //                             ],
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: AppUtil.responsiveWidth(context)*0.7,
              //                           child: Row(
              //                             children: [
              //                               const CustomText(text: "3",fontSize: 18,),
              //                               const SizedBox(width: 2,),
              //                               Icon(Icons.star,color: AppUI.ratingColor,),
              //                               const SizedBox(width: 7,),
              //                               Expanded(
              //                                 flex: 9,
              //                                 child: ClipRRect(
              //                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
              //                                     child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppUI.ratingColor),minHeight: 12,value: cubit!.reviewsModel.isEmpty?0:cubit!.rating3/cubit!.reviewsModel.length,backgroundColor: AppUI.backgroundColor,)),
              //                               ),
              //                               const SizedBox(width: 10,),
              //                               Expanded(flex: 3,child: CustomText(text: cubit!.reviewsModel.isEmpty?"0 %":"${((cubit!.rating3/cubit!.reviewsModel.length)*100).round()} %",fontSize: 18,)),
              //                             ],
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: AppUtil.responsiveWidth(context)*0.7,
              //                           child: Row(
              //                             children: [
              //                               const CustomText(text: "2",fontSize: 18,),
              //                               const SizedBox(width: 2,),
              //                               Icon(Icons.star,color: AppUI.ratingColor,),
              //                               const SizedBox(width: 7,),
              //                               Expanded(
              //                                 flex: 9,
              //                                 child: ClipRRect(
              //                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
              //                                     child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppUI.ratingColor),minHeight: 12,value: cubit!.reviewsModel.isEmpty?0:cubit!.rating2/cubit!.reviewsModel.length,backgroundColor: AppUI.backgroundColor,)),
              //                               ),
              //                               const SizedBox(width: 10,),
              //                               Expanded(flex: 3,child: CustomText(text: cubit!.reviewsModel.isEmpty?"0 %":"${((cubit!.rating2/cubit!.reviewsModel.length)*100).round()} %",fontSize: 18,)),
              //                             ],
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: AppUtil.responsiveWidth(context)*0.7,
              //                           child: Row(
              //                             children: [
              //                               const CustomText(text: "1",fontSize: 18,),
              //                               const SizedBox(width: 2,),
              //                               Icon(Icons.star,color: AppUI.ratingColor,),
              //                               const SizedBox(width: 7,),
              //                               Expanded(
              //                                 flex: 9,
              //                                 child: ClipRRect(
              //                                     borderRadius: const BorderRadius.all(Radius.circular(30)),
              //                                     child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppUI.ratingColor),minHeight: 12,value: cubit!.reviewsModel.isEmpty?0:cubit!.rating1/cubit!.reviewsModel.length,backgroundColor: AppUI.backgroundColor,)),
              //                               ),
              //                               const SizedBox(width: 10,),
              //                               Expanded(flex: 3,child: CustomText(text: cubit!.reviewsModel.isEmpty?"0 %":"${((cubit!.rating1/cubit!.reviewsModel.length)*100).round()} %",fontSize: 18,)),
              //                             ],
              //                           ),
              //                         ),
              //
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //
              //                 const SizedBox(height: 10,),
              //                 const Divider(thickness: 1,),
              //                 const SizedBox(height: 10,),
              //                 CustomText(text: "${"reviews".tr()} (${cubit!.reviewsModel.length})",color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w700,),
              //                 const SizedBox(height: 10,),
              //
              //                 Column(
              //                   children: List.generate(cubit!.reviewsModel.length, (index) {
              //                     return Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         RatingBar.builder(
              //                           initialRating: double.parse(cubit!.reviewsModel[index].rating.toString()),
              //                           minRating: 1,
              //                           direction: Axis.horizontal,
              //                           itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              //                           itemCount: 5,
              //                           ignoreGestures: true,
              //                           itemSize: 22,
              //                           unratedColor: AppUI.mainColor.withOpacity(0.1),
              //                           onRatingUpdate: (rating) {
              //                             // cubit.setRate(rating);
              //                           },
              //                           itemBuilder: (BuildContext context, int index) {return const Icon(Icons.star,size: 30,color: Colors.amber,) ; },
              //                         ),
              //                         const SizedBox(height: 10,),
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.start,
              //                           children: [
              //                             CustomText(text: cubit!.reviewsModel[index].name,color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w700,),
              //                             const SizedBox(width: 5,),
              //                             CustomText(text: cubit!.reviewsModel[index].dateCreated!.substring(0,10),),
              //                           ],
              //                         ),
              //                         CustomText(text: cubit!.reviewsModel[index].review,color: AppUI.blackColor,fontSize: 16,),
              //                         const Divider(thickness: 1,),
              //                       ],
              //                     );
              //                   }),
              //                 ),
              //               ],
              //             ),
              //           );
              //         }
              //     ),
              //     const SizedBox(height: 10,),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Column(
              //           children: [
              //             CustomText(text: "doYouOwnOrHaveUsedTheProduct".tr(),fontWeight: FontWeight.w600,textAlign: TextAlign.center,),
              //             CustomText(text: "tellUsYourOpinionByRating".tr(),textAlign: TextAlign.center,fontSize: 12,),
              //             const SizedBox(height: 10,),
              //             RatingBar.builder(
              //               initialRating: cubit!.rateAdded,
              //               minRating: 1,
              //               direction: Axis.horizontal,
              //               itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              //               itemCount: 5,
              //               itemSize: 35,
              //               unratedColor: AppUI.mainColor.withOpacity(0.1),
              //               onRatingUpdate: (rating) {
              //                 cubit!.rateAdded = rating;
              //               },
              //               itemBuilder: (BuildContext context, int index) {return const Icon(Icons.star,size: 30,color: Colors.amber,) ; },
              //             ),
              //             const SizedBox(height: 10,),
              //             SizedBox(width: AppUtil.responsiveWidth(context)*0.9,child: CustomInput(controller: cubit!.commentController,hint: "${"writeComment".tr()}...", textInputType: TextInputType.text,maxLines: 3,)),
              //             const SizedBox(height: 20,),
              //             BlocBuilder<CategoriesCubit,CategoriesState>(
              //                 buildWhen: (_,state) => state is AddReviewsLoadingState || state is AddReviewsLoadedState || state is AddReviewsErrorState ,
              //                 builder: (context, state) {
              //                   if(state is AddReviewsLoadingState){
              //                     return const LoadingWidget();
              //                   }
              //                   return CustomButton(text: "addReview".tr(),width: AppUtil.responsiveWidth(context)*0.9,onPressed: () async {
              //                     if(cubit!.commentController.text.isEmpty){
              //                       AppUtil.errorToast(context, "pleaseAddComment".tr());
              //                       return;
              //                     }
              //                     await cubit!.addReview(widget.product.id);
              //                     if(cubit!.addReviewResponse!['id']!=null){
              //                       if(!mounted)return;
              //                       cubit!.commentController.clear();
              //                       cubit!.rateAdded = 5;
              //                       AppUtil.successToast(context, "addedSuccessfully".tr());
              //                     }else{
              //                       if(!mounted)return;
              //                       AppUtil.errorToast(context, "someThingWrong".tr());
              //                     }
              //                   },);
              //                 }
              //             ),
              //             const SizedBox(height: 30,),
              //             Container(
              //               height: 30,color: AppUI.backgroundColor,width: AppUtil.responsiveWidth(context),
              //             ),
              //             const SizedBox(height: 30,),
              //
              //             SizedBox(
              //               width: AppUtil.responsiveWidth(context),
              //               child: Row(
              //                 children: [
              //                   InkWell(
              //                     onTap: (){
              //                       AppUtil.mainNavigator(context, ProductsScreen(catId: widget.product!.categories==null?0:widget.product!.categories[0]['id'], catName: "relatedProducts".tr()));
              //                     },
              //                     child: Padding(
              //                       padding: const EdgeInsets.symmetric(horizontal: 16),
              //                       child: Row(
              //                         children: [
              //                           CustomText(
              //                             text: "relatedProducts".tr(),
              //                             fontSize: 18,
              //                           ),
              //                            SizedBox(width: AppUtil.responsiveWidth(context)*0.48,),
              //                           CustomText(text: "seeMore".tr(),color: AppUI.mainColor,)
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const SizedBox(height: 10,),
              //             BlocBuilder<CategoriesCubit,CategoriesState>(
              //               buildWhen: (_,state) => state is RelatedProductsLoadingState || state is RelatedProductsLoadedState || state is RelatedProductsErrorState || state is RelatedProductsEmptyState || state is ChangeFavState,
              //               builder: (context, state) {
              //                 if(state is RelatedProductsLoadingState){
              //                   return const LoadingWidget();
              //                 }
              //                 return Padding(
              //                   padding: const EdgeInsets.symmetric(horizontal: 16),
              //                   child: SizedBox(
              //                     height: 320,
              //                     width: AppUtil.responsiveWidth(context)*0.92,
              //                     child: ListView(
              //                       shrinkWrap: true,
              //                       scrollDirection: Axis.horizontal,
              //                       children:
              //                       List.generate(cubit!.relatedProducts.length, (index) {
              //                         return Row(
              //                           children: [
              //                             SizedBox(
              //                               width: 170,
              //                               child: ProductCard(
              //                                 product: cubit!.relatedProducts[index],
              //                                 onFav: () {
              //                                   cubit!.favProduct(cubit!.relatedProducts[index],context);
              //                                 },
              //                               ),
              //                             ),
              //                             const SizedBox( width: 20,)
              //                           ],
              //                         );
              //                       }),
              //                     ),
              //                   ),
              //                 );
              //               }
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //           ],
              //         ),
              //       ],
              //     )
              //   ],
              // )
              cubit!.productModel2.length == 0
                  ? SizedBox()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                                context,
                                ProductsScreen(
                                    catId: widget.product.categoriesIds,
                                    catName: "recommended".tr()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                CustomText(
                                  text: "recommended".tr(),
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
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: AppUtil.rtlDirection(context) ? 0 : 10,
                              right: AppUtil.rtlDirection(context) ? 10 : 0),
                          child: Container(
                            height: 350,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  cubit!.productModel2.length, (index2) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: ProductCard(
                                        product: cubit!.productModel2[index2],
                                        onFav: () {
                                          cubit!.favProduct(
                                              cubit!.productModel2[index2],
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
                    )
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<CategoriesCubit, CategoriesState>(
            buildWhen: (_, state) =>
                state is AddCartErrorState ||
                state is AddCartLoadingState ||
                state is AddCartLoadedState,
            builder: (context, state) {
              final cubit = CategoriesCubit.get(context);
              if (state is AddCartLoadingState) {
                return const SizedBox(height: 75, child: LoadingWidget());
              }
              return CustomCard(
                height: 75,
                child: CustomButton(
                  text: "addToBag".tr(),
                  color: ((isSizeSelectedMap.isEmpty ||
                                  isTallSelectedMap.isEmpty) &&
                              length > 1) ||
                          (isTallSelectedMap.isEmpty && length == 1) ||
                          cubit!.isLoading
                      ? AppUI.greyColor
                      : AppUI.mainColor,
                  onPressed: ((isSizeSelectedMap.isEmpty ||
                                  isTallSelectedMap.isEmpty) &&
                              length > 1) ||
                          (isTallSelectedMap.isEmpty && length == 1) ||
                          cubit!.isLoading
                      ? null
                      : () async {
                          bool exists = await cubit.fetchItemInCart(
                              id: variantId != null
                                  ? variantId.toString()
                                  : widget.product.id.toString());
                          if (!exists) {
                            widget.product.qty = 1;
                          }
                          widget.product.mainProductId = variantId.toString();
                          if (!mounted) return;
                          cubit.addToCart(context, widget.product,
                              variantId: variantId != null
                                  ? variantId.toString()
                                  : widget.product.id.toString());
                        },
                ),
              );
            }),
      ),
    );
  }

  List<Map<String, dynamic>> customizations = [];
  Map<String, List<dynamic>> customizationMap = {};
  List<dynamic> customizationValues = [];
  String size = "selectWidth".tr();
  String tall = "selectLength".tr();
  Map isSizeSelectedMap = {};
  Map isTallSelectedMap = {};
  int length = 0;
  int variantId = 0;
  String details = '';

  getCustomizations() async {
    if (widget.product.attributes != null &&
        widget.product.attributes!.isNotEmpty) {
      customizations.clear();
      customizationMap.clear();
      customizationValues.clear();
      isSizeSelectedMap.clear();
      isTallSelectedMap.clear();
      await CategoriesCubit.get(context).getCustomizations(widget.product.id);
      length = cubit!.length;
      if (length > 1) {
        customizations = cubit!.customizations
            .map((e) => e as Map<String, dynamic>)
            .toList();
        for (int i = 0; i < customizations.length; i++) {
          customizations[i].forEach((key, value) {
            customizationMap.addAll({key: value});
          });
        }
      } else {
        customizationValues = cubit!.customizations
          ..removeWhere(
              (element) => element.last['status'] == 'outofvariation');
      }
      setState(() {});
    }
  }
}
