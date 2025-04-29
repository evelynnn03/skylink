import 'package:flight_delay_app/src/screens/password_settings.dart';
import 'package:flight_delay_app/src/screens/profile_settings.dart';
import 'package:flutter/material.dart';

import '../constants/variables.dart';
import '../widgets/vertical_list_tiles.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Text(
          'Account Settings',
          style: TextStyle(
            fontSize: Variables.responsiveFontSize(context, 30),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Variables.backButton(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSettings()),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(-5, -3),
                    ),

                    // Grey shadow on the bottom right for contrast
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Variables.primaryColor,
                            radius: 25,
                            child: Icon(
                              Icons.person_rounded,
                              size: Variables.responsiveIconSize(context, 45),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Evelyn Tan',
                            style: TextStyle(
                              fontSize:
                                  Variables.responsiveFontSize(context, 25),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ), //C
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                VerticalListTile(
                  title: 'Change Password',
                  icon: Icons.password,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PasswordSettings()),
                    );
                  },
                ),
                VerticalListTile(
                  title: 'Delete account',
                  icon: Icons.delete,
                  containerCol: const Color.fromARGB(255, 255, 166, 159),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
