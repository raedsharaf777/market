import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/constants/constants.dart';
import 'package:market/modules/login/login_screen.dart';
import 'package:market/shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import 'package:market/shared/cubit/modeCubit/mode_cubit.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import 'package:market/shared/network/remote/dio_helper.dart';
import 'package:market/shared/styles/style.dart';
import 'marketLayout/market_layout.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  // علشان الميين بقي فيها التزامن لازم الكود دا يكون موجود
  WidgetsFlutterBinding.ensureInitialized();
  // لابد من بدأ الكاش هيلبر
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBearding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  Widget? widget;
  // لابد من بدأ دايوو هيلبر
  DioHelper.init();
  //كان لازم احط دا عشان بتضرب ايروور تبع السيرفر
  HttpOverrides.global = MyHttpOverrides();
  // هنا بعمل انه يشيك علي ال الاسكرينات اللي مش هدخلها تاني ويشك علي token ...>>
  if (onBearding != null) {
    if (token != null) {
      widget = MarketLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // كان لازم احط ?bool عشان ال null safety وكانت بتطلع null error
  final bool? isDark;
  final Widget? startWidget;

  MyApp({required this.isDark, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ModeCubit()..changeMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => MarketLayoutCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavouritesData()
            ..getProfileData(),
        ),
      ],
      child: BlocConsumer<ModeCubit, ModeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ModeCubit.get(context).isDark
                ? ThemeMode.light
                : ThemeMode.dark,
            home: startWidget,
            //home: OnBoardingScreen(),
          );
        },
      ),
    );
  }
}

//...............................حل ايررور الداتا لما اجبها من السيرفر..........

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
/*
this class is to Unhandled Exception: HandshakeException: Handshake error
in client (OS Error:
CERTIFICATE_VERIFY_FAILED: ok(handshake.cc:354)*/

//main
//import 'dart:io';
//HttpOverrides.global = MyHttpOverrides();
/*
 badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback);
 */
