import 'package:flutter/material.dart';

class FlightTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20.0; // Semi-circle radius
    double centerY = size.height * 0.55; 
    Path ticketPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height),
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
      );

    // Create semi-circle cutouts
    Path cutoutPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, centerY), radius: radius))
      ..addOval(Rect.fromCircle(center: Offset(size.width, centerY), radius: radius));

    // Subtract cutouts from the ticket shape
    return Path.combine(PathOperation.difference, ticketPath, cutoutPath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
