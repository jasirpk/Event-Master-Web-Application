import 'package:event_master_web/presentation_layer/screens/get_started.dart';
import 'package:event_master_web/presentation_layer/screens/home.dart';
import 'package:event_master_web/presentation_layer/screens/signin.dart';
import 'package:event_master_web/presentation_layer/screens/signup.dart';
import 'package:get/get.dart';

class RoutsClass {
  static String getStarted = '/';
  static String signuP = '/signuP';
  static String login = '/login';
  static String home = '/home';

  static String getSplashRoute() => getStarted;
  static String getSignUpRoute() => signuP;
  static String getLoginRout() => login;
  static String getHomeRout() => home;

  static List<GetPage> routes = [
    GetPage(name: getStarted, page: () => GetStartedScreen()),
    GetPage(
        name: signuP,
        page: () => SignupScreen(),
        transition: Transition.fade,
        transitionDuration: Duration(seconds: 1)),
    GetPage(
        name: login,
        page: () => LoginScreen(),
        transition: Transition.fade,
        transitionDuration: Duration(seconds: 1)),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.zoom,
    )
  ];
}
