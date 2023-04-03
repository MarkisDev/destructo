import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:destructo/views/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        // style: DrawerStyle.Style3,
        menuScreen: MenuScreen(_drawerController),
        style: DrawerStyle.DefaultStyle,
        mainScreen: AboutScreen(
          width: width,
          height: height,
          drawerController: _drawerController,
        ),
        borderRadius: 25,
        slideWidth: width * 0.55,
        mainScreenScale: 0.12,
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  const AboutScreen({
    Key key,
    @required this.height,
    @required this.width,
    @required this.drawerController,
  }) : super(key: key);

  final double height;
  final double width;
  final ZoomDrawerController drawerController;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        showLeading: false,
        showTrailing: false,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: height * 0.07),
                // Row for the version number
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () {
                      drawerController.toggle();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Icon(
                        TablerIcons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Column(
                        children: [
                          Text(
                            'destructo',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -3.2,
                                      fontSize: 38,
                                    ),
                          ),
                          Text(
                            'v0.0.1',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: height * 0.07,
                ),
                Container(
                  // Making this full width to get the LABEL alignment
                  width: width,
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [],
                      ),
                      Text(
                        'OUR TEAM',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _launchURL('https://markis.dev');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Special row for avatar
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/markisdev.png'),
                                      minRadius: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.07,
                                    ),
                                    // Text Column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'MarkisDev',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  letterSpacing: 1),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Text('Developer & Co-founder',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      letterSpacing: 1)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  TablerIcons.chevron_right,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _launchURL('https://dribble.com/PolyBot');
                        },                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Special row for avatar
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/swapneel.png'),
                                      minRadius: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.07,
                                    ),
                                    // Text Column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Swapneel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  letterSpacing: 1),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Text('Designer & Co-founder',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      letterSpacing: 1)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  TablerIcons.chevron_right,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text(
                        'SUPPORT DEVELOPMENT',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          _launchURL('https://privlink.xyz/destructo');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Special row for avatar
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Icon(
                                          TablerIcons.brand_google_play,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      minRadius: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.07,
                                    ),
                                    // Text Column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rate our app',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  letterSpacing: 1),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Text(
                                              'We\'d love some feedback!',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      letterSpacing: 1)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  TablerIcons.chevron_right,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          _launchURL('https://www.buymeacoffee.com/markisdev');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Special row for avatar
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Icon(
                                          TablerIcons.mug,
                                          color: Colors.white,
                                        ),
                                      ),
                                      minRadius: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.07,
                                    ),
                                    // Text Column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Buy us a coffee',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  letterSpacing: 1),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Text(
                                              'Support our development!',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      letterSpacing: 1)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  TablerIcons.chevron_right,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share(
                              'Check out Destructo! An app to destruct your chosen files and folders!\n',
                              subject:
                                  'Destructo - Destruct your files and folders!');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Special row for avatar
                              FittedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Icon(
                                          TablerIcons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                      minRadius: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.07,
                                    ),
                                    // Text Column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Share',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  letterSpacing: 1),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Text(
                                              'Share this app with others!',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      letterSpacing: 1)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  TablerIcons.chevron_right,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
