import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.loading = false,
    this.height = 44,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.fontSize,
  });

  final VoidCallback onPressed;
  final String text;
  final double height;
  final Color bgColor;
  final Color? textColor;
  final bool loading;
  final BorderRadius borderRadius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final double fontSize1 = fontSize != null ? fontSize! : height * 0.43;
    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize1,
        color: textColor,
        letterSpacing: fontSize == null ? -0.41 : null,
        fontWeight: FontWeight.w600,
      ),
    );

    var children = [
      Flexible(
        child: textWidget,
      ),
    ];

    return loading
        ? CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height,
              child: SizedBox.expand(
                child: CupertinoButton(
                  borderRadius: borderRadius,
                  padding: EdgeInsets.zero,
                  color: bgColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: fontSize == null ? 16.0 : 5.0,
                    ),
                    height: height,
                    child: Row(
                      children: children,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          );
  }
}
