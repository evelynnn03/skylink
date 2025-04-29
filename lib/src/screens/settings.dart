import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/screens/account_settings.dart';
import 'package:flutter/material.dart';

import '../widgets/vertical_list_tiles.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<Map<String, dynamic>> settingsTiles = [
    {
      'title': 'Account',
      'icon': Icons.person_rounded,
    },
    {
      'title': 'Customer Support',
      'icon': Icons.support_agent_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: Variables.responsiveFontSize(context, 30),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          VerticalListTile(
            title: 'Account',
            icon: Icons.manage_accounts_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountSettings()),
              );
            },
          ),
          VerticalListTile(
            title: 'Customer Support',
            icon: Icons.support_agent_rounded,
            // No onTap, just leave it empty
          ),
        ],
      ),
    );
  }
}
