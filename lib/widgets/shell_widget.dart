

import 'package:dio_project/widgets/header_wdget.dart';
import 'package:flutter/material.dart';
class ShellWidget extends StatelessWidget {
  const ShellWidget({super.key , required this._child});
final Widget _child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            const HeaderWdget(),
               Expanded(child: _child)
            
            ],
          ),
        ),
      ),
    );
  }
}