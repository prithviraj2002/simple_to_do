import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_to_do/generated/assets.dart';

class EmptyWidget extends StatelessWidget {
  final String? title, desc;
  const EmptyWidget({this.title, this.desc, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.svgsEmpty, height: 300, width: 200,),
        const SizedBox(height: 20,),
        title != null ? Text(title!, style: TextStyle(fontSize: 24),) : Container(),
        desc != null ? Text(desc!, style: TextStyle(fontSize: 20),) : Container(),
      ],
    );
  }
}
