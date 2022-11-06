import 'package:cermath_app/features/homepage/homepage.dart';
import 'package:cermath_app/features/homepage/leaderboard/leaderboard_friend.dart';
import 'package:cermath_app/features/homepage/materi/materi_list.dart';
import 'package:cermath_app/features/homepage/materi/materi_pdf.dart';
import 'package:cermath_app/features/homepage/materi/materi_search.dart';
import 'package:cermath_app/features/homepage/materi/materi_search_all.dart';
import 'package:cermath_app/features/homepage/profile/profile_edit.dart';
import 'package:cermath_app/features/homepage/profile/profile_password.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_list.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_result.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_test.dart';
import 'package:cermath_app/features/login/login.dart';
import 'package:cermath_app/features/login/login_firstlaunch.dart';
import 'package:cermath_app/features/login/login_information.dart';
import 'package:cermath_app/features/login/login_register.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginFirstLaunch());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => LoginRegister());
      case '/loginInformation':
        return MaterialPageRoute(builder: (_) => LoginInformation());
      case '/homePage':
        return MaterialPageRoute(builder: (_) => Homepage());
      case '/listMateri':
        return MaterialPageRoute(builder: (_) =>
            ListMateri(),
            settings: settings
        );
      case '/materiPdf':
        return MaterialPageRoute(builder: (_) =>
            MateriPdf(),
            settings: settings
        );
      case '/quizList':
        return MaterialPageRoute(builder: (_) =>
            QuizList(),
            settings: settings
        );
      case '/quizTest':
        return MaterialPageRoute(builder: (_) =>
            QuizTest(),
            settings: settings
        );
      case '/quizResult':
        return MaterialPageRoute(builder: (_) =>
            QuizResult(),
            settings: settings
        );
      case '/leaderboardFriend':
        return MaterialPageRoute(builder: (_) =>
            LeaderboardFriend(),
            settings: settings
        );
      case '/editProfile':
        return MaterialPageRoute(builder: (_) =>
            ProfileEdit(),
            settings: settings
        );
      case '/editPassword':
        return MaterialPageRoute(builder: (_) =>
            ProfilePassword(),
            settings: settings
        );
      case '/materiSearch':
        return MaterialPageRoute(builder: (_) =>
            MateriSearch(),
            settings: settings
        );
      case '/materiSearchAll':
        return MaterialPageRoute(builder: (_) =>
            MateriSearchAll(),
            settings: settings
        );
      default:
        return _errorRoute();
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found!"),
        ),
        body: const Center(
          child: Text("Error 404!"),
        ),
      );
    });
  }
}