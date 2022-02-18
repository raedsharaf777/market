import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/cubit/marketLayoutCubit/market_layout_cubit.dart';
import '../../constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  // SettingsScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketLayoutCubit, MarketLayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MarketLayoutCubit.get(context);
        token = cubit.profileModel!.data!.token;
        emailController.text = cubit.profileModel!.data!.email!;
        nameController.text = cubit.profileModel!.data!.name!;
        phoneController.text = cubit.profileModel!.data!.phone!;
        return ConditionalBuilder(
          condition: MarketLayoutCubit.get(context).profileModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is MarketLayoutUpdateLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextFromField(
                      controller: nameController,
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please!, Enter your name address';
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultTextFromField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Please!, Enter your email address';
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultTextFromField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Please!, Enter your phone address';
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Phone',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultButton(
                        text: 'Update',
                        function: () {
                          if (formKey.currentState!.validate()) {
                            MarketLayoutCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultButton(
                        text: 'LogOut',
                        function: () {
                          signOut(context: context);
                        }),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
