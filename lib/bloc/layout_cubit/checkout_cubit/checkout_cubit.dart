import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/models/checkout/PaymentGetwayesModel.dart';
import 'package:ahshiaka/models/checkout/addresses_model.dart';
import 'package:ahshiaka/models/checkout/amount_aramex_model.dart';
import 'package:ahshiaka/models/checkout/country_model.dart';
import 'package:ahshiaka/models/checkout/coupons_model.dart';
import 'package:ahshiaka/models/checkout/orders_model.dart';
import 'package:ahshiaka/models/checkout/shipping_methods_model.dart';
import 'package:ahshiaka/models/checkout/shipping_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/otp_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/my_orders/my_orders_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart' as tabby;
import '../../../models/AddressLocalModel.dart';
import '../../../models/categories/products_model.dart';
import '../../../repository/checkout_repository.dart';
import '../../../shared/cash_helper.dart';
import '../../../utilities/app_util.dart';
import '../../../utilities/dbHelper.dart';
import 'MaskTextController.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  static CheckoutCubit get(context) => BlocProvider.of(context);

  List<ProductModel> cartList = [];
  List<int> qty = [];
  double total = 0.0;
  int couponValue = 0;
  bool flatRateApply = false;
  bool couponApplied = false;
  var couponController = TextEditingController();

  fetchCartList(context) async {
    String email = await CashHelper.getSavedString("email", "");
    qty.clear();
    total = 0.0;
    cartList.clear();
    String cartListString =
        await CashHelper.getSavedString("${email}cartList", "");
    if (cartListString == "") {
      return;
    } else {
      print(cartListString);
      jsonDecode(cartListString).forEach((element) {
        cartList.add(ProductModel.fromJson(element));
      });
      List<ProductModel> favProducts = CategoriesCubit.get(context).favProducts;

      for (var element in cartList) {
        for (var favProduct in favProducts) {
          if (element.id == favProduct.id) {
            element.fav = true;
          }
        }
        total += double.parse(element.price!.toString()) *
            int.parse(element.qty.toString());
        qty.add(element.qty!);
      }
    }
    total -= couponValue;

    emit(CheckoutChangeState());
  }

  removeCartItemItem(ProductModel product, int index, context) async {
    String email = await CashHelper.getSavedString("email", "");
    qty.removeAt(index);
    cartList.remove(product);
    CashHelper.setSavedString("${email}cartList", jsonEncode(cartList));
    fetchCartList(context);
    emit(CheckoutChangeState());
  }

  changeQuantity(id, qty, type, context) async {
    // print(qty);
    for (var element in cartList) {
      if (element.mainProductId.toString() == id.toString()) {
        element.qty = qty;
        if (type == "increment") {
          total += double.parse(element.price!);
        } else {
          total -= double.parse(element.price!);
        }
      }
    }
    // print(cartList[0].qty);
    String email = await CashHelper.getSavedString("email", "");
    CashHelper.setSavedString("${email}cartList", jsonEncode(cartList));
    fetchCartList(context);
    emit(CheckoutChangeState());
  }

  List<CouponsModel> couponsModel = [];

  fetchCoupons() async {
    try {
      var response = await CheckoutRepository.fetchCoupons();
      response.forEach((element) {
        couponsModel.add(CouponsModel.fromJson(element));
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  applyCoupon(context) async {
    if (AppUtil.isEmailValidate(couponController.text)) {
      AppUtil.dialog2(context, "", [
        const LoadingWidget(),
        const SizedBox(
          height: 30,
        ),
      ]);
      var map = await CheckoutRepository.hasCode(couponController.text);
      Navigator.of(context, rootNavigator: true).pop();
      if (map is! List) {
        for (var element in couponsModel) {
          if (map['code'].toString().toLowerCase() == element.code) {
            for (var data in element.metaData!) {
              if (data.key == "_no_free_shipping_checkbox") {
                if (data.value == "yes") {
                  flatRateApply = true;
                  couponApplied = true;
                  break;
                }
              }
              if (!flatRateApply) {
                couponValue = int.parse(element.amount!.split(".")[0]);
                total = total - couponValue;
                if (total < 0) {
                  total = 0;
                }
                couponApplied = true;
                break;
              }
            }
          }
        }
      } else {
        AppUtil.errorToast(context, "couponNotFound".tr());
        return;
      }
    } else {
      for (var element in couponsModel) {
        if (couponController.text == element.code) {
          for (var data in element.metaData!) {
            if (data.key == "_no_free_shipping_checkbox") {
              if (data.value == "yes") {
                flatRateApply = true;
                couponApplied = true;
                break;
              }
            }
            if (!flatRateApply) {
              couponValue = int.parse(element.amount!.split(".")[0]);
              total = total - couponValue;
              if (total < 0) {
                total = 0;
              }
              couponApplied = true;
              break;
            }
          }
        }
      }
    }
    if (couponApplied) {
      AppUtil.successToast(context, "couponAppliedSuccessfully".tr());
    } else {
      AppUtil.errorToast(context, "couponNotFound".tr());
    }
    emit(ApplyCoupon());
  }

  cancelCoupon() {
    total += couponValue;
    couponValue = 0;
    flatRateApply = false;
    couponApplied = false;
    emit(ApplyCoupon());
  }

  // addresses variables
  var nameController = TextEditingController();
  var surNameController = TextEditingController();
  var nameController2 = TextEditingController();
  var surNameController2 = TextEditingController();
  var phoneController = TextEditingController();
  String phoneCode = '';
  PhoneNumber phoneNumber = PhoneNumber(dialCode: "+966", isoCode: "SA");
  var emailController = TextEditingController();
  var emailController2 = TextEditingController();
  var addressController = TextEditingController();
  var stateController = TextEditingController();
  var address2Controller = TextEditingController();
  var postCodeController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();
  bool defaultAddress = false;
  changeDefaultState() {
    defaultAddress = !defaultAddress;
    emit(AddressesState());
  }

  DbHelper db = new DbHelper();
  List dataLocal = [];
  loadaddresslocal() async {
    dataLocal = await db.allProduct();
    // mainProvider.ResetCounter();
    /*   for(int i=0;i<dataLocal.length;i++){
      mainProvider.ChangeCounter("+");
    }*/
    log("Load Address Local\n" + dataLocal.toString());
    print("adress local local local local local local");
    emit(AddressesState());
  }

  saveAddress(context,
      {String? address_id,
      required bool isquest,
      required String selectedRegion,
      required String selectedCity}) async {
    final bool isKsa = (selectedState == AppUtil.ksa);
    log("isKsa : ${isKsa}");
    log("First Name: ${nameController2.text}");
    log("Last Name: ${surNameController2.text}");
    log("phone: ${phoneController.text}");
    log("state: ${stateController.text}");
    log("selectedRegion: ${selectedRegion}");
    log("selectedCity: ${selectedCity}");
    log("state: ${stateController.text}");
    log("address: ${addressController.text}");
    log("code: ${postCodeController.text}");
    if (isquest) {
      AddressMedelLocal c = new AddressMedelLocal({
        "firstname": nameController2.text,
        "lastname": surNameController2.text,
        "phone": phoneController.text,
        "email": emailController2.text,
        "state": stateController.text,
        "region": selectedRegion,
        "city": selectedCity,
        "address": isKsa ? addressController.text : selectedCity,
        "code": postCodeController.text,
      });
      log("Save Address to Local DB");

      int x = await db.addToCart(c, address_id);
      print(x);
      print(db.allProduct());
      print(
          "*******************************************************************************");
      loadaddresslocal();
      AppUtil.successToast(context, "addedSuccessfully".tr());
      // Navigator.of(context, rootNavigator: true).pop();
      // Navigator.of(context, rootNavigator: true).pop();
      AppUtil.mainNavigator(
          context,
          AddressesScreen(
            isquest: isquest,
          ));
      nameController2.clear();
      surNameController2.clear();
      countryController.clear();
      addressController.clear();
      cityController.clear();
      address2Controller.clear();
      stateController.clear();
      postCodeController.clear();
      phoneController.clear();
      emailController2.clear();
    } else {
      Map<String, dynamic> formData = {
        "shipping_first_name": nameController2.text,
        "shipping_last_name": surNameController2.text,
        "shipping_country": selectedRegion,
        "shipping_address_1":
            isKsa ? addressController.text : stateController.text,
        "shipping_city": selectedCity,
        "shipping_company": "test any value",
        "shipping_address_2": isKsa ? addressController.text : selectedCity,
        "shipping_state": stateController.text,
        "shipping_postcode": postCodeController.text,
        "shipping_phone": phoneController.text,
        "shipping_email": emailController2.text
      };
      log("formData ${formData.values}");
      // print(formData.values);
      String email = await CashHelper.getSavedString("email", "");

      try {
        var response = await CheckoutRepository.saveAddress(formData, email,
            address_id: address_id);
        if (response is String) {
          saveAddress(context,
              isquest: false,
              selectedCity: selectedCity,
              selectedRegion: selectedRegion);
          return;
        }
        // Navigator.of(context, rootNavigator: true).pop();
        // Navigator.of(context, rootNavigator: true).pop();
        AppUtil.successToast(context, "addedSuccessfully".tr());
        AppUtil.mainNavigator(
            context,
            AddressesScreen(
              isquest: isquest,
            ));
        fetchAddresses();
        if (address_id == null) {
          nameController.clear();
          surNameController.clear();
          countryController.clear();
          addressController.clear();
          cityController.clear();
          address2Controller.clear();
          stateController.clear();
          postCodeController.clear();
          phoneController.clear();
          emailController.clear();
        }
      } catch (e) {
        log("Adressss Error : ${e.toString()}");
        return Future.error(e);
      }
      fetchAddresses();
    }
  }

  ShippingModel? addresses;

  AddressesModel? selectedAddress;

  fetchAddresses() async {
    String email = await CashHelper.getSavedString("email", "");
    print(email);

    try {
      var response = await CheckoutRepository.fetchAddresses(email);
      if (response != null && response["shipping"] is! List) {
        addresses = ShippingModel.fromJson(response);
        if (addresses!.shipping != null &&
            addresses!.shipping!.address0!.isNotEmpty) {
          log("Fetch Addresses \n" + response.toString());
          print(
              "address not emptyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
          selectedAddress = AddressesModel(
              fullName: addresses!.shipping!.address0![0].shippingFirstName,
              surName: addresses!.shipping!.address0![0].shippingLastName,
              phoneNumber: addresses!.shipping!.address0![0].shippingPhone,
              email: addresses!.shipping!.address0![0].shippingEmail,
              address: addresses!.shipping!.address0![0].shippingAddress1,
              state: addresses!.shipping!.address0![0].shippingState,
              address2: addresses!.shipping!.address0![0].shippingAddress2,
              city: addresses!.shipping!.address0![0].shippingCity,
              postCode: addresses!.shipping!.address0![0].shippingPostcode,
              country: addresses!.shipping!.address0![0].shippingCountry,
              defaultAddress: 0 == 0 ? true : false);
        }
      } else {
        selectedAddress = null;
        addresses = null;
      }
    } catch (e) {
      return Future.error(e);
    }
    emit(AddressesState());
  }

  deleteAddress(addressKey) async {
    String email = await CashHelper.getSavedString("email", "");

    try {
      Map<String, dynamic> response =
          await CheckoutRepository.deleteAddress(addressKey, email);
      fetchAddresses();
    } catch (e) {
      return Future.error(e);
    }
  }

  //shipping
  List<ShippingMethodsModel> shippingMethods = [];
  ShippingMethodsModel? selectedShippingMethods;
  Map<String, dynamic> freeShippingMethods = {};

  fetchShippingMethods() async {
    shippingMethods.clear();
    try {
      var response = await CheckoutRepository.fetchShippingMethods();
      response.forEach((element) {
        if (element['enabled']) {
          shippingMethods.add(ShippingMethodsModel.fromJson(element));
        }
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  fetchFreeShippingMethods() async {
    freeShippingMethods.clear();
    try {
      var response = await CheckoutRepository.fetchFreeShippingMethods();
      freeShippingMethods.addAll(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  sendPhone(phone) async {
    try {
      var response = await CheckoutRepository.sendPhone(phone);
      print(response);
      return response;
    } catch (e) {
      log("Send Phone Error : ${e.toString()}");
      return Future.error(e);
    }
  }

  verifyPhone(phone, code) async {
    try {
      var response = await CheckoutRepository.verifyPhone(phone, code);
      print(response);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  sendEmail(orderId) async {
    try {
      var response = await CheckoutRepository.sendEmail(orderId);
      print(response);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

//payment
  List<PaymentGetwayesModel> paymentGetaway = [];
  List<PaymentGetwayesModel> paymentGetawayNoCash = [];
  PaymentGetwayesModel? selectedPaymentGetaways;

  fetchPaymentGetaways() async {
    paymentGetaway.clear();
    paymentGetawayNoCash.clear();
    try {
      var response = await CheckoutRepository.fetchPaymentGetaways();
      response.forEach((element) {
        if (element['enabled']) {
          if (element['id'] == 'cod' ||
              element['id'] == 'paytabs_all' ||
              element['id'] == 'tabby_installments') {
            paymentGetaway.add(PaymentGetwayesModel.fromJson(element));
          }
          if (element['id'] == 'paytabs_all') {
            paymentGetawayNoCash.add(PaymentGetwayesModel.fromJson(element));
          }
        }
      });
      // if (Platform.isIOS) {
      //   paymentGetaway
      //       .add(PaymentGetwayesModel(id: 'apple_pay', title: 'Apple Pay'));
      // }
    } catch (e) {
      return Future.error(e);
    }
  }

//create order
  createOrder(context) async {
    emit(CheckoutLoadingState());
    String email = await CashHelper.getSavedString("email", "");
    if (email != "") {
      selectedAddress!.email = email;
    } else {
      CashHelper.setSavedString("guestEmail", selectedAddress!.email!);
    }
    List lineItems = [];
    List shippingLines = [];
    for (var element in cartList) {
      print("element.mainProductId ${element.mainProductId}");
      lineItems.add({
        "product_id": element.mainProductId != null
            ? element.mainProductId!.toString()
            : element.id!.toString(),
        "quantity": element.qty.toString()
      });
    }

    if (selectedShippingMethods != null) {
      shippingLines.add({
        "method_id": selectedShippingMethods!.id,
        "method_title": selectedShippingMethods!.title,
        "total": selectedShippingMethods!.settings!.cost == null
            ? "0"
            : selectedShippingMethods!.settings!.cost!.value
      });
    }
    Map<String, dynamic> formData = {
      "status": selectedPaymentGetaways!.id == "cod" ? "processing" : "pending",
      "payment_method": selectedPaymentGetaways!.id,
      "payment_method_title": selectedPaymentGetaways!.title,
      "set_paid": false,
      "billing": {
        "first_name": selectedAddress!.fullName,
        "last_name": selectedAddress!.fullName,
        "address_1": selectedAddress!.address,
        "address_2": selectedAddress!.address2,
        "city": selectedAddress!.city,
        "state": selectedAddress!.state,
        "postcode": selectedAddress!.postCode,
        "country": "SA",
        "email": selectedAddress!.email,
        "phone": selectedAddress!.phoneNumber
      },
      "shipping": {
        "first_name": selectedAddress!.fullName,
        "last_name": selectedAddress!.fullName,
        "address_1": selectedAddress!.address,
        "address_2": selectedAddress!.address2,
        "city": selectedAddress!.city,
        "state": selectedAddress!.state,
        "postcode": selectedAddress!.postCode,
        "country": "SA",
        "email": selectedAddress!.email,
        "phone": selectedAddress!.phoneNumber
      },
      "coupon_lines": couponApplied
          ? [
              {"code": couponController.text}
            ]
          : null,
      "line_items": lineItems,
      "shipping_lines": shippingLines,
      "fee_lines": selectedPaymentGetaways!.id == "cod"
          ? [
              {
                "name": "Cash on delivery fees",
                "total": "5.75",
                "tax_status": "none"
              }
            ]
          : null,
      "meta_data": [
        {"key": "order_origin", "value": "mobile app"}
      ],
    };

    try {
      var response = await CheckoutRepository.createOrder(jsonEncode(formData),
          customer: ProfileCubit.get(context).profileModel.isEmpty
              ? "0"
              : ProfileCubit.get(context).profileModel[0].id);
      String email = await CashHelper.getSavedString("email", "");
      CashHelper.setSavedString("${email}cartList", "");
      await fetchCartList(context);
      emit(CheckoutChangeState());
      return response;
    } catch (e) {
      emit(CheckoutErrorState());
      return Future.error(e);
    }
  }

  //? ========= Total Aramex =========
  AmountAramexModel? amountAramexModel;
  Future<AmountAramexModel?> getTaxAramex(
      {required BuildContext context,
      required String country,
      required String city,
      required String numberOfPieces,
      required String actualWeight}) async {
    emit(GetTotalLoadingState());
    try {
      log("getTotalAramex");
      var response = await CheckoutRepository.getTaxAramex(
          country: country,
          city: city,
          actualWeight: actualWeight,
          numberOfPieces: numberOfPieces);
      log("response ${response.statusCode}");
      var data = jsonDecode(response.body);
      log("response ${data}");
      if (response.body.contains('error')) {
        emit(GetTotalErrorState(response.body));
        return null;
      } else {
        amountAramexModel = AmountAramexModel.fromJson(data);
        emit(GetTotalLoadedState(amountAramexModel!));
        return amountAramexModel;
      }
    } catch (e) {
      log("error getTotalAramex ${e}");
      emit(GetTotalErrorState(e.toString()));
    }
    return null;
  }

  //create order
  applePayCreateOrder(context, status) async {
    emit(CheckoutLoadingState());
    String email = await CashHelper.getSavedString("email", "");
    if (email != "") {
      selectedAddress!.email = email;
    } else {
      CashHelper.setSavedString("guestEmail", selectedAddress!.email!);
    }
    List lineItems = [];
    List shippingLines = [];
    for (var element in cartList) {
      print("element.mainProductId ${element.mainProductId}");
      lineItems.add({
        "product_id": element.mainProductId != null
            ? element.mainProductId!.toString()
            : element.id!.toString(),
        "quantity": element.qty.toString()
      });
    }

    if (selectedShippingMethods != null) {
      shippingLines.add({
        "method_id": selectedShippingMethods!.id,
        "method_title": selectedShippingMethods!.title,
        "total": selectedShippingMethods!.settings!.cost == null
            ? "0"
            : selectedShippingMethods!.settings!.cost!.value
      });
    }
    Map<String, dynamic> formData = {
      "status": status,
      "payment_method": selectedPaymentGetaways!.id,
      "payment_method_title": selectedPaymentGetaways!.title,
      "set_paid": false,
      "billing": {
        "first_name": selectedAddress!.fullName,
        "last_name": selectedAddress!.fullName,
        "address_1": selectedAddress!.address,
        "address_2": selectedAddress!.address2,
        "city": selectedAddress!.city,
        "state": selectedAddress!.state,
        "postcode": selectedAddress!.postCode,
        "country": "SA",
        "email": selectedAddress!.email,
        "phone": selectedAddress!.phoneNumber
      },
      "shipping": {
        "first_name": selectedAddress!.fullName,
        "last_name": selectedAddress!.fullName,
        "address_1": selectedAddress!.address,
        "address_2": selectedAddress!.address2,
        "city": selectedAddress!.city,
        "state": selectedAddress!.state,
        "postcode": selectedAddress!.postCode,
        "country": "SA",
        "email": selectedAddress!.email,
        "phone": selectedAddress!.phoneNumber
      },
      "coupon_lines": couponApplied
          ? [
              {"code": couponController.text}
            ]
          : null,
      "line_items": lineItems,
      "shipping_lines": shippingLines,
      "fee_lines": selectedPaymentGetaways!.id == "cod"
          ? [
              {
                "name": "Cash on delivery fees",
                "total": "5.75",
                "tax_status": "none"
              }
            ]
          : null,
    };

    try {
      var response = await CheckoutRepository.createOrder(jsonEncode(formData),
          customer: ProfileCubit.get(context).profileModel.isEmpty
              ? "0"
              : ProfileCubit.get(context).profileModel[0].id);
      if (status == "processing") {
        String email = await CashHelper.getSavedString("email", "");
        CashHelper.setSavedString("${email}cartList", "");
        await fetchCartList(context);
        emit(CheckoutChangeState());
      }
      return response;
    } catch (e) {
      emit(CheckoutErrorState());
      return Future.error(e);
    }
  }

  //payment credit cards
  //var cardHolderController = TextEditingController();
  //var cardNumberController = TextEditingController();
  //var expiryDateController = TextEditingController();
  //var cvvController = TextEditingController();

  MaskedTextController cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cvvController = MaskedTextController(mask: '000');

  payWithPayfort(orderId, context) async {
    Map formData = {
      "command": "CAPTURE",
      "access_code": "zx0IPmPy5jp1vAz8Kpg7",
      "merchant_identifier": "CycHZxVj",
      "merchant_reference": "XYZ9239-yu898",
      "amount": total.toString(),
      "currency": "AED",
      "language": "en",
      "fort_id": "149295435400084008",
      "signature": "7cad05f0212ed933c9a5d5dffa31661acf2c827a",
      "order_description": "iPhone 6-S",
      "card_holder_name": cardHolderController.text,
      "expiry_date": expiryDateController.text,
      "card_number": cardNumberController.text.trim(),
      "cvv": cvvController.text
    };
    int response = await CheckoutRepository.payWithPayfort(formData);
    if (response == 200) {
      await CheckoutRepository.updateOrder(orderId);
      AppUtil.mainNavigator(context, const MyOrdersScreen());
    }
  }

  // testTabby(context) async {
  //   final tabbySdk = tabby.TabbyFlutterSdk();
  //   tabbySdk.setApiKey("Your Public Key");
  //   final payload = tabby.TabbyCheckoutPayload(
  //       merchantCode: "eyewa",
  //       lang: tabby.Language.en,
  //       payment: tabby.Payment(
  //           amount: (selectedPaymentGetaways != null &&
  //                       selectedPaymentGetaways!.id == "cod"
  //                   ? (selectedShippingMethods != null
  //                           ? selectedShippingMethods!.methodId == "flat_rate"
  //                               ? total +
  //                                   double.parse(selectedShippingMethods!
  //                                       .settings!.cost!.value!)
  //                               : total
  //                           : total) +
  //                       5
  //                   : (selectedShippingMethods != null
  //                       ? selectedShippingMethods!.methodId == "flat_rate"
  //                           ? total +
  //                               double.parse(selectedShippingMethods!
  //                                   .settings!.cost!.value!)
  //                           : total
  //                       : total))
  //               .toString(),
  //           description: "Just a dest payment",
  //           currency: tabby.Currency.AED,
  //           buyer: tabby.Buyer(
  //               email: "successful.payment@tabby.ai",
  //               phone: selectedAddress!.phoneNumber!,
  //               name: "Test Name"),
  //           order: tabby.Order(
  //               referenceId: "#xxxx-xxxxxx-xxxx",
  //               items: [
  //                 tabby.OrderItem(
  //                     description: "Jersey",
  //                     productUrl: "https://tabby.store/p/SKU123",
  //                     quantity: 1,
  //                     referenceId: "SKU123",
  //                     title: "Pink jersey",
  //                     unitPrice: "300")
  //               ],
  //               shippingAmount: "21",
  //               taxAmount: "0"),
  //           shippingAddress: tabby.ShippingAddress(
  //               address: "Sample Address #2", city: "Dubai")));

  //   tabbySdk.makePayment(context, payload).then((value) {
  //     print("tabbySdk result ${value}");

  //     if (value == tabby.TabbyResult.authorized) {
  //       tabby.showToast(context, "Payment has been authorized", success: true);
  //       return;
  //     }
  //     tabby.showToast(
  //       context,
  //       "Payment is ${value.name}",
  //     );
  //   });
  // }

  List<OrdersModel> pendingOrders = [];
  List<OrdersModel> otherOrders = [];

  fetchOrders(context) async {
    String email = '';
    email = await CashHelper.getSavedString("email", "");
    if (email == "") {
      print("hbhbhb ${email}");
      email = await CashHelper.getSavedString("guestEmail", "");
    }
    print("hbhbhb ${email}");

    pendingOrders.clear();
    otherOrders.clear();
    try {
      var response = await CheckoutRepository.fetchOrders(email,
          customer: ProfileCubit.get(context).profileModel.isEmpty
              ? "0"
              : ProfileCubit.get(context).profileModel[0].id);
      print('kjbhbhjbjhbhjb $response');
      response.forEach((element) {
        if (element['status'] == "pending") {
          pendingOrders.add(OrdersModel.fromJson(element));
        } else {
          otherOrders.add(OrdersModel.fromJson(element));
        }
      });
      emit(CheckoutChangeState());
    } catch (e) {
      return Future.error(e);
    }
  }

  deleteOrder(id, context) async {
    try {
      var response = await CheckoutRepository.deleteOrder(id);
      await fetchOrders(context);
      emit(CheckoutChangeState());
    } catch (e) {
      return Future.error(e);
    }
  }

  // Get Countries
  String selectedState = "";
  CountryModel? selectedCountry;
  List<CountryModel> countries = [];

  fetchCountries() async {
    emit(GetCountriesLoadingState());
    try {
      Map<String, dynamic> response = await CheckoutRepository.fetchCountries();
      countries.clear();
      response.forEach((key, value) {
        countries.add(CountryModel(name: value, code: key));
      });
      log("Countries" + response.toString());
      if (selectedAddress != null && selectedState == '') {
        stateController.text = selectedAddress?.state ?? "";
        selectedState = selectedAddress?.state ?? "";
        var phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
            selectedAddress?.phoneNumber ?? "");
        log("Phone Number $phoneNumber");
      } else {
        if (selectedCountry == null) {
          selectedCountry = countries[1];
          stateController.text = countries[1].name;
          selectedState = countries[1].name;
        }
      }
      emit(GetCountriesLoadedState());
    } catch (e) {
      emit(GetCountriesErrorState(e.toString()));
    }
  }

  // Update
  updateState() {
    emit(CheckoutChangeState());
  }

  // ? ======== This Section For Address =========
  late List address;
  String user = "", email = "", selectedRegion = "", selectedCity = "";
  int selectedRegionIndex = 0;
  int selectedStateIndex = 0;
  List<String> regions = [], regionsAr = [];
  List<List<String>> cities = [], citiesAr = [];
}
