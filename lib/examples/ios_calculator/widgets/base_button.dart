import 'package:flutter/cupertino.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.label,
    this.backgroundColor,
    required this.onTap,
    this.labelColor,
    this.isActive = false,
    required this.layoutSize,
  });

  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  final VoidCallback onTap;
  final bool isActive;
  final double layoutSize;

  @override
  Widget build(BuildContext context) {
    final buttonSize = layoutSize / 4 - 15;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: buttonSize,
        maxHeight: buttonSize,
      ),
      child: CupertinoButton(
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(buttonSize),
        color: isActive
            ? CupertinoColors.white
            : (backgroundColor ?? CupertinoColors.activeOrange),
        minSize: 0,
        onPressed: onTap,
        padding: EdgeInsets.zero,
        pressedOpacity: 0.85,
        child: Center(
          child: SizedBox(
            height: buttonSize,
            width: buttonSize,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: TextStyle(
                  color: isActive
                      ? CupertinoColors.activeOrange
                      : (labelColor ?? CupertinoColors.white),
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
