import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reflect/models/tag.dart';

class TagService {
  final Box tagbox = Hive.box('tags');
  final User? user = FirebaseAuth.instance.currentUser;

  List<Tag> getAllTags(){
    final res = tagbox.get(user!.uid, defaultValue: []) as List;
    List<Tag> tagList = [];
    for (var tag in res) {
      tagList.add(Tag.fromMap(Map<String, dynamic>.from(tag)));

    }

    return tagList;
  }

  Future<void> updateTags(List<Tag> tags) async {
    List<Map<String, dynamic>> taglist = [];
    for (var tag in tags) {
      taglist.add(tag.toMap());
    }
    await tagbox.put(user!.uid, taglist);
  }

  List<Tag> parseTagFromEntryData(List<Map<String, dynamic>> entryData){
    List<Tag> tagData = [];
    for(var entry in entryData){
      if(entry.containsKey('tags')){
        for(var tags in entry['tags']){
          tagData.add(Tag.fromMap(tags));
        }
      }
    }

    return tagData;
  }

  Future<void> updateTagFromEntryData(List<Tag> tags) async {
    List<Map<String, dynamic>> taglist = [];
    for (var tag in tags) {
      taglist.add(tag.toMap());
    }
    await tagbox.put(user!.uid, taglist);
  }
}