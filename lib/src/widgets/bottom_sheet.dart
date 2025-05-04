import 'dart:ui';
import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flutter/material.dart';
import 'button.dart';

Future<void> showBottomSheetModal(
  BuildContext context,
  String title,
  String content,
  bool button, {
  String? buttonText,
  String? desc,
  VoidCallback? onTap,
  Function(String?)? onSectionSelected,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Variables.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(181, 69, 82, 168),
                    ),
                  ),
                ),
                const Spacer(),
                if (button && buttonText != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyButton(
                      text: buttonText,
                      onTap: () {
                        Navigator.pop(context);
                        if (onTap != null) {
                          onTap();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
