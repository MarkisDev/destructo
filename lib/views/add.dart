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
import 'package:local_auth/local_auth.dart';
import 'package:device_info/device_info.dart';

final groupItemsProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final groupNameProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Directory rootPath;
  Iterable<String> filePath = [];
  Iterable<String> dirPath = [];

  @override
  void initState() {
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
      context.read(groupItemsProvider).state = dirPath.length + filePath.length;
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
      context.read(groupItemsProvider).state = dirPath.length + filePath.length;

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
              final groupName = watch(groupNameProvider);
              final groupItems = watch(groupItemsProvider);
              return FloatingActionButton.extended(
                heroTag: 1,
                onPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => AddScreen(),
                  //   ),
                  // )

                  if (groupName.state.isEmpty) {
                    // Showing scaffold

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Group name cannot be empty!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                    ));
                  } else if (groupItems.state == 0) {
                    // Showing scaffold
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('No items added to group!'),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    bool isAuthenticated = await authenticateUser();
                    if (isAuthenticated) {
                      // Snackbar baby
                      GroupItems(dirPath, filePath, groupName.state).addGroup();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Group has been added!'),
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: Colors.green,
                      ));
                      // Remove screen
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Authentication failed!'),
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
                splashColor: Theme.of(context).accentColor.withOpacity(0.4),
                backgroundColor: Theme.of(context).primaryColorDark,
                focusColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                label: Text(
                  'Add Group',
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
                height: height * 0.85,
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
                            final groupName = watch(groupNameProvider);
                            return Container(
                              width: width * 0.85,
                              child: TextField(
                                onChanged: (text) {
                                  // Updating the provider
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Container(
                                // color: Colors.red,
                                child: Consumer(
                                    builder: (_, ScopedReader watch, __) {
                                  final groupItems = watch(groupItemsProvider);
                                  final groupName = watch(groupNameProvider);
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
