import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {required this.onPressed,
      required this.text,
      required this.color,
      required this.borderColor,
      this.textColor,
      this.isDisabled = false,
      this.onDisabledPressed});

  final VoidCallback onPressed;
  final VoidCallback? onDisabledPressed;
  final Color color;
  final Color? textColor;
  final Color borderColor;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final textColor =
        this.textColor ?? Theme.of(context).primaryTextTheme.button!.color;

    return ButtonTheme(
        minWidth: double.infinity,
        height: 56.0,
        child: TextButton(
          onPressed: isDisabled ? onDisabledPressed : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: isDisabled ? Colors.transparent : color,
          ),
          child: Text(text,
              style: TextStyle(
                  fontSize: 20.0,
                  color: isDisabled ? Palette.darkGrey : textColor)),
        ));
  }
}

class LoadingPrimaryButton extends StatelessWidget {
  const LoadingPrimaryButton(
      {required this.onPressed,
      required this.text,
      required this.color,
      required this.borderColor,
      this.isDisabled = false,
      this.isLoading = false});

  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final bool isLoading;
  final bool isDisabled;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: double.infinity,
        height: 56.0,
        child: TextButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: color,
          ),
          child: isLoading
              ? CupertinoActivityIndicator(animating: true)
              : Text(text,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryTextTheme.button!.color)),
        ));
  }
}

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    required this.onPressed,
    required this.text,
    required this.color,
    this.textColor,
    required this.borderColor,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final VoidCallback onPressed;
  final Color color;
  final Color? textColor;
  final Color borderColor;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textColor =
        this.textColor ?? Theme.of(context).primaryTextTheme.button!.color;

    return ButtonTheme(
        minWidth: double.infinity,
        height: 56.0,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(10.0)
              ))
          ),
          child: Container(
            height: 45.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: iconBackgroundColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/delete.svg',width: 20,height: 20,),
                SizedBox(width: 10,),
                Text(text,
                    style: TextStyle(fontSize: 20.0, color: textColor))
              ],
            ),
          ),
        ));
  }
}
