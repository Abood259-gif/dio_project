

import 'package:flutter/material.dart';

class CustemButton extends StatelessWidget {
  const CustemButton({super.key , 
  this.onTap
  });
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF2F80ED), Color(0xFF00C6FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: GestureDetector(
        onTap: onTap ,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.send, color: Colors.white),
        ),
      ),
    );
  }
}