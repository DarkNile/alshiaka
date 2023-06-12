import 'package:ahshiaka/bloc/auth_cubit/auth_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/firebase_options.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/init_screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'bloc/layout_cubit/bottom_nav_cubit.dart';
import 'bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'bloc/profile_cubit/profile_cubit.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //  print('foreground notification');
//  print('Message data: ${message.data}');
    if (message.notification != null) {
      //  print('yes notification: ${message.notification}');
    }
  });
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lang',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => CheckoutCubit()
            ..fetchCartList(context)
            ..fetchCoupons()
            ..fetchAddresses()
            ..fetchShippingMethods()
            ..fetchFreeShippingMethods()
            ..fetchPaymentGetaways(),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit()
            ..fetchBanner()
            ..fetchFavProducts()
            ..fetchCategories()
            ..fetchNewArrivalProducts(catId: 0, page: 1, perPage: 10)
            ..fetchRecommendedProducts(catId: 0, page: 1, perPage: 10)
            ..fetchHomeMenu(catId: 0, page: 1, perPage: 10)
            ..fetchAttributes(),
        ),
      ],
      child: MaterialApp(
        title: 'الشياكة',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          fontFamily: AppUtil.rtlDirection(context) ? "cairo" : "Tajawal",
          scaffoldBackgroundColor: AppUI.whiteColor,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: AppUI.blackColor)),
          primarySwatch: AppUI.mainColor,
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
                  .copyWith(
            bodyText1: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.bodyText1),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
