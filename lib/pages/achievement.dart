import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:reflect/components/achievement/ach_card.dart';
import 'package:reflect/main.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:reflect/models/achievement.dart';
import 'package:reflect/models/user_setting.dart';
import 'package:reflect/services/cache_service.dart';
import 'package:reflect/services/tag_service.dart';
import 'package:reflect/services/user_service.dart';

class AchievementPage extends ConsumerStatefulWidget {
  const AchievementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<AchievementPage> {
  List<Achievement> achievements = [
    Achievement(title: "First Impressions", description: "Create your very first journal entry", icon: Icons.star, color: Colors.orange),

    Achievement(title: "The Collector", description: "Create 100 entries", icon: Icons.task, color: Colors.amber),
    Achievement(title: "The Chronicler", description: "Create 500 entries", icon: Icons.receipt_long, color: Colors.yellow),

    //Achievement(title: "Epic Chronicler", description: "Write 100,000 words in total.", icon: Icons.history_edu, color: Colors.yellow),
    //Achievement(title: "Master Chronicler", description: "Write 500,000 words in total.", icon: Icons.history_edu, color: Colors.white),
    Achievement(title: "New Journey", description: "Create your first chapter", icon: Icons.auto_stories, color: Colors.teal),
    Achievement(title: "Saga Creator", description: "Create 10 chapters", icon: Icons.history_edu, color: Colors.tealAccent),

    Achievement(title: "Taggy", description: "Create 10 tags", icon: Icons.sell, color: Colors.lightBlue),
    Achievement(title: "Tag Master", description: "Create 50 tags", icon: Icons.style, color: Colors.cyan),

    Achievement(title: "Favorites Fanatic", description: "Favorite 25 of your own entries", icon: Icons.favorite_outline, color: Colors.pink),
    Achievement(title: "Favorites Master", description: "Favorite 50 of your own entries", icon: Icons.favorite_rounded, color: Colors.pinkAccent),

    //Upload your first image achievement
    Achievement(title: "Picture Perfect", description: "Upload your first image", icon: Icons.photo_camera, color: Colors.blueAccent),
    Achievement(title: "Photographer", description: "Upload 10 images", icon: Icons.photo_album, color: Colors.cyan),

    Achievement(title: "Short and sweet", description: "Write an entry with fewer than 50 words.", icon: Icons.fiber_manual_record, color: Colors.purple),
    Achievement(title: "Long-winded", description: "Write an entry with more than 1000 words.", icon: Icons.circle, color: Colors.purpleAccent),
  ];

  List<bool> achievementStatus = List.generate(13, (index) => false);

  bool showMoreAchievement = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateAcheivements();
  }

  void calculateAcheivements(){
    final cacheService = CacheService();
    final userSetting = UserService().getUserSettingFromCache();
    final chapterDetails = cacheService.exportFromCache(userSetting.uid);
    final allTags = TagService().getAllTags();

    bool firstEntry = false;
    bool firstChapter = false;
    bool tenChapter = false;
    bool tenTags = false;
    bool fiftyTags = false;
    bool twentyFiveFav = false;
    bool fiftyFav = false;
    bool hundredEntries = false;
    bool fiveHundredEntries = false;
    bool firstImage = false;
    bool tenImages = false;
    bool shortEntry = false;
    bool longEntry = false;

    int totalEntries = 0;
    int totalFavs = 0;
    int totalImages = 0;
    int totalChapters = chapterDetails.length;
    int totalTags = allTags.length;
    int shortestLength = 0;
    int longestLength = 0;
    int totalWords = 0;

    if(chapterDetails.isNotEmpty){
      firstChapter = true; //4
      if(totalChapters >= 10) tenChapter = true; //5
      

      for(var chapter in chapterDetails){
        totalEntries += (List.from(chapter['entries'] ?? [])).length;
        totalImages += List.from(chapter['imageUrl'] ?? []).length;

        for(var entry in List<Map<dynamic, dynamic>>.from(chapter['entries'] ?? [])){
          if(entry['isFav'] ?? false) totalFavs++;
          /*if(entry['images'] != null && (entry['images'] as List).isNotEmpty){
            firstImage = true;
            totalImages += (entry['images'] as List).length;
          }*/
          if(entry['content'] != null){
            final delta = quill.Document.fromJson(entry['content']);
            final text = delta.toPlainText().split(" ");

            shortestLength = shortestLength == 0 ? text.length : min(shortestLength, text.length);
            longestLength = max(longestLength, text.length);
            totalWords += text.length;

            if(text.length < 50) shortEntry = true;
            if(text.length > 1000) longEntry = true;
          }
        }
      }
    }

    if(totalEntries >= 1) firstEntry = true; //1
    if(totalEntries >= 100) hundredEntries = true; //2
    if(totalEntries >= 500) fiveHundredEntries = true; //3

    if(totalTags >= 10) tenTags = true; //6
    if(totalTags >= 50) fiftyTags = true; //7

    if(totalFavs >= 25) twentyFiveFav = true; //8
    if(totalFavs >= 50) fiftyFav = true; //9

    if(totalImages >= 1) firstImage = true; //10
    if(totalImages >= 10) tenImages = true; //11

    achievementStatus = [firstEntry, hundredEntries, fiveHundredEntries, firstChapter, tenChapter, tenTags, fiftyTags, twentyFiveFav, fiftyFav, firstImage, tenImages, shortEntry, longEntry];

    print("Achievement Status: $achievementStatus");
    print("Total Entries: $totalEntries, Total Chapters: $totalChapters, Total Tags: $totalTags, Total Favs: $totalFavs, Total Images: $totalImages, Shortest: $shortestLength, Longest: $longestLength, Total Words: $totalWords");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeManagerProvider);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [themeData.colorScheme.tertiary, themeData.colorScheme.onTertiary]
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Achievements", style: themeData.textTheme.titleLarge,),
            SizedBox(height: 20,),
            /*GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: achievements.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 16),
              itemBuilder: (BuildContext context, int index){
                return AchievementCard(achievement: achievements[index], achieved: true, themeData: themeData);
              }
            )*/
            Align(child: Text("Your achievements", style: themeData.textTheme.bodyMedium!.copyWith(color: themeData.colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.left,), alignment: Alignment.centerLeft,),
            ListView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: showMoreAchievement ? achievements.length : min(3, achievements.length),
              itemBuilder: (BuildContext context, int index){
                return AchievementCard(achievement: achievements[index], achieved: achievementStatus[index], themeData: themeData);
              }
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                setState(() {
                  showMoreAchievement = !showMoreAchievement;
                });
              },
              
              child: Text(showMoreAchievement ? "Show Less" : "Show More", style: themeData.textTheme.bodyMedium!.copyWith(color: themeData.colorScheme.primary, fontSize: 16), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),

            Align(child: Text("Statistics", style: themeData.textTheme.bodyMedium!.copyWith(color: themeData.colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.left,), alignment: Alignment.centerLeft,),
          ],
        )
      ),
    );
  }}