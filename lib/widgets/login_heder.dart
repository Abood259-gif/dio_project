

import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.shopping_bag_outlined,
    this.boxSize = 96,
    this.iconSize = 44,
    this.titleFontSize = 52,
    this.subtitleFontSize = 18,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final double boxSize;
  final double iconSize;
  final double titleFontSize;
  final double subtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: const Color(0xFF328A5B),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFA0A0A0),
            fontSize: subtitleFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}