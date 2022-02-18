import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/marketLayout/market_layout.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/cubit/registerCubit/register_cubit.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import 'package:market/shared/styles/colors.dart';
import '../../constants/constants.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.registerModel.status ==true) {
              print(state.registerModel.status);
              print(state.registerModel.message);
              print(state.registerModel.data!.token);
              CacheHelper.saveData(
                  key: 'token', value: state.registerModel.data!.token!)
                  .then((value) {
                //عملت ال token هنا عشان لو عملت logout ميكونش فاضي ويخبط error
                token = state.registerModel.data!.token!;
                showToast(
                  msg: state.registerModel.message!,
                  status: ToastStatus.SUCCESS,
                );
                navigateAndFinish(context: context, widget: MarketLayout());
              });
            } else {
              //.............................هاااااام جدااااا...................

              print(state.registerModel.message);
              showToast(
                msg: state.registerModel.message!,
                status: ToastStatus.ERORR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //...................Name.....................................
                        defaultTextFromField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Please!, Enter your Name address';
                            } else {
                              return null;
                            }
                          },
                          labelText: 'User Name',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: defaultColor,
                          ),
                          type: TextInputType.text,
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        //...................Email..............................
                        defaultTextFromField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Please!, Enter your email address';
                            } else {
                              return null;
                            }
                          },
                          labelText: 'Email Address',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: defaultColor,
                          ),
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //...................Phone....................................
                        defaultTextFromField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Please!, Enter your phone address';
                            } else {
                              return null;
                            }
                          },
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: defaultColor,
                          ),
                          type: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //...................Password...........................
                        defaultTextFromField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Password is too short';
                            } else {
                              return null;
                            }
                          },
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_open_outlined,
                            color: defaultColor,
                          ),
                          type: TextInputType.visiblePassword,
                          onFieldSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: RegisterCubit.get(context).isPassword,
                          suffixIcon: RegisterCubit.get(context).suffixIcon,
                          onPressedSuffix: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Bottom of Register.........................................
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState ,
                          builder: (context) => defaultButton(
                              text: 'Register',
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
