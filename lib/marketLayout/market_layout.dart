import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../modules/search/search_screen.dart';
import '../shared/components/components.dart';
import '../shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import '../shared/styles/colors.dart';

class MarketLayout extends StatelessWidget {
  MarketLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = MarketLayoutCubit.get(context);
    return BlocConsumer<MarketLayoutCubit, MarketLayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Market'), actions: [
            IconButton(
                onPressed: () {
                  navigateTo(context: context, widget: SearchScreen());
                },
                icon: const Icon(Icons.search)),
          ]),
          // body: cubit.screens[cubit.currentIndex],
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;

              if (connected) {
                return cubit.screens[cubit.currentIndex];
              } else {
                return buildNoInternetWidget();
              }
            },
            child: showLoadingIndicator(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.bottomItems,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
          ),
        );
      },
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
}
