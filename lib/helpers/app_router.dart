import 'package:flutter/material.dart';
import '../calling_page.dart';
import '../home_page.dart';
import '../login_view.dart';

class AppRoute {
  static const homePage = '/home_page';

  static const callingPage = '/calling_page';

  static const loginIn = '/login_screen';

  static const videoCallScreen = '/video_call_screen';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
            builder: (_) => HomePage(), settings: settings);
      case callingPage:
        return MaterialPageRoute(
            builder: (_) => CallingPage(), settings: settings);
      case loginIn:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(), settings: settings);
      default:
        return null;
    }
  }
}
