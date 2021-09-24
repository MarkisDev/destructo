import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:io';

part 'groupItems.g.dart';

@HiveType(typeId: 1)
class GroupItems {
  @HiveField(0)
  String name;
  @HiveField(1)
  final Iterable<String> dirPath;
  @HiveField(2)
  final Iterable<String> filePath;

  GroupItems(this.dirPath, this.filePath, this.name);

// Returns all the paths as a full list using spreader operator
  Iterable<String> allItems() {
    return [...dirPath, ...filePath];
  }

  // Adding everything to the db
  void addGroup() {
    GroupItems group = GroupItems(dirPath, filePath, name);
    final groupBox = Hive.box('destructo');
    final statBox = Hive.box('des_stats');
    int created = statBox.get('created') ?? 0;
    groupBox.add(group);
    statBox.put('created', created + 1);
  }

  // Editing the value
  void editGroup(int index) {
    GroupItems group = GroupItems(dirPath, filePath, name);
    final groupBox = Hive.box('destructo');
    groupBox.putAt(index, group);
  }

  Future<bool> deleteGroup(int index) async {
    GroupItems group = GroupItems(dirPath, filePath, name);
    final groupBox = Hive.box('destructo');
    final statBox = Hive.box('des_stats');
    int destructed = statBox.get('destructed') ?? 0;
    group.allItems().forEach((element) async {
      // Checking if it's a file first
      if (await File(element).exists()) {
        try {
          await File(element).delete(recursive: true);
        } catch (e) {
          return false;
        }
      } else if (await Directory(element).exists()) {
        try {
          await Directory(element).delete(recursive: true);
        } catch (e) {
          return false;
        }
      }
    });
    groupBox.deleteAt(index);
    statBox.put('destructed', destructed + 1);
    return true;
  }
}
