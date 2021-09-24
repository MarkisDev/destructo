import 'package:destructo/views/about.dart';
import 'package:destructo/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuScreen extends StatelessWidget {
  final ZoomDrawerController drawerController;
  MenuScreen(this.drawerController);

  @override
  Widget build(BuildContext context) {
    // Setting full size of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
          child: Container(
        width: width * 0.5,
        padding: EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.07,
            ),
            FittedBox(
              child: GestureDetector(
                onTap: () {
                  drawerController.toggle();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child:
                      Icon(Icons.chevron_left, size: 30, color: Colors.white),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1.2,
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            Text(
              'Options',
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 36),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(),
                  ),
                );
              },
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.3),
                      child: Icon(
                        TablerIcons.home,
                        color: Theme.of(context).primaryColorDark,
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(
                      'Home',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => About(),
                  ),
                );
              },
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.3),
                      child: Icon(
                        TablerIcons.info_circle,
                        color: Theme.of(context).primaryColorDark,
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 20,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
