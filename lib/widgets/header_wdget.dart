

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderWdget extends StatelessWidget {
  const HeaderWdget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
      const Text(
                    'Explore',
                    style: TextStyle(
                      color: Color(0xFF818181),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'All Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                        ),
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF8B8B8B),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2D2D2D),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF3B3B3B)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF5A5A5A)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
    ],);
  }
}