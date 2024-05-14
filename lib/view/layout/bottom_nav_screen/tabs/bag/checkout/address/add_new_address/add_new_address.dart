import 'dart:developer';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/checkout/shipping_model.dart';
import 'package:ahshiaka/utilities/cache_helper.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/widgets/account_information_widget.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/widgets/address_information_widget.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/otp_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../shared/components.dart';
import '../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../utilities/app_util.dart';
import '../../../../../../../../shared/cash_helper.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

// ignore: must_be_immutable
class AddNewAddress extends StatefulWidget {
  bool isQuest;
  final Address0? address;
  final String? addressKey;
  final bool isFromProfile;
  AddNewAddress(
      {Key? key,
      this.address,
      this.addressKey,
      required this.isQuest,
      required this.isFromProfile})
      : super(key: key);

  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final GlobalKey<FormState> newAddressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData(widget.isFromProfile);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cubit = CheckoutCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: newAddressFormKey,
            child: Column(
              children: [
                CustomAppBar(
                  title: "addresses".tr(),
                  onBack: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: AppUtil.responsiveHeight(context) * 0.86,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AccountInformationWidget(cubit: cubit),
                        //
                        AddressInformationWidget(cubit: cubit),
                        //
                        StatefulBuilder(
                          builder: (BuildContext context, setStateBuilder) =>
                              isLoading
                                  ? const LoadingWidget()
                                  : InkWell(
                                      onTap: () async {
                                        if (newAddressFormKey.currentState!
                                            .validate()) {
                                          if (!AppUtil.isEmailValidate(
                                              cubit.emailController2.text)) {
                                            AppUtil.newErrorToastTOP(
                                                context, "inValidEmail".tr());
                                            return;
                                          }
                                          // if ((cubit.selectedState != "" &&
                                          //         cubit.selectedState == AppUtil.ksa) &&
                                          //     !AppUtil.isPhoneValidate(
                                          //         cubit.phoneController.text)) {
                                          //   AppUtil.newErrorToastTOP(
                                          //       context, "inValidPhone".tr());
                                          //   return;
                                          // }
                                          if ((cubit.selectedState != "" &&
                                                  cubit.selectedState ==
                                                      AppUtil.ksa) &&
                                              !AppUtil.isAddressValidate(cubit
                                                  .addressController.text)) {
                                            AppUtil.newErrorToastTOP(
                                                context, "inValidAddress".tr());
                                            return;
                                          }

                                          setStateBuilder(() {
                                            isLoading = true;
                                          });

                                          // ?   IF COUNTRY IS NOT KSA
                                          // ? selectedRegion == selectedState == country
                                          // i remove   widget.address != null
                                          if (cubit.selectedState ==
                                              AppUtil.ksa) {
                                            log("KSA");
                                            log("cubit.selectedRegion ${cubit.selectedRegion}");
                                            log("cubit.selectedCity ${cubit.selectedCity}");
                                            await CheckoutCubit.get(context)
                                                .saveAddress(
                                              context,
                                              address_id: widget.addressKey,
                                              isQuest: widget.isQuest,
                                              selectedRegion:
                                                  cubit.selectedRegion,
                                              selectedCity: cubit.selectedCity,
                                            );
                                            await CacheHelper.write(
                                                "Country Code",
                                                cubit.selectedState ==
                                                        AppUtil.ksa
                                                    ? "SA"
                                                    : "EG");
                                            setStateBuilder(() {
                                              isLoading = false;
                                            });

                                            final response =
                                                await CheckoutCubit.get(context)
                                                    .sendPhone(
                                              '${cubit.phoneCode}${cubit.phoneController.text}',
                                            );

                                            if (response["success"] == 1) {
                                              AppUtil.mainNavigator(
                                                  context,
                                                  OTPScreen(
                                                    phone:
                                                        '${cubit.phoneCode}${cubit.phoneController.text}',
                                                    addressId:
                                                        widget.addressKey,
                                                    isQuest: widget.isQuest,
                                                    selectedCity:
                                                        cubit.selectedCity,
                                                    selectedRegion:
                                                        cubit.selectedRegion,
                                                  ));
                                            }
                                          }
                                          // ? IF COUNTRY IS Not KSA
                                          else if (cubit.selectedState != '' &&
                                              cubit.cityController.text != '' &&
                                              cubit.selectedState !=
                                                  AppUtil.ksa) {
                                            cubit.countryController.text =
                                                cubit.selectedState;
                                            cubit.selectedRegion =
                                                cubit.selectedState;
                                            cubit.cityController.text =
                                                cubit.selectedCity;
                                            log("NOT KSA");
                                            log("cubit.selectedRegion ${cubit.selectedRegion}");
                                            log("cubit.selectedCity ${cubit.selectedCity}");
                                            await CheckoutCubit.get(context)
                                                .saveAddress(
                                              context,
                                              address_id: widget.addressKey,
                                              isQuest: widget.isQuest,
                                              selectedRegion:
                                                  cubit.selectedState,
                                              selectedCity: cubit.selectedCity,
                                            );
                                            await CacheHelper.write(
                                                "Country Code",
                                                cubit.selectedState ==
                                                        AppUtil.ksa
                                                    ? "SA"
                                                    : "EG");
                                            setStateBuilder(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      },
                                      child: CustomButton(text: "save".tr()),
                                    ),
                        ),
                        const SizedBox(
                          height: 34,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> myLoading(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: const LoadingWidget(),
              ),
            ],
          );
        });
  }

  getData(bool isFromProfile) async {
    // hint    State == Country == Region
    final cubit = CheckoutCubit.get(context);
    if (isFromProfile) {
      cubit.fetchCountries();
    }

    cubit.user = await CashHelper.getSavedString("user", "");
    cubit.email = await CashHelper.getSavedString("email", "");

    print(cubit.user);
    print(cubit.email);
    print(' isQuest: ${widget.isQuest}');

    cubit.regions = [
      "Al Baha Area",
      "Al Madinah Area",
      "Al Qassim Area",
      "Aljouf Area",
      "Aser Area",
      "Gizan Area",
      "Hail Area",
      "Makkah Area",
      "Najran Area",
      "Riyadh Area",
      "Tabuk Area",
      "The Eastern Area",
      "The Northern border Area"
    ];
    cubit.regionsAr = [
      "منطقة الباحة",
      "منطقة المدينة المنورة",
      "منطقة القصيم",
      "منطقة الجوف",
      "منطقة عسير",
      "منطقة جيزان",
      "منطقة حائل",
      "منطقة مكة المكرمة",
      "منطقة نجران",
      "منطقة الرياض",
      "منطقة تبوك",
      "منطقة الشرقية",
      "منطقة الحدود الشمالية"
    ];
    cubit.cities = [
      [
        "Aqiq",
        "Atawleh",
        "Baha",
        "BilJurashi",
        "Gilwa",
        "Hajrah",
        "Mandak",
        "Mikhwa",
        "Subheka"
      ],
      [
        "Al Ais",
        "Bader",
        "Hinakeya",
        "Khaibar",
        "Madinah",
        "Mahad Al Dahab",
        "Oula",
        "Yanbu",
        "Yanbu Al Baher",
        "Yanbu Nakhil"
      ],
      [
        "Aba Alworood",
        "Al Batra",
        "Al Dalemya",
        "Al Fuwaileq / Ar Rishawiyah",
        "Al Khishaybi",
        "Al Midrij",
        "Al Qarin",
        "Alnabhanya",
        "AlRass",
        "As Sulaimaniyah",
        "As Sulubiayh",
        "Ash Shimasiyah",
        "Ayn Fuhayd",
        "Badaya",
        "Bukeiriah",
        "Buraidah",
        "Dariyah",
        "Duhknah",
        "Dulay Rashid",
        "Kahlah",
        "Midinhab",
        "Onaiza",
        "Oyoon Al Jawa",
        "Qassim",
        "Qbah",
        "Qusayba",
        "Riyadh Al Khabra",
        "Shari",
        "Thebea",
        "Uqlat Al Suqur"
      ],
      [
        "Abu Ajram",
        "Al Laqayit",
        "An Nabk Abu Qasr",
        "Ar Radifah",
        "Ar Rafi'ah",
        "At Tuwayr",
        "Domat Al Jandal",
        "Ghtai",
        "Hadeethah",
        "Hedeb",
        "Jouf",
        "Kara",
        "Qurayat",
        "Sakaka",
        "Suwayr",
        "Tabrjal",
        "Zallum"
      ],
      [
        "Abha",
        "Abha Manhal",
        "Ahad Rufaidah",
        "Al Bashayer",
        "Balahmar",
        "Balasmar",
        "Balqarn",
        "Bareq",
        "Birk",
        "Bisha",
        "Dhahran Al Janoob",
        "Harjah",
        "Khamis Mushait",
        "Majarda",
        "Mohayel Aseer",
        "Namas",
        "Qahmah",
        "Rejal Alma'a",
        "Sabt El Alaya",
        "Sarat Obeida",
        "Tanda",
        "Tanuma",
        "Tatleeth",
        "Turaib",
        "Wadeien",
        "Wadi Bin Hasbal"
      ],
      [
        "Abu Areish",
        "Ahad Masarha",
        "Al Ardah",
        "Al Idabi",
        "Ash Shuqaiq",
        "Bish",
        "Damad",
        "Darb",
        "Farasan",
        "Gizan",
        "Karboos",
        "Sabya",
        "Samtah",
        "Siir"
      ],
      [
        "Al Ajfar",
        "Al Haith",
        "Al Hulayfah As Sufla ",
        "Al Khitah",
        "Al Wasayta",
        "An Nuqrah",
        "Ash Shamli",
        "Ash Shananah",
        "Baqa Ash Sharqiyah",
        "Baqaa",
        "Ghazalah",
        "Hail",
        "Mawqaq",
        "Qufar",
        "Simira"
      ],
      [
        "Adham",
        "Al Moya",
        "Alhada",
        "Amaq",
        "Asfan",
        "Bahara",
        "Hali",
        "Hawea/Taif",
        "Ja'araneh",
        "Jeddah",
        "Jumum",
        "Khulais",
        "Khurma",
        "Laith",
        "Makkah",
        "Mastura",
        "Muthaleif",
        "Nimra",
        "Qouz",
        "Qunfudah",
        "Rabigh",
        "Rania",
        "Shoaiba",
        "Shumeisi",
        "Taif",
        "Towal",
        "Turba",
        "Wadi Fatmah",
        "Zahban"
      ],
      ["Hubuna", "Najran", "Sharourah"],
      [
        "Ad Dahinah",
        "Ad Dubaiyah",
        "Afif",
        "Aflaj",
        "Al Bijadyah",
        "Al Hayathem",
        "Al Hufayyirah",
        "Alghat",
        "Artawiah",
        "Daelim",
        "Dawadmi",
        "Deraab",
        "Dere'iyeh",
        "Dhurma",
        "Hareeq",
        "Hawtat Bani Tamim",
        "Hotat Sudair",
        "Huraymala",
        "Jalajel",
        "Khairan",
        "Khamaseen",
        "Kharj",
        "Layla",
        "Majma",
        "Mrat",
        "Mubayid",
        "Mulayh",
        "Muzahmiah",
        "Oyaynah",
        "Qasab",
        "Quwei'ieh",
        "Remah",
        "Riyadh",
        "Rowdat Sodair",
        "Rvaya Aljamsh",
        "Rwaydah",
        "Sahna",
        "Sajir",
        "Shaqra",
        "Sulaiyl",
        "Tanumah",
        "Tebrak",
        "Thadek",
        "Tharmada",
        "Thumair",
        "Um Aljamajim",
        "Ushayqir",
        "Wadi El Dwaser",
        "Zulfi"
      ],
      [
        "Al Bada",
        "Duba",
        "Halat Ammar",
        "Haqil",
        "Tabuk",
        "Tayma",
        "Umluj",
        "Wajeh (Al Wajh)"
      ],
      [
        "Ain Dar",
        "Al Hassa",
        "Al-Jsh",
        "Anak",
        "Ath Thybiyah",
        "Awamiah",
        "Baqiq",
        "Batha",
        "Dammam",
        "Dhahran",
        "Hafer Al Batin",
        "Harad",
        "Haweyah/Dha",
        "Hofuf",
        "Jafar",
        "Jubail",
        "Khafji",
        "Khobar",
        "Khodaria",
        "King Khalid Military City",
        "Mubaraz",
        "Mulaija",
        "Nabiya",
        "Noweirieh",
        "Ojam",
        "Othmanyah",
        "Qarah",
        "Qariya Al Olaya",
        "Qatif",
        "Qaysoomah",
        "Rahima",
        "Ras Al Kheir",
        "Ras Tanura",
        "Safanyah",
        "Safwa",
        "Salwa",
        "Sarar",
        "Satorp (Jubail Ind'l 2)",
        "Seihat",
        "Tanjeeb",
        "Tarut",
        "Thuqba",
        "Udhaliyah",
        "Uyun"
      ],
      ["Arar", "Hazm Al Jalamid", "Nisab", "Rafha", "Rawdat Habbas", "Turaif"]
    ];
    cubit.citiesAr = [
      [
        "العقيق",
        "الأطاولة",
        "الباحة",
        "بلجرشي",
        "قلوه",
        "الحجرة",
        "المندق",
        "المخواة",
        "سبيحة"
      ],
      [
        "العيص",
        "بدر",
        "الحناكية",
        "خيبر",
        "المدينة المنورة",
        "مهد الذهب",
        "العلا",
        "ينبع",
        "ينبع البحر",
        "ينبع النخيل"
      ],
      [
        "ابا الورود",
        "البتراء",
        "الدليمية",
        "الفويلق",
        "الخشيبي",
        "المدرج",
        "القرين",
        "النبهانية",
        "الرس",
        "السليمانية",
        "الصلبيّة",
        "الشماسية",
        "عين فهيد",
        "البدائع",
        "البكيرية",
        "بريدة",
        "ضرية",
        "دخنة",
        "ضليع رشيد",
        "كحله",
        "المذنب",
        "عنيزة",
        "عيون الجواء",
        "القصيم",
        "قبه",
        "قصيباء",
        "رياض الخبراء",
        "شري",
        "الذيبية/ القصيم",
        "عقلة الصقور"
      ],
      [
        "أبو عجرم",
        "اللقائط",
        "النبك أبو قصر",
        "الرديفة",
        "الرفيعة",
        "الطوير",
        "دومة الجندل",
        "غطي",
        "الحديثة",
        "هديب",
        "الجوف",
        "قارا",
        "القريات",
        "سكاكا",
        "صوير",
        "طبرجل",
        "زلوم"
      ],
      [
        "ابها",
        "ابها المنهل",
        "احد رفيده",
        "البشائر",
        "بللحمر",
        "بللسمر",
        "بلقرن",
        "بارق",
        "البرك",
        "بيشة",
        "ظهران الجنوب",
        "الحرجة",
        "خميس مشيط",
        "المجاردة",
        "محايل عسير",
        "النماص",
        "القحمة",
        "رجال ألمع",
        "سبت العلايا",
        "سراة عبيدة",
        "تندحة",
        "تنومة / منطقة عسير",
        "تثليث",
        "طريب",
        "الواديين",
        "وادي بن هشبل"
      ],
      [
        "ابو عريش",
        "أحد المسارحة",
        "العارضة",
        "العيدابي",
        "الشقيق",
        "بيش",
        "ضمد",
        "الدرب",
        "جزر فرسان",
        "جازان",
        "الكربوس",
        "صبيا",
        "صامطة",
        "سر"
      ],
      [
        "الأجفر",
        "الحائط",
        "الحليفة السفلى",
        "الخطة",
        "الوسيطاء",
        "النقرة",
        "الشملي",
        "الشنان",
        "بقعاء الشرقية",
        "بقعاء",
        "الغزالة",
        "حائل",
        "موقق",
        "قفار",
        "سميراء"
      ],
      [
        "أضم",
        "الموية",
        "الهدا",
        "عمق",
        "عسفان",
        "بحرة",
        "حلي",
        "الحوية - الطائف",
        "الجعرانه",
        "جدة",
        "الجموم",
        "خليص",
        "الخرمة",
        "الليث",
        "مكة المكرمة",
        "مستورة",
        "المظيلف",
        "نمره",
        "القوز",
        "القنفذة",
        "رابغ",
        "رنية",
        "الشعيبة",
        "الشميسي",
        "الطائف",
        "ثول",
        "تربة",
        "وادي فاطمه",
        "ذهبان"
      ],
      ["حبونا", "نجران", "شرورة"],
      [
        "الداهنة",
        "الضبيعة",
        "عفيف",
        "الأفلاج",
        "البجادية",
        "الهياثم",
        "الحفيرة",
        "الغاط",
        "الأرطاوية",
        "الدلم",
        "الدوادمي",
        "ديراب",
        "الدرعية",
        "ضرما",
        "الحريق",
        "حوطة بني تميم",
        "حوطة سدير",
        "حريملاء",
        "جلاجل",
        "تمرة",
        "الخماسين",
        "الخرج",
        "ليلى",
        "المجمعة",
        "مرات",
        "مبايض",
        "مليح",
        "المزاحمية",
        "العيينة",
        "القصب",
        "القويعية",
        "رماح",
        "الرياض",
        "روضة سدير",
        "رفائع الجمش",
        "الرويضه",
        "الصحنة",
        "ساجر",
        "شقراء",
        "السليل",
        "تنومة / القصيم",
        "تبراك",
        "ثادق",
        "ثرمداء",
        "تمير",
        "ام الجماجم",
        "اشيقر",
        "وادي الدواسر",
        "الزلفي"
      ],
      ["البدع", "ضبا", "حالة عمار", "حقل", "تبوك", "تيماء", "أملج", "الوجه"],
      ["عرعر", "حزم الجلاميد", "شعبة نصاب", "رفحاء", "روضه هباس", "طريف"],
    ];

    // if (widget.address != null) {
    //   cubit.nameController2.text = widget.address!.shippingFirstName!;
    //   cubit.surNameController2.text = widget.address!.shippingLastName!;
    //   cubit.phoneController.text = widget.address!.shippingPhone!;
    //   cubit.emailController2.text = widget.address!.shippingEmail!;
    //   cubit.stateController.text = "Saudi Arabia";
    //   cubit.countryController.text = widget.address!.shippingCountry!;
    //   cubit.cityController.text = widget.address!.shippingCity!;
    //   cubit.addressController.text = widget.address!.shippingAddress1!;
    //   cubit.postCodeController.text = widget.address!.shippingPostcode!;
    // } else {
    //   cubit.nameController2.text = "";
    //   cubit.surNameController2.text = "";
    //   cubit.phoneController.text = "";
    //   cubit.emailController2.text = "";
    //   cubit.stateController.text = "Saudi Arabia";
    //   cubit.countryController.text = "";
    //   cubit.cityController.text = "";
    //   cubit.addressController.text = "";
    //   cubit.postCodeController.text = "";
    // }

    // cubit.stateController.text = "Saudi Arabia";

    // if countories not loadded
    if (cubit.countries == [] || cubit.countries.isEmpty) {
      cubit.stateController.text = AppUtil.ksa;
      cubit.selectedState = AppUtil.ksa;
    }

    if (cubit.selectedState == AppUtil.ksa) {
      if (widget.address != null) {
        cubit.addressController.text = widget.address!.shippingAddress1!;
        cubit.postCodeController.text = widget.address!.shippingPostcode!;
        int indexOfRegion = 0;
        if (cubit.regionsAr.contains(widget.address!.shippingCountry!)) {
          indexOfRegion =
              cubit.regionsAr.indexOf(widget.address!.shippingCountry!);
        }
        cubit.selectedRegionIndex = indexOfRegion;
        cubit.selectedRegion = cubit.regions[indexOfRegion];

        cubit.countryController.text = widget.address!.shippingCountry!;
        cubit.selectedCity = widget.address!.shippingCity!;
        cubit.cityController.text = widget.address!.shippingCity!;
        cubit.phoneController.text = widget.address!.shippingPhone!;
        cubit.nameController2.text = widget.address!.shippingFirstName!;
        cubit.surNameController2.text = widget.address!.shippingLastName!;
        cubit.emailController2.text = widget.address!.shippingEmail!;
      } else {
        cubit.nameController2.text =
            cubit.user.isEmpty ? "" : cubit.user.split('_').first;
        cubit.surNameController2.text =
            cubit.user.isEmpty ? "" : cubit.user.split('_').last;
        cubit.emailController2.text = cubit.email.isEmpty ? "" : cubit.email;
        cubit.phoneController.text = "";
        cubit.postCodeController.text = "";
        cubit.addressController.text = "";
        cubit.cityController.text = "";
        cubit.countryController.text = "";
      }
    }
    //  If Not Country Ksa
    else {
      if (widget.address != null) {
        cubit.postCodeController.text = widget.address!.shippingPostcode!;
        cubit.countryController.text = widget.address!.shippingCountry!;
        cubit.selectedRegion = cubit.selectedState;
        cubit.selectedCity = widget.address!.shippingCity!;
        cubit.cityController.text = widget.address!.shippingCity!;
        cubit.addressController.text = widget.address!.shippingCity!;
        cubit.phoneController.text = widget.address!.shippingPhone!;
        cubit.nameController2.text = widget.address!.shippingFirstName!;
        cubit.surNameController2.text = widget.address!.shippingLastName!;
        cubit.emailController2.text = widget.address!.shippingEmail!;
      } else {
        cubit.nameController2.text =
            cubit.user.isEmpty ? "" : cubit.user.split('_').first;
        cubit.surNameController2.text =
            cubit.user.isEmpty ? "" : cubit.user.split('_').last;
        cubit.emailController2.text = cubit.email.isEmpty ? "" : cubit.email;
        cubit.phoneController.text = "";
        cubit.postCodeController.text = "";
        cubit.addressController.text = "";
        cubit.cityController.text = cubit.selectedCity;
        cubit.addressController.text = cubit.selectedCity;
        cubit.selectedRegion = cubit.selectedState;
        cubit.countryController.text = cubit.selectedState;
      }
    }

    setState(() {});
    cubit.updateState();
  }
}
