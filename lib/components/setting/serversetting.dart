import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reflect/main.dart';

class ServerSetting extends StatefulWidget {
  final WidgetRef ref;
  const ServerSetting({super.key, required this.ref});

  @override
  State<ServerSetting> createState() => _ServerSettingState();
}

class _ServerSettingState extends State<ServerSetting> {
  final settingBox = Hive.box('settings');
  late String selectedServer;
  final servers = {
    'Localhost': 'http://192.168.29.226:3000/api',
    'Vercel': 'https://reflect-server.vercel.app/api',
    'AWS': 'http://13.233.167.195:3000/api'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final String server = settingBox.get('baseUrl', defaultValue: 'http://13.233.167.195:3000/api');
    selectedServer = server;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = widget.ref.watch(themeManagerProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color:  Color.fromARGB(64, 0, 0, 0),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Server', style: themeData.textTheme.titleMedium),
          const SizedBox(height: 20),
          Theme(
            data: themeData,
            child: DropdownMenu<String?>(
              label: Text('Server', style: themeData.textTheme.titleSmall),
              initialSelection: selectedServer,
              menuStyle: MenuStyle(
                backgroundColor: WidgetStateProperty.all(themeData.colorScheme.surface),
              ),
              textStyle: themeData.textTheme.bodyMedium,
              
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: servers['Localhost'],
                  label:  'Localhost',
                ),
                DropdownMenuEntry(
                  value: servers['Vercel'],
                  label:  'Vercel'
                ),
                DropdownMenuEntry(
                  value: servers['AWS'],
                  label:  'AWS'
                ),
              ],
              onSelected: (String? value) {
                settingBox.put('baseUrl', value);
              },
            ),
          )
        ],
      ),
    );
  }
}