import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TextFieldCalculator extends StatelessWidget {
  const TextFieldCalculator({super.key, required this.controller});

  final TextEditingController controller;

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! <= 0) return;
    if (controller.text.isEmpty) return;
    controller.text = controller.text.substring(0, controller.text.length - 1);
    if (controller.text.isEmpty) {
      controller.text = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDrag,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        absorbing: true,
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, controllerListener, __) => CupertinoTextField(
            controller: controller,
            textAlign: TextAlign.right,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.black,
                width: 0,
              ),
            ),
            maxLength: 9,
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: controllerListener.text.length > 8 ? 60 : 80,
              fontWeight: FontWeight.w300,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      ),
    );
  }
}
