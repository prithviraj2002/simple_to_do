import 'package:flutter/material.dart';

class ToDoCheckbox extends StatelessWidget {
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  const ToDoCheckbox({super.key, required this.isCompleted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isCompleted,
      onChanged: onChanged,
    );
  }
}
