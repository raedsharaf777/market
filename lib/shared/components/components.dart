import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/colors.dart';

void navigateTo({context, widget}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish({context, widget}) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => false);

Widget defaultButton({
  bool isUpperCase = true,
  required String text,
  required Function()? function,
  double radius = 5,
  double width = double.infinity,
  Color background = defaultColor,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );

Widget defaultTextFromField({
  required TextEditingController controller,
  required String? Function(String?)? validator,
  required String labelText,
  required Widget? prefixIcon,
  IconData? suffixIcon,
  Function()? onPressedSuffix,
  Function()? onTap,
  TextInputType? type,
// IconData iconSuffix,
  bool isPassword = false,
  Function(String value)? onChange,
  Function(String value)? onFieldSubmitted,
}) =>
    TextFormField(
      keyboardType: type,
      controller: controller,
      onChanged: onChange,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: isPassword,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onPressedSuffix,
                icon: Icon(suffixIcon),
              )
            : null,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );

void showToast({
  required String msg,
  required ToastStatus status,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastStatus(status),
      textColor: Colors.white,
      fontSize: 16.0,
    );
// enum
enum ToastStatus { SUCCESS, ERORR, WARINING }

Color chooseToastStatus(ToastStatus status) {
  Color color;
  switch (status) {
    case ToastStatus.SUCCESS:
      color = Colors.green;
      break;
    case ToastStatus.WARINING:
      color = Colors.amber;
      break;
    case ToastStatus.ERORR:
      color = Colors.red;
      break;
  }
  return color;
}

void printFullText(String text) {
  final pattern = RegExp('.{1.800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Widget buildDivider() => Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey,
      ),
    );
Widget showLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: defaultColor,
    ),
  );
}