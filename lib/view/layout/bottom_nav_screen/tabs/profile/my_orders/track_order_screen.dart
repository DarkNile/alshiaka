import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/models/checkout/orders_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../../utilities/app_ui.dart';
class TrackOrderScreen extends StatefulWidget {
  final OrdersModel? order;
  const TrackOrderScreen({Key? key,this.order}) : super(key: key);

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    track();
  }
  @override
  Widget build(BuildContext context) {
    final cubit= ProfileCubit.get(context);

    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: Column(
          children: [
            CustomAppBar(title: "yourOrder".tr()),
            const SizedBox(height: 20,),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text.rich(
                      TextSpan(
                          text: '${"orderId".tr()}: #${widget.order!.id} ',
                          children: <InlineSpan>[
                            // TextSpan(
                            //   text: 'beingProcessed'.tr(),
                            //   style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,color: AppUI.mainColor),
                            // ),
                          ]
                      )
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppUI.activeColor,
                            child: Icon(Icons.check,color: AppUI.whiteColor,size: 28,),
                          ),
                          CustomText(text: 'beingProcessed'.tr())
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 1,width: AppUtil.responsiveWidth(context)*0.15,color: AppUI.activeColor,
                     ),
                      const SizedBox(width: 10,),
                      Column(
                        children: [
                        cubit.trackResponse.isEmpty && cubit.tabState =="current"?CircleAvatar(
                          radius: 25,
                          backgroundColor: AppUI.backgroundColor,
                          child: SvgPicture.asset("${AppUI.iconPath}onway.svg"),
                        ):CircleAvatar(
                          radius: 25,
                          backgroundColor: AppUI.activeColor,
                          child: Icon(Icons.check,color: AppUI.whiteColor,size: 28,),
                        ),
                        CustomText(text: "onWay".tr(),)
                      ],
                      ),
                      const SizedBox(width: 10,),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 1,width: AppUtil.responsiveWidth(context)*0.15,color: cubit.tabState =="current"?AppUI.backgroundColor:AppUI.activeColor,
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        children: [
                          cubit.tabState =="current"?CircleAvatar(
                            radius: 25,
                            backgroundColor: AppUI.backgroundColor,
                            child: SvgPicture.asset("${AppUI.iconPath}delivered.svg"),
                          ):CircleAvatar(
                            radius: 25,
                            backgroundColor: AppUI.activeColor,
                            child: Icon(Icons.check,color: AppUI.whiteColor,size: 28,),
                          ),
                          CustomText(text: "delivered".tr(),)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                color: AppUI.whiteColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // InkWell(
                    //   onTap: (){
                    //     // AppUtil.mainNavigator(context, ContactUs());
                    //   },
                    //   child: Text.rich(
                    //       TextSpan(
                    //           text: 'Your order is paid any help contact our support team via the ',
                    //           children: <InlineSpan>[
                    //             TextSpan(
                    //               text: 'contact us ',
                    //               style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,color: AppUI.mainColor),
                    //             ),
                    //             const TextSpan(
                    //               text: 'from .',
                    //               style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100),
                    //             ),
                    //           ]
                    //       )
                    //   ),
                    // ),
                    const SizedBox(height: 20,),
                    CustomText(text: "orderDetails".tr(),fontSize: 18,),
                    const SizedBox(height: 20,),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: "${"trackOrder".tr()} : "),
                            const Spacer(),
                            CustomText(text: "${widget.order!.id}"),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            CustomText(text: "${"createdAt".tr()} : "),
                            const Spacer(),
                            CustomText(text: widget.order!.dateCreated!.substring(0,10)),
                          ],
                        ),
                        const SizedBox(height: 10,),

                        Row(
                          children: [
                            CustomText(text: "${"orderValue".tr()} : "),
                            const Spacer(),
                            CustomText(text: "${widget.order!.total} SAR"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  track() async {
    await ProfileCubit.get(context).track(widget.order!.id!);
    setState(() {});
  }
}
