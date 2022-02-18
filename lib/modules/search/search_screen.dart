import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import 'package:market/shared/cubit/searchCubit/search_cubit.dart';
import 'package:market/shared/styles/colors.dart';

import '../../models/search_model.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultTextFromField(
                      controller: searchController,
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Search must not be empty ';
                        } else {
                          return null;
                        }
                      },
                      onPressedSuffix: () {},
                      onChange: (String text) {
                        if (formKey.currentState!.validate()) {
                          SearchCubit.get(context).searchData(text);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    if (state is SearchLoadingState)
                      const Center(child: LinearProgressIndicator()),
                    const SizedBox(height: 10),
                    // لو انا مكنتش عملت ال if دي كان هيعمل error
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildItem(
                              SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data![index],
                              context),
                          separatorBuilder: (context, index) => buildDivider(),
                          itemCount: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(Product product, context) {
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
                  image: NetworkImage('${product.image}'),
                  width: 120,
                  height: 120,
                  //fit: BoxFit.cover,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //     borderRadius: BorderRadius.circular(9),
                //   ),
                //   padding: const EdgeInsets.symmetric(horizontal: 5),
                //   child: const Text(
                //     'DISCOUNT',
                //     style: TextStyle(fontSize: 12),
                //   ),
                // ),
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
                    '${product.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, height: 1.3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${product.price}',
                        style: const TextStyle(
                            fontSize: 13, height: 1.3, color: defaultColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          cubit.changeFavourite(product.id!);
                        },
                        icon: CircleAvatar(
                          backgroundColor: cubit.favourites[product.id]!
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
