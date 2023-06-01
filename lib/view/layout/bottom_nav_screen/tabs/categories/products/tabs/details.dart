import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/models/categories/products_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Details extends StatelessWidget {
  final ProductModel product;
  final int variantId;

  const Details({
    Key? key,
    required this.product,
    required this.variantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = CategoriesCubit.get(context);
    if (variantId != 0 && cubit.variations.isNotEmpty) {
      // print('here ${cubit.variations[0].id}');
      // print('here ${cubit.variations[0].description}');
      var product = cubit.variations.firstWhereOrNull(
          (element) => element.id.toString() == variantId.toString());
      if (product != null) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomText(
            text: product.description,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomText(
            text: "noDetailsAvailableToThisProduct".tr(),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: CustomText(
          text: "noDetailsAvailableToThisProduct".tr(),
        ),
      );
    }
  }
}
