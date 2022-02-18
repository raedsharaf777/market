import '../modules/login/login_screen.dart';
import '../shared/components/components.dart';
import '../shared/network/local/cache_helper.dart';

String? token;

void signOut({context}) {
  CacheHelper.removeData(key: 'token')!.then((value) {
    if (value == true) {
      navigateAndFinish(context: context, widget: LoginScreen());
    }
  });
}
