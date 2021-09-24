import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/groupItems.dart';

void main() async {
  // Opening box so I can use it in other files
  await Hive.initFlutter();
  Hive.registerAdapter(GroupItemsAdapter());
  await Hive.openBox('destructo');
  await Hive.openBox('des_stats');
  runApp(ProviderScope(child: Destructo()));
}

class Destructo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Setting global theme
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(15, 0, 26, 1),
        accentColor: Color(0xFF292C4F),
        primaryColorDark: Color(0xFFA591F2),
        primaryColorLight: Color(0x43CFCF),
        scaffoldBackgroundColor: Color.fromRGBO(14, 14, 27, 1),
        fontFamily: 'OpenSauce',
        // Setting App Bar global theme
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              color: Color.fromRGBO(14, 14, 27, 1),
              textTheme: ThemeData.dark().textTheme.copyWith(
                    headline6: TextStyle(
                        fontFamily: 'RedHat',
                        fontSize: 38.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -3.2),
                  ),
            ),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          headline4: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          headline3: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),

          // For card headlines
          headline6: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          bodyText1: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white),

          bodyText2: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            letterSpacing: 3,
            fontFamily: 'RedHat',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: Home(),
    );
  }
}
