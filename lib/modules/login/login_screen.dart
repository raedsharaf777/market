import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/constants/constants.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/cubit/loginCubit/login_cubit.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import '../../marketLayout/market_layout.dart';
import '../../shared/styles/colors.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status == true) {
              print(state.loginModel.status);
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token!)
                  .then((value) {
                //عملت ال token هنا عشان لو عملت logout ميكونش فاضي ويخبط error
                token = state.loginModel.data!.token!;
                showToast(
                  msg: state.loginModel.message!,
                  status: ToastStatus.SUCCESS,
                );
                navigateAndFinish(context: context, widget: MarketLayout());
              });
            } else {
              //.............................هاااااام جدااااا...................
              // print(state.loginModel.status);
              // print(state.loginModel.message);
              //  لو عملت ال داتا ب (!) هيعمل ان فينت لووب وهيضرب ايروور
              // انما لو عملت ال داتا (؟) مش هيعمل تيرور
              // print(state.loginModel.data!.token);
              print(state.loginModel.message);
              showToast(
                msg: state.loginModel.message!,
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
                          'Login',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
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
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: LoginCubit.get(context).isPassword,
                          suffixIcon: LoginCubit.get(context).suffixIcon,
                          onPressedSuffix: () {
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Bottom of Login......................................
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                              text: 'login',
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\' t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                    context: context, widget: RegisterScreen());
                              },
                              child: Text('register'.toUpperCase()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
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
