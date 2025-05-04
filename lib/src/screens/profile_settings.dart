import 'package:flight_delay_app/src/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:io';
import '../constants/variables.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final fullNameTextController = TextEditingController();
  final phoneNoTextController = TextEditingController();
  final emailTextController = TextEditingController();

  File? _profileImage;
  final _picker = ImagePicker();

  pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _profileImage = File(pickedImage.path);
      setState(() {});
    }
  }

  @override
  void dispose() {
    fullNameTextController.dispose();
    phoneNoTextController.dispose();
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 25.0,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Variables.primaryColor,
                        radius: 40,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person_rounded,
                                size: Variables.responsiveIconSize(context, 70),
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                MyTextField(
                  controller: fullNameTextController,
                  hintText: 'Username',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      hintStyle: Variables.hintStyle(context),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Variables.primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    initialCountryCode: 'MY',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    disableLengthCheck:
                        true, // Optional: avoids validation errors
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(height: 15),
                MyTextField(
                  controller: fullNameTextController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.text,
                )
              ],
            ),
          ),
        ));
  }
}
