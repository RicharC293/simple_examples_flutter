import 'package:flutter/cupertino.dart';

class ZeroButton extends StatelessWidget {
  const ZeroButton({
    super.key,
    required this.label,
    this.backgroundColor,
    required this.onTap,
    this.labelColor,
    required this.layoutSize,
  });

  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  final VoidCallback onTap;
  final double layoutSize;

  @override
  Widget build(BuildContext context) {
    final buttonSize = layoutSize / 4 - 15;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: buttonSize * 2 + 10,
        maxHeight: buttonSize,
      ),
      child: CupertinoButton(
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(buttonSize),
        color: backgroundColor ?? CupertinoColors.activeOrange,
        minSize: 0,
        onPressed: onTap,
        padding: const EdgeInsets.only(left: 28),
        pressedOpacity: 0.85,
        child: Center(
          child: SizedBox(
            height: buttonSize,
            width: buttonSize * 2 + 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.left,
                textScaleFactor: 1,
                style: TextStyle(
                  color: labelColor ?? CupertinoColors.white,
                  fontSize: buttonSize / 2.5,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
