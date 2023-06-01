import 'package:ahshiaka/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../utilities/app_ui.dart';
import '../../../../../../utilities/app_util.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: AppUI.shimmerColor, highlightColor: AppUI.whiteColor,direction: AppUtil.rtlDirection(context)?ShimmerDirection.rtl:ShimmerDirection.ltr,
        child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: const [
                CustomCard(
                  height: 50,width: 60,padding: 0,
                  child: SizedBox(),
                ),
                SizedBox(width: 10,),
                CustomCard(
                  height: 50,width: 60,padding: 0,
                  child: SizedBox(),
                ),
                SizedBox(width: 10,),
                CustomCard(
                  height: 50,width: 60,padding: 0,
                  child: SizedBox(),
                ),
                SizedBox(width: 10,),
                CustomCard(
                  height: 50,width: 60,padding: 0,
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            const CustomCard(
              height: 170,
              child: SizedBox(),
            ),
            const SizedBox(height: 10,),
            const ProductsShimmer()
          ]
        ),
      ),
    ),
  );
}
}

class ProductsShimmer extends StatelessWidget {
  final String? type;
  const ProductsShimmer({Key? key,this.type = "grid"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == "grid"? GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(5),
      crossAxisSpacing: 10,
      childAspectRatio: (150/320),
      children: List.generate(8, (appointmentsIndex) {
        return const CustomCard(height: 300,child: SizedBox(),);
      }),
    ):ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(height: 100,width: 120,color: AppUI.shimmerColor,),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20,width: 120,color: AppUI.shimmerColor,),
                        const SizedBox(height: 7,),
                        Container(height: 20,width: 40,color: AppUI.shimmerColor,),
                        const SizedBox(height: 7,),
                        Container(height: 20,width: 70,color: AppUI.shimmerColor,),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(height: 20,width: 150,color: AppUI.shimmerColor,),
                    const Spacer(),
                    Container(height: 30,width: 30,color: AppUI.shimmerColor,),
                    const SizedBox(width: 7,),
                    Container(height: 30,width: 30,color: AppUI.shimmerColor,),
                  ],
                ),
                const SizedBox(height: 16,),
              ],
            );
      }),
    );
  }
}
