import 'package:flutter/material.dart';
import 'package:security_wanyu/enum/main_functions.dart';
import 'package:security_wanyu/enum/punch_cards.dart';
import 'package:security_wanyu/screen/contact_us_screen.dart';
import 'package:security_wanyu/screen/sos_screen.dart';
import 'package:security_wanyu/screen/onboard_screen.dart';
import 'package:security_wanyu/screen/shift_screen.dart';
import 'package:security_wanyu/screen/start_patrol_screen.dart';
import 'package:security_wanyu/screen/form_apply_screen.dart';

class HomeScreenBloc {
  final BuildContext context;
  HomeScreenBloc({required this.context});

  String currentDateString() {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final day = DateTime.now().day;
    return '$year年$month月$day日';
  }

  String currentTimeString() {
    final hour = DateTime.now().hour < 10
        ? '0${DateTime.now().hour}'
        : DateTime.now().hour;
    final minute = DateTime.now().minute < 10
        ? '0${DateTime.now().minute}'
        : DateTime.now().minute;
    return '$hour:$minute';
  }

  VoidCallback onPunchCardsPressed(PunchCards punchCards) {
    switch (punchCards) {
      case PunchCards.work:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Container(),
            ));
      case PunchCards.getOff:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Container(),
            ));
      case PunchCards.makeUp:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Container(),
            ));
    }
  }

  VoidCallback onMainFunctionsPressed(MainFunctions mainFunction) {
    switch (mainFunction) {
      case MainFunctions.startPatrol:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StartPatrolScreen.create(),
            ));
      case MainFunctions.shift:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShiftScreen(),
            ));
      case MainFunctions.sos:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SOSScreen(),
            ));
      case MainFunctions.onboard:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OnBoardScreen(),
            ));
      case MainFunctions.formApply:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FormApplyScreen(),
            ));
      case MainFunctions.contactUs:
        return () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ContactUsScreen(),
            ));
    }
  }

  Icon getMainFunctionsIcon(MainFunctions mainFunction) {
    switch (mainFunction) {
      case MainFunctions.startPatrol:
        return const Icon(
          Icons.qr_code_scanner,
          size: 48,
          color: Colors.black87,
        );
      case MainFunctions.shift:
        return const Icon(
          Icons.calendar_month_outlined,
          size: 48,
          color: Colors.black87,
        );
      case MainFunctions.sos:
        return const Icon(
          Icons.sos_outlined,
          size: 48,
          color: Colors.black87,
        );
      case MainFunctions.onboard:
        return const Icon(
          Icons.badge_outlined,
          size: 48,
          color: Colors.black87,
        );
      case MainFunctions.formApply:
        return const Icon(
          Icons.description_outlined,
          size: 48,
          color: Colors.black87,
        );
      case MainFunctions.contactUs:
        return const Icon(
          Icons.call_outlined,
          size: 48,
          color: Colors.black87,
        );
    }
  }

  void signOut() {}

  void dispose() {}
}
