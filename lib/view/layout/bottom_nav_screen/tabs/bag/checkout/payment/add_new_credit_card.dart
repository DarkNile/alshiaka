import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../shared/components.dart';
import '../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../utilities/app_util.dart';

class AddNewCreditCard extends StatefulWidget {
  final String? orderId;
  const AddNewCreditCard({Key? key,this.orderId}) : super(key: key);

  @override
  _AddNewCreditCardState createState() => _AddNewCreditCardState();
}

class _AddNewCreditCardState extends State<AddNewCreditCard> {
  @override
  Widget build(BuildContext context) {
    final cubit = CheckoutCubit.get(context);
    return Scaffold(
      body: Column(
            children: [
              CustomAppBar(title: "addCard".tr()),
              SizedBox(
                height: AppUtil.responsiveHeight(context)-129,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<CheckoutCubit,CheckoutState>(
                          buildWhen: (_,state) => state is CreditCardChangeState,
                            builder: (context, snapshot) {
                              return CustomCreditCard(cardHolder: cubit.cardHolderController.text, cardNum: cubit.cardNumberController.text, expiryDate: cubit.expiryDateController.text, cvv: cubit.cvvController.text);
                            }
                           ),
                        const SizedBox(height: 20,),
                        CustomText(text: "NameOfCardholder".tr(),color: AppUI.greyColor,),
                        CustomInput(controller: cubit.cardHolderController, textInputType: TextInputType.text,onChange: (v){
                          cubit.emit(CreditCardChangeState());
                        },),
                        const SizedBox(height: 10,),
                        CustomText(text: "cardNumber".tr(),color: AppUI.greyColor,),
                        CustomInput(controller: cubit.cardNumberController, textInputType: TextInputType.number,onChange: (v){
                          cubit.emit(CreditCardChangeState());
                        },),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: "expiryDate".tr(),color: AppUI.greyColor,),
                                  CustomInput(controller: cubit.expiryDateController,hint: "12/28", textInputType: TextInputType.text,onChange: (v){
                                    cubit.emit(CreditCardChangeState());
                                  },),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: "CVV".tr(),color: AppUI.greyColor,),
                                  CustomInput(controller: cubit.cvvController, textInputType: TextInputType.text,onChange: (v){
                                    cubit.emit(CreditCardChangeState());
                                  },),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30,),
                        // Row(
                        //   children: [
                        //     CustomCard(
                        //       padding: 0.0,radius: 10,width: 30,height: 30,elevation: 0,
                        //       color: AppUI.orangeColor,
                        //       child: Icon(Icons.check,color: AppUI.whiteColor,),
                        //     ),
                        //     const SizedBox(width: 7,),
                        //     CustomText(text: "setAsMyDefaultAddress".tr())
                        //   ],
                        // ),
                        const SizedBox(height: 50,),
                        CustomButton(text: "save".tr(),onPressed: (){
                          if(cubit.cardHolderController.text.isEmpty && cubit.cardNumberController.text.isEmpty && cubit.expiryDateController.text.isEmpty && cubit.cvvController.text.isEmpty )
                          {
                            return ;
                          }
                          cubit.payWithPayfort(widget.orderId,context);
                        },)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
    );
  }
}
