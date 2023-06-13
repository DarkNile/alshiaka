import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class SubSubCategoryScreen extends StatefulWidget {
  final String catName;
  const SubSubCategoryScreen({Key? key, required this.catName})
      : super(key: key);

  @override
  _SubSubCategoryScreenState createState() => _SubSubCategoryScreenState();
}

class _SubSubCategoryScreenState extends State<SubSubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: widget.catName),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CustomText(
                      text: "shopByProducts".tr(),
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Container(
                color: AppUI.whiteColor,
                child: BlocBuilder<CategoriesCubit, CategoriesState>(
                    buildWhen: (context, state) =>
                        state is SubCategoriesChangeState,
                    builder: (context, states) {
                      final cubit = CategoriesCubit.get(context);
                      return Column(
                        children: List.generate(
                            cubit.subSubCategoriesModel.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                AppUtil.mainNavigator(
                                    context,
                                    ProductsScreen(
                                      catId: cubit
                                          .subSubCategoriesModel[index].id!,
                                      catName: cubit
                                          .subSubCategoriesModel[index].name!,
                                    ));
                              },
                              // leading: CircleAvatar(
                              //   backgroundColor: AppUI.backgroundColor,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(50),
                              //     child: CachedNetworkImage(
                              //       imageUrl: cubit.subSubCategoriesModel[index]
                              //                   .image ==
                              //               null
                              //           ? ""
                              //           : cubit.subSubCategoriesModel[index]
                              //               .image!['image'],
                              //       placeholder: (context, url) => Image.asset(
                              //         "${AppUI.imgPath}men.png",
                              //       ),
                              //       errorWidget: (context, url, error) =>
                              //           Image.asset(
                              //         "${AppUI.imgPath}men.png",
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              title: CustomText(
                                  text:
                                      cubit.subSubCategoriesModel[index].name),
                            ),
                          );
                        }),
                      );
                    }),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(24.0),
              //   child: Row(
              //     children: [
              //       CustomText(text: "shopByBrand".tr(),fontWeight: FontWeight.w500,),
              //     ],
              //   ),
              // ),
              // Container(
              //   color: AppUI.whiteColor,
              //   child: Column(
              //     children: List.generate(7, (index) {
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             backgroundColor: AppUI.whiteColor,
              //             child: Image.asset("${AppUI.imgPath}brand.png"),
              //           ),
              //           title: const CustomText(text: "Reebok"),
              //         ),
              //       );
              //     }),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
