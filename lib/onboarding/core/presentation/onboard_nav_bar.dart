import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:flutter/material.dart'; 

class OnBoardNavBtn extends StatelessWidget {
  const OnBoardNavBtn({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      splashColor: Colors.black12,
      child: Container(
        // height: sizeH * 1.5,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            name,
            style: kBodyText1,
          ),
        ),
      ),
    );
  }
}
