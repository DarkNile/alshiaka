import 'package:ahshiaka/models/categories/products_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InfoAndCare extends StatelessWidget {
  final ProductModel? product;
  const InfoAndCare({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: [
        Row(
          children: [
            Expanded(
                child: CustomText(
              text: "status".tr(),
              fontWeight: FontWeight.w600,
            )),
            Expanded(
                child: CustomText(
              text: product!.stockStatus == "outofstock"
                  ? "outOfStock".tr()
                  : "inStock".tr(),
              color: AppUI.greyColor,
            )),
          ],
        ),
        if (product!.attributes!.isNotEmpty)
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: List.generate(product!.attributes!.length, (index) {
              if (!product!.attributes![index]['visible']!) {
                return const SizedBox();
              }
              return Row(
                children: [
                  Expanded(
                      child: CustomText(
                    text: product!.attributes![index]['name'].toString().tr(),
                    fontWeight: FontWeight.w600,
                  )),
                  Expanded(
                      child: CustomText(
                    text: product!.attributes![index]['options'] == null
                        ? product!.attributes![index]['option']
                        : product!.attributes![index]['options']!.join(","),
                    color: AppUI.greyColor,
                  )),
                ],
              );
            }),
          ),
      ],
    );
  }
}
