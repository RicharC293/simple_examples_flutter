import 'package:flutter/material.dart';
import 'package:simple_examples/examples/animated_switch/widgets/pixel_container.dart';

class AnimatedSwitch extends StatefulWidget {
  const AnimatedSwitch({
    super.key,
    this.switchColor = Colors.greenAccent,
    this.duration = const Duration(milliseconds: 200),
    this.width = 300,
    this.height = 100,
  });

  final Color switchColor;
  final Duration duration;
  final double width;
  final double height;

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> {
  bool _isSwitched = false;

  void _onTap() {
    setState(() {
      _isSwitched = !_isSwitched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: widget.switchColor),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchBody(
                  duration: widget.duration,
                  color: widget.switchColor,
                  width: widget.width - 100,
                  onTap: _onTap,
                  isSwitched: !_isSwitched,
                ),
              ),
              Expanded(
                child: SwitchBody(
                  duration: widget.duration,
                  color: widget.switchColor,
                  width: widget.width - 100,
                  onTap: _onTap,
                  isSwitched: _isSwitched,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PixelContainer(
              duration: widget.duration,
              height: widget.height - 20,
              color: widget.switchColor,
              width: widget.width - 20,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchBody extends StatelessWidget {
  const SwitchBody({
    super.key,
    required this.color,
    required this.width,
    required this.onTap,
    required this.isSwitched,
    required this.duration,
  });

  final Color color;
  final double width;
  final VoidCallback onTap;
  final bool isSwitched;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: duration.inMilliseconds + 100),
      opacity: isSwitched ? 1 : 0,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: double.infinity,
        width: width,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 40,
              offset: isSwitched ? const Offset(0, 1) : const Offset(1, 0),
            ),
          ],
        ),
      ),
    );
  }
}
