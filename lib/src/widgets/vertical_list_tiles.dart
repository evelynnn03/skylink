import 'package:flutter/material.dart';
import 'package:flight_delay_app/src/constants/variables.dart';

class VerticalListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? containerCol;

  const VerticalListTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap, // optional
    this.containerCol,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: containerCol ?? Colors.black,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Variables.responsiveFontSize(context, 20),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: Variables.responsiveIconSize(context, 16),
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
