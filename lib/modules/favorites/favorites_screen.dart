import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/get_favorites_model.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import '../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketLayoutCubit, MarketLayoutState>(
      listener: (context, state) {
        if (state is MarketLayoutGetFavouritesSuccessState) {
          if (!state.favModel.status!) {
            showToast(
                msg: '${state.favModel.message}', status: ToastStatus.ERORR);
          }
        }
      },
      builder: (context, state) {
        var cubit = MarketLayoutCubit.get(context);
        return ConditionalBuilder(
          condition: state is! MarketLayoutGetFavouritesLoadedState,
          builder: (context) =>
              ListView.separated(
                itemBuilder: (context, index) =>
                    buildFavItem(
                        cubit.getFavoritesModel!.data!.data![index], context),
                separatorBuilder: (context, index) => buildDivider(),
                itemCount: cubit.getFavoritesModel!.data!.data!.length,
              ),
          fallback: (context) =>
          const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(DataListModel product, context) {
    var cubit = MarketLayoutCubit.get(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage('${product.product!.image}'),
                  width: 120,
                  height: 120,
                  //fit: BoxFit.cover,
                ),
                if (1 != 0)
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.product!.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, height: 1.3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${product.product!.price}',
                        style: const TextStyle(
                            fontSize: 13, height: 1.3, color: defaultColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (product.product!.discount != 0)
                        Text(
                          '${product.product!.oldPrice}',
                          style: const TextStyle(
                              fontSize: 11,
                              height: 1.3,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          cubit.changeFavourite(product.product!.id!);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                          cubit.favourites[product.product!.id]!
                              ? defaultColor
                              : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
