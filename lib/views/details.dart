import 'package:destructo/models/groupItems.dart';
import 'package:destructo/views/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:local_auth/auth_strings.dart';
import 'items.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slider_button/slider_button.dart';
import 'package:local_auth/local_auth.dart';
import 'package:device_info/device_info.dart';

final groupItemsProvider =
    StateProvider.autoDispose.family<int, int>((ref, length) {
  return length;
});

final groupNameProvider =
    StateProvider.autoDispose.family<String, String>((ref, name) {
  return name;
});

class DetailScreen extends StatefulWidget {
  final GroupItems groupItems;
  final int itemIndex;
  DetailScreen(this.groupItems, this.itemIndex);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _controllerGroupName = TextEditingController();

  Directory rootPath;
  Iterable<String> filePath;
  Iterable<String> dirPath;

  @override
  void initState() {
    // Initializing text controller and dir and file path for items
    _controllerGroupName.text = widget.groupItems.name;
    filePath = widget.groupItems.filePath;
    dirPath = widget.groupItems.dirPath;
    super.initState();
    _prepareStorage();
  }

  static Future<bool> authenticateUser() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();

    bool isAuthenticated = true;

    if (isBiometricSupported) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please verify yourself to destruct!',
        androidAuthStrings: AndroidAuthMessages(
            biometricHint: '',
            biometricNotRecognized: 'Sorry, verification failed!',
            biometricRequiredTitle: 'Confirm to Destruct'),
        stickyAuth: true,
      );
    }

    return isAuthenticated;
  }

  Future<void> _prepareStorage() async {
    rootPath = Directory('/storage/emulated/0');
  }

  Future<void> _pickDir(BuildContext context) async {
    Iterable<String> path = await FilesystemPicker.open(
        title: 'Save to folder',
        multiSelect: true,
        themeData: ThemeData.dark().copyWith(
            primaryColor: Theme.of(context).scaffoldBackgroundColor,
            scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColorDark: Theme.of(context).accentColor),
        context: context,
        rootDirectories: [rootPath],
        fsType: FilesystemType.folder,
        pickText: 'Save file to this folder',
        folderIconColor: Theme.of(context).primaryColorLight.withOpacity(1),
        requestPermission: () async {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          var sdkInt = androidInfo.version.sdkInt;
          if (sdkInt >= 30)
            return await Permission.manageExternalStorage.request().isGranted;
          else
            return await Permission.storage.request().isGranted;
        });

    setState(() {
      dirPath = path ?? [];
      context
          .read(groupItemsProvider(widget.groupItems.allItems().length))
          .state = dirPath.length + filePath.length;
      // Directory(dirPath).delete(recursive: true);
    });
  }

  Future<void> _pickFile(BuildContext context) async {
    Iterable<String> path = await FilesystemPicker.open(
        title: 'Save to folder',
        multiSelect: true,
        themeData: ThemeData.dark().copyWith(
            primaryColor: Theme.of(context).scaffoldBackgroundColor,
            scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColorDark: Theme.of(context).accentColor),
        context: context,
        rootDirectories: [rootPath],
        fsType: FilesystemType.file,
        pickText: 'Save file to this folder',
        folderIconColor: Theme.of(context).primaryColorLight.withOpacity(1),
        requestPermission: () async {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          var sdkInt = androidInfo.version.sdkInt;
          if (sdkInt >= 30)
            return await Permission.manageExternalStorage.request().isGranted;
          else
            return await Permission.storage.request().isGranted;
        });

    setState(() {
      filePath = path ?? [];
      context
          .read(groupItemsProvider(widget.groupItems.allItems().length))
          .state = dirPath.length + filePath.length;

      // Directory(dirPath).delete(recursive: true);
    });
  }

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
            // Consumer to use GroupName in FAB
            Consumer(builder: (_, ScopedReader watch, __) {
              final groupName =
                  watch(groupNameProvider(widget.groupItems.name));
              return FloatingActionButton.extended(
                heroTag: 1,
                onPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => AddScreen(),
                  //   ),
                  // )
                  bool isAuthenticated = await authenticateUser();
                  if (isAuthenticated) {
                    // Snackbar baby
                    GroupItems(dirPath, filePath, groupName.state)
                        .editGroup(widget.itemIndex);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Group has been updated!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Authentication failed!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                splashColor: Theme.of(context).accentColor.withOpacity(0.4),
                backgroundColor: Theme.of(context).primaryColorDark,
                focusColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                label: Text(
                  'Edit Group',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Icon(
                    TablerIcons.chevron_up,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              );
            }),
          ]),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: height * 0.15,
            // color: Colors.blue,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            // Main Row
            children: [
              Container(
                height: height * 0.57,
                // color: Colors.red,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Consumer to update the state of GroupName
                          Consumer(builder: (_, ScopedReader watch, __) {
                            final groupName = watch(
                                groupNameProvider(widget.groupItems.name));
                            return Container(
                              width: width * 0.85,
                              child: TextField(
                                controller: _controllerGroupName,
                                onChanged: (text) {
                                  groupName.state = text;
                                },
                                minLines: 1,
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: Theme.of(context).primaryColorDark,
                                cursorWidth: 3,
                                cursorHeight: 25,
                                style: Theme.of(context).textTheme.headline4,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: false,
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    hintText: 'Group Name',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          color: Colors.white.withOpacity(0.5),
                                        )),
                              ),
                            );
                          }),
                          Container(
                            // color: Colors.amberAccent,
                            width: width,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Container to increase button size
                                Container(
                                  height: 50,
                                  width: width * 0.4,
                                  child: OutlinedButton.icon(
                                      onPressed: () async {
                                        _pickDir(context);
                                      },
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).accentColor),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                width: 2)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)))),
                                      ),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.2),
                                        child: Icon(
                                          TablerIcons.folder_plus,
                                          color: Colors.white,
                                        ),
                                      ),
                                      label: Text(
                                        'Add Folders',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                ),
                                Container(
                                  height: 50,
                                  width: width * 0.4,
                                  child: OutlinedButton.icon(
                                      onPressed: () {
                                        _pickFile(context);
                                      },
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).accentColor),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        side: MaterialStateProperty
                                            .all<BorderSide>(BorderSide(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                width: 2)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)))),
                                      ),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.2),
                                        child: Icon(
                                          TablerIcons.file_plus,
                                          color: Colors.white,
                                          size: 21,
                                        ),
                                      ),
                                      label: Text(
                                        'Add files',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container to increase width, then margin to position
                    Container(
                      // color: Colors.red,
                      // width: width,
                      margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Container(
                                // color: Colors.red,
                                // Wrapping consumer here to add name to ItemsScreen
                                child: Consumer(
                                    builder: (_, ScopedReader watch, __) {
                                  final groupItems = watch(groupItemsProvider(
                                      widget.groupItems.allItems().length));
                                  final groupName = watch(groupNameProvider(
                                      widget.groupItems.name));
                                  return TextButton(
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ItemsScreen(GroupItems(dirPath,
                                                  filePath, groupName.state)),
                                        ),
                                      )
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .primaryColorLight
                                                    .withOpacity(0.2))),
                                    // Using RiverPod to change number of items!
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 6),
                                          child: Icon(TablerIcons.files,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(1)),
                                        ),
                                        Text("${groupItems.state} Items Added",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0,
                                                    color: Theme.of(context)
                                                        .primaryColorLight
                                                        .withOpacity(1))),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 0, 0, 6),
                                          child: Icon(
                                            TablerIcons.chevron_up,
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: SliderButton(
              action: () async {
                // Fingerprint wall
                bool isAuthenticated = await authenticateUser();
                if (isAuthenticated) {
                  ///Do something here OnSlide

                  // Deleting
                  if (await widget.groupItems.deleteGroup(widget.itemIndex)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Group has been destructed!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                          'There was an issue destructing the group!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                    ));
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Authentication failed!'),
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor: Colors.red,
                  ));
                }
              },
              vibrationFlag: true,
              dismissible: false,
              dismissThresholds: 0.7,
              // Making my own button :D
              child: Container(
                height: 70,
                width: 160,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Destruct',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Icon(TablerIcons.chevron_right,
                          color: Theme.of(context).accentColor),
                    )
                  ],
                ),
              ),

              //Put BoxShadow here
              boxShadow: BoxShadow(
                color: Colors.black,
                blurRadius: 4,
              ),
              shimmer: true,
              // label: Text(
              //   'slide to destruct',
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline4
              //       .copyWith(fontSize: 24),
              // ),

              ///Change All the color and size from here.
              width: width * 0.9,
              radius: 100,
              buttonColor: Theme.of(context).primaryColorDark,
              backgroundColor: Color(0xff161A35).withOpacity(0.8),
              highlightedColor: Colors.white,
              baseColor: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
