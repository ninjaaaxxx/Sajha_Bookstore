import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Settings/Components/helpcenter.dart';
import 'package:sajhabackup/Settings/Components/theme.dart';
import 'package:sajhabackup/Settings/Components/userDetails.dart';
import 'package:sajhabackup/Widgets/settingstile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontFamily: bold, color: color1),
        ),
        backgroundColor: color,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsTile(
                color: color,
                icon: Ionicons.person_circle_outline,
                title: "Account",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccDetails()));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: color,
                icon: Ionicons.help,
                title: "Help Center",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => helpcenter()));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: color,
                icon: Ionicons.moon_outline,
                title: "Theme",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => theme()));
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
