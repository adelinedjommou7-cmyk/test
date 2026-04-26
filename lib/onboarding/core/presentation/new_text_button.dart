import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:flutter/material.dart'; 

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    required this.bgColor,
  }) : super(key: key);
  final String buttonName;
  final VoidCallback onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        height: SizeConfig.blockSizeH! * 5.5,
        width: SizeConfig.blockSizeH! * 50,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
          ),
          child: Text(
            buttonName,
            style: kBodyText1,
          ),
        ),
      ),
    );
  }
}
