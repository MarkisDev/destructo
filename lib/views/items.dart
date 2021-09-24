import 'package:destructo/models/groupItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:listview_utils/listview_utils.dart';
import 'dart:io';

class ItemsScreen extends StatelessWidget {
  final GroupItems groupItems;
  ItemsScreen(this.groupItems);

  @override
  Widget build(BuildContext context) {
    // Setting full size of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 10, 0),
              child: FloatingActionButton(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Icon(TablerIcons.x),
                ),
                backgroundColor: Theme.of(context).accentColor,
                elevation: 0,
                heroTag: 0,
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            // Hack to add max space between two buttons
            Expanded(child: SizedBox()),
          ]),
      body:
          // Main column
          Column(children: [
        Container(
          height: height * 0.2,
        ),
        Container(
          height: height * 0.8,
          width: width,

          // padding: EdgeInsets.fromLTRB(width * 0.1, 0, 0, 0),
          // Displaying all the items in the two Iterables calling a function from GroupItems
          child: GlowingOverscrollIndicator(
            color: Theme.of(context).scaffoldBackgroundColor,
            axisDirection: AxisDirection.down,
            showLeading: false,
            child: CustomListView(
              itemCount: groupItems.allItems().length,
              empty: Center(
                  child: Text('No items added!',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.white.withOpacity(0.5),
                          ))),
              disableRefresh: true,
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              itemBuilder: (BuildContext context, int index, item) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                          // If the file exists add File icon else Folder
                          child: File(groupItems.allItems().elementAt(index))
                                  .existsSync()
                              ? Icon(
                                  TablerIcons.file,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(1),
                                  size: 32,
                                )
                              : Icon(
                                  TablerIcons.folder,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(1),
                                  size: 32,
                                ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        // Finding folder / file name
                        child: Text(
                            '${groupItems.allItems().elementAt(index).split("/").last}',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(1))),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 15);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
