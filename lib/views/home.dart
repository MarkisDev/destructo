import 'package:destructo/views/add.dart';
import 'package:destructo/views/details.dart';
import 'package:destructo/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:listview_utils/listview_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _drawerController = ZoomDrawerController();
  final groupBox = Hive.box('destructo');

  final statBox = Hive.box('des_stats');

  @override
  Widget build(BuildContext context) {
    // Setting full size of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // return HomeScreen(width: width, statBox: statBox, height: height);
    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        // style: DrawerStyle.Style3,
        menuScreen: MenuScreen(_drawerController),
        style: DrawerStyle.DefaultStyle,
        mainScreen: HomeScreen(
          width: width,
          statBox: statBox,
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.width,
    @required this.statBox,
    @required this.height,
    @required this.drawerController,
  }) : super(key: key);

  final double width;
  final Box statBox;
  final double height;
  final ZoomDrawerController drawerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddScreen(),
            ),
          )
        },
        splashColor: Theme.of(context).accentColor.withOpacity(0.4),
        backgroundColor: Theme.of(context).primaryColorDark,
        focusColor: Theme.of(context).primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        label: Text(
          'Create Group',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).accentColor),
        ),
        icon: Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Icon(
            TablerIcons.plus,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('destructo'),
        elevation: 0,
        leading: InkWell(
          splashColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
          focusColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
          highlightColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
          hoverColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
          borderRadius: BorderRadius.circular(100),
          child: Icon(TablerIcons.menu),
          onTap: () {
            drawerController.toggle();
          },
        ),
      ),
      body: GlowingOverscrollIndicator(
        color: Theme.of(context).scaffoldBackgroundColor,
        axisDirection: AxisDirection.down,
        showLeading: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Allowing the list to expand to alloted space
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: Hive.box('destructo').listenable(),
                  builder: (context, groupBox, _) {
                    // Adding everything to a header so it scrolls down
                    return CustomListView(
                      header: Column(
                        children: [
                          // First Row
                          Row(
                            children: [
                              // Column for the first row items
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 30, 10, 20),
                                    child: Text(
                                      'DASHBOARD',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.5)),
                                    ),
                                  ),
                                  // Row for the stat cards
                                  Container(
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: Container(
                                            height: 110,
                                            width: 180,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            // Column for stats
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Container(
                                                // padding: EdgeInsets.fromLTRB(20, 0, 25, 0),
                                                // Column for the text details
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      '${statBox.get('created') ?? 0}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark),
                                                    ),
                                                    Text(
                                                      'Groups Created',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark
                                                                  .withOpacity(
                                                                      0.5)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: Container(
                                            height: 110,
                                            width: 180,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            // Column for stats
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Container(
                                                // color: Colors.red,
                                                // Column for the text details
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      '${statBox.get('destructed') ?? 0}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight
                                                                  .withOpacity(
                                                                      1)),
                                                    ),
                                                    Text(
                                                      'Groups Destructed',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight
                                                                  .withOpacity(
                                                                      0.5)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 30, 10, 20),
                                child: Text(
                                  'GROUPS',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ), // Second Row
                      footer: SizedBox(height: height * 0.05),
                      itemCount: groupBox.length,
                      itemBuilder: (BuildContext context, int index, item) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            width: width * 0.7,
                            // InkWell to show detailed screen
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailScreen(
                                            groupBox.getAt(index), index),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // For overflow
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                          '${groupBox.getAt(index).name}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Theme.of(context)
                                                      .primaryColorDark)),
                                    ),
                                  ),
                                  Text(
                                      '${groupBox.getAt(index).allItems().length} Items',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(1)))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 15);
                      },
                      disableRefresh: true,
                      // padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      empty: Container(
                          height: height * 0.4,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/void.svg',
                                  semanticsLabel: 'A red up arrow',
                                  width: width * 0.3,
                                ),
                                Text('No Groups Found!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.white, fontSize: 18)),
                                Text('Create a Group to get started',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            fontSize: 14)),
                              ],
                            ),
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
