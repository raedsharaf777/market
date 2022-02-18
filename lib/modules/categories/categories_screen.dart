import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/categories_model.dart';
import '../../shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import '../../shared/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = MarketLayoutCubit.get(context);
    return BlocConsumer<MarketLayoutCubit, MarketLayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                buildCategoryItem(cubit.categoriesModel!.data!.data[index]),
            separatorBuilder: (context, index) => const SizedBox(
                //height: 1,
                ),
            itemCount: cubit.categoriesModel!.data!.data.length);
      },
    );
  }

  Widget buildCategoryItem(DataModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 2,
        color: Colors.grey.shade200,
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                '${model.image}',
              ),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${model.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: defaultColor,
                ))
          ],
        ),
      ),
    );
  }
}
