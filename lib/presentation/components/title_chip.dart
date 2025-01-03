import 'package:flutter/material.dart';

class TitleChip extends StatelessWidget {
  final String? title; final Color? color; final TextStyle? titleStyle;
  const TitleChip({this.title, this.color, this.titleStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: color ?? Colors.deepPurple,
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Text(title ?? "Completed", style: titleStyle ?? TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),)
    );
  }
}
