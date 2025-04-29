import 'package:flight_delay_app/src/widgets/button.dart';
import 'package:flight_delay_app/src/widgets/textfield.dart';
import 'package:flutter/material.dart';

import '../constants/variables.dart';

class PasswordSettings extends StatefulWidget {
  const PasswordSettings({super.key});

  @override
  State<PasswordSettings> createState() => _PasswordSettingsState();
}

class _PasswordSettingsState extends State<PasswordSettings> {
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Please enter your email address below, we will send you a link to reset your password.',
                style: TextStyle(
                  fontSize: Variables.responsiveFontSize(context, 15),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'E-mail address',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Variables.responsiveFontSize(context, 18)),
              ),
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: emailTextController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 30),
            MyButton(
              text: 'Submit',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
