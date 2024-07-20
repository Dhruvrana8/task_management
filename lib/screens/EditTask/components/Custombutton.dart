import 'package:flutter/material.dart';
import 'package:task_management/constants/colors.dart';
import 'package:task_management/screens/EditTask/strings.dart';

class CustomButton extends StatelessWidget {
  final Function onPress;
  final bool withSideBorder;
  final String title;
  const CustomButton(
      {super.key,
      required this.onPress,
      required this.withSideBorder,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              withSideBorder ? CustomColors.whiteSmoky : CustomColors.primary,
          side: withSideBorder
              ? BorderSide(
                  width: 3.0,
                  color: CustomColors.primaryWithOpacity(0.5),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: withSideBorder ? CustomColors.primary : Colors.white,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
