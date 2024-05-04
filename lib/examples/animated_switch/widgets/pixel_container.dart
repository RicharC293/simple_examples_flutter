import 'package:flutter/material.dart';

class PixelContainer extends StatefulWidget {
  const PixelContainer({
    super.key,
    required this.height,
    required this.color,
    required this.width,
    this.onTap,
    required this.duration,
  });
  final double height;
  final Color color;
  final double width;
  final VoidCallback? onTap;
  final Duration duration;

  @override
  State<PixelContainer> createState() => _PixelContainerState();
}

class _PixelContainerState extends State<PixelContainer> {
  final double _pixelSize = 2.0;

  late Map<int, bool> _switchStatus;

  late int _totalLines;

  @override
  void initState() {
    _initSwitchStatus();
    super.initState();
  }

  void _initSwitchStatus() {
    _totalLines = ((widget.height / _pixelSize).truncate()) - 1;
    _switchStatus = {
      for (var index
          in List.generate(widget.height ~/ _pixelSize, (index) => index))
        index: false
    };
  }

  Future<void> _startSwitch() async {
    widget.onTap?.call();
    final randomIndex = _switchStatus.keys.toList()..shuffle();
    for (var index in randomIndex) {
      await Future.delayed(
        Duration(milliseconds: widget.duration.inMilliseconds ~/ _totalLines),
        () {
          setState(() {
            _switchStatus[index] = !_switchStatus[index]!;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startSwitch();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _totalLines,
            (index) => LineSwitchBase(
              width: widget.width / 2,
              height: _pixelSize,
              color: widget.color,
              isSwitched: _switchStatus[index] ?? false,
              duration: widget.duration,
            ),
          ),
        ),
      ),
    );
  }
}

class LineSwitchBase extends StatefulWidget {
  const LineSwitchBase({
    super.key,
    required this.isSwitched,
    required this.color,
    required this.height,
    required this.width,
    required this.duration,
  });
  final bool isSwitched;
  final Color color;
  final double height;
  final double width;
  final Duration duration;

  @override
  State<LineSwitchBase> createState() => _LineSwitchBaseState();
}

class _LineSwitchBaseState extends State<LineSwitchBase> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            left: widget.isSwitched ? widget.width + 10 : 0,
            width: widget.width - 10,
            duration: widget.duration,
            child: Container(
              margin: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0.5, 0),
                  ),
                ],
              ),
              height: widget.height,
              width: widget.width,
            ),
          )
        ],
      ),
    );
  }
}
