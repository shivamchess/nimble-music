import 'package:flutter/material.dart';

class SoundwaveWidget extends StatelessWidget {
  final Color color;

  const SoundwaveWidget({super.key, this.color = const Color(0xFF111113)});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBar(16),
        const SizedBox(width: 5),
        _buildBar(26),
        const SizedBox(width: 5),
        _buildBar(38),
        const SizedBox(width: 5),
        _buildBar(20),
        const SizedBox(width: 5),
        _buildBar(10),
      ],
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
