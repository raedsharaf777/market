import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:market/modules/login/login_screen.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/styles/colors.dart';

class BoardingModel {
  String image;
  String title;
  String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      navigateAndFinish(context: context, widget: LoginScreen());
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'images/shopping.gif',
        title: 'Welcome to Market!',
        body: 'A fun new way to shop with friends!'),
    BoardingModel(
        image: 'images/onBoardingDrive.gif',
        title: 'Fast Delivery',
        body:
            'We operate our own logistics,deliveries are asap,and without complications.'),
    BoardingModel(
        image: 'images/onBoarding_1.gif',
        title: 'Order With Zero Stress',
        body:
            'When you order from market,you\'ll get your order within  24 hours.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: submit,
              child: const Text(
                'SKIP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ))
        ],
      ),
     // body:buildOnBoardingBagVie() ,
      body: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          final bool connected = connectivity != ConnectivityResult.none;

          if (connected) {
            return buildOnBoardingBagView();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Can\'t connect .. check internet',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            Image.asset('images/no_connected1.jpg'),
          ],
        ),
      ),
    );
  }
  Widget buildOnBoardingBagView(){
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: boardController,
              itemBuilder: (context, index) =>
                  buildBoardingItem(boarding[index]),
              itemCount: 3,
              onPageChanged: (int index) {
                if (index == boarding.length - 1) {
                  print('last');
                  setState(() {
                    isLast = true;
                  });
                } else {
                  print(' Not last');
                  isLast = false;
                }
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SmoothPageIndicator(
                controller: boardController, // PageController
                count: boarding.length,
                effect: const WormEffect(
                  dotColor: Colors.grey,
                  dotHeight: 15,
                  dotWidth: 15,
                  activeDotColor: defaultColor,
                  spacing: 5.0,
                ),
              ),
              const Spacer(),
              //..............................................................
              FloatingActionButton(
                onPressed: () {
                  if (isLast) {
                    submit();
                  } else {
                    boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                },
                child: const Icon(Icons.arrow_forward_ios),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(model.body),
          const SizedBox(
            height: 30,
          ),
        ],
      );
}
