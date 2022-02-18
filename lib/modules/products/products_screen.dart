import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/models/home_model.dart';
import 'package:market/shared/components/components.dart';
import '../../shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import '../../shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketLayoutCubit, MarketLayoutState>(
      listener: (context, state) {
        if (state is MarketLayoutChangeFavouritesSuccessState) {
          if (!state.model.status!) {
            showToast(msg: '${state.model.message}', status: ToastStatus.ERORR);
          }
        }
      },
      builder: (context, state) {
        var cubit = MarketLayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null,
          builder: (context) => productsBuilder(cubit.homeModel!, context),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel model, context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners!.map((banner) {
                return Image(
                  image: NetworkImage('${banner.image}'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                height: 240,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Text(
                  //   'Categories',
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   child: ListView.separated(
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) => buildCategoriesItem(),
                  //     separatorBuilder: (context, index) => SizedBox(
                  //       width: 10,
                  //     ),
                  //     itemCount: 10,
                  //   ),
                  // ),
                  Text(
                    'New Products',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                // عشان انا حطيت SingleChildScrollView لازم احط shrinkWrap عشان العناصر تبان
                shrinkWrap: true,
                //SingleChildScrollView  عشان اوقف اسكرول بتاع ال GRIDVIEW و اشغل بتاع تا
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.68,
                children: List.generate(
                  model.data!.products!.length,
                  (index) => buildGridViewProduct(
                      model.data!.products![index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoriesItem() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const Image(
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://student.valuxapps.com/storage/uploads/categories/16301438353uCFh.29118.jpg'),
        ),
        Container(
          width: 100,
          color: Colors.black.withOpacity(.8),
          child: const Text(
            'Electrionic',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildGridViewProduct(Products product, context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image(
                image: NetworkImage('${product.image}'),
                width: double.infinity,
                height: 200,
                //fit: BoxFit.cover,
              ),
              if (product.discount != 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
                Row(
                  children: [
                    Text(
                      '${product.price.round()}',
                      style: const TextStyle(
                          fontSize: 13, height: 1.3, color: defaultColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (product.discount != 0)
                      Text(
                        '${product.oldPrice.round()}',
                        style: const TextStyle(
                            fontSize: 11,
                            height: 1.3,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          MarketLayoutCubit.get(context)
                              .changeFavourite(product.id!);
                          print(product.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor: MarketLayoutCubit.get(context)
                                  .favourites[product.id]!
                              ? defaultColor
                              : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
