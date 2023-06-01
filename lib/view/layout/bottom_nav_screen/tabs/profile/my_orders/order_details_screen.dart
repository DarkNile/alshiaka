import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/checkout/orders_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/my_orders/track_order_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../../bloc/profile_cubit/profile_cubit.dart';
class OrderDetailsScreen extends StatefulWidget {
  final OrdersModel order;
  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final cubitProfile = ProfileCubit.get(context);

    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "myOrder".tr()),
              Column(
                children: [
                  const SizedBox(height: 20,),
                  Container(
                    width: AppUtil.responsiveWidth(context),
                    color: AppUI.whiteColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "${"orderId".tr()} :  #${widget.order.id}"),
                        const SizedBox(height: 10,),
                        CustomText(text: "${"orderDate".tr()} :  ${widget.order.dateCreated!.substring(0,10)}",color: AppUI.iconColor,),
                        const SizedBox(height: 20,),
                        const Divider(),
                        const SizedBox(height: 20,),
                        if(cubitProfile.tabState == "current")
                        Row(
                          children: [
                            CustomText(text: "trackOrder".tr()),
                            const Spacer(),
                            CustomText(text: "#${widget.order.id}")
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            CustomText(text: "orderValue".tr()),
                            const Spacer(),
                            CustomText(text: "${widget.order.total!} SAR")
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(text: "trackOrder".tr(),width: 150,color: AppUI.whiteColor,borderColor: AppUI.mainColor,textColor: AppUI.mainColor,onPressed: (){
                              AppUtil.mainNavigator(context, TrackOrderScreen(order: widget.order));

                            },),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    width: AppUtil.responsiveWidth(context),
                    color: AppUI.whiteColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: "shipping".tr()),
                            const Spacer(),
                            CustomText(text: "${widget.order.shippingLines![0].total}")
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            CustomText(text: "orderDate".tr(),),
                            const Spacer(),
                            CustomText(text: widget.order.dateCreated!.substring(0,10),),
                          ],
                        ),

                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            CustomText(text: "paymentMethod".tr(),),
                            const Spacer(),
                            CustomText(text: widget.order.paymentMethodTitle!,),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30,),
                  Container(
                    width: AppUtil.responsiveWidth(context),
                    color: AppUI.whiteColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "shippingAddress".tr(),fontSize: 18,),
                        const SizedBox(height: 15,),
                        CustomText(text: widget.order.shipping!.state,),
                        const SizedBox(height: 10,),
                        CustomText(text: widget.order.shipping!.address1,color: AppUI.iconColor,),
                        const SizedBox(height: 5,),
                        CustomText(text: widget.order.shipping!.address2,color: AppUI.iconColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    width: AppUtil.responsiveWidth(context),
                    color: AppUI.whiteColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.order.lineItems!.length, (index) {
                        return ProductCard(type: "order ${cubitProfile.tabState}",product: widget.order.lineItems![index],);
                      }),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
