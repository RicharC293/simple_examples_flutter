import 'package:flutter/material.dart';

import 'animated_check.dart';
import 'package.dart';
import 'truck.dart';

class ContentButton extends StatefulWidget {
  const ContentButton({super.key});

  @override
  State<ContentButton> createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton>
    with TickerProviderStateMixin {
  //Booleans to controller status
  bool isDoorsOpen = false;
  bool isPackageInTruck = false;
  bool isCompleted = false;

  final double buttonWidth = 200;

  double opacityText = 1;
  double linesOpacity = 1;

  late Animation<double> animationDoors;
  late AnimationController controllerDoors;

  late Animation<double> animationTruck;
  late AnimationController controllerTruck;

  late Animation<double> animationPackage;
  late AnimationController controllerPackage;

  late Animation<double> animationLines;
  late AnimationController controllerLines;

  late Animation<double> animationCheck;
  late AnimationController controllerCheck;

  final Tween<double> _rotationTween = Tween(begin: 60, end: 220);

  final Tween<double> _positionTruckTween = Tween(begin: 200, end: -30);

  final Tween<double> _positionPackageTween = Tween(begin: -20, end: 50);

  final Tween<double> _linesTween = Tween(begin: 200, end: -800);

  final Tween<double> _checkTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    controllerDoors = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_doorsListener);

    controllerTruck = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(_truckListener);

    controllerPackage = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controllerLines = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    controllerCheck = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationDoors = _rotationTween.animate(controllerDoors);

    animationTruck = _positionTruckTween.animate(controllerTruck);

    animationPackage = _positionPackageTween.animate(controllerPackage);

    animationLines = _linesTween.animate(controllerLines);

    animationCheck = _checkTween.animate(controllerCheck);

    super.initState();
  }

  void _truckListener() {
    if (animationTruck.value.ceil() <= 201 &&
        animationTruck.value.ceil() >= 199 &&
        animationTruck.status == AnimationStatus.forward) {
      controllerDoors.forward();
      isDoorsOpen = true;
    }

    if (animationTruck.value.ceil() <= 1 &&
        animationTruck.value.ceil() >= -1 &&
        animationTruck.status == AnimationStatus.forward &&
        isDoorsOpen) {
      controllerTruck.stop(canceled: false);
      controllerDoors.reverse();
      isDoorsOpen = false;
      //Remove package for UI to prevent control motion of package
      setState(() {
        isPackageInTruck = true;
      });
    }
    if (isPackageInTruck &&
        animationTruck.value.ceil() <= 101 &&
        animationTruck.value.ceil() >= 99 &&
        !isCompleted) {
      controllerTruck.stop();
      controllerTruck.forward();
      controllerLines.forward();
      isCompleted = true;
    }

    if (isPackageInTruck &&
        animationTruck.status == AnimationStatus.completed) {
      Future.delayed(const Duration(seconds: 2), () {
        controllerTruck.reverse();
      });
    }

    if (isCompleted && controllerTruck.status == AnimationStatus.dismissed) {
      controllerCheck.forward();
      setState(() {
        linesOpacity = 0;
        opacityText = 1;
      });
    }
  }

  _doorsListener() {
    if (animationDoors.status == AnimationStatus.dismissed &&
        isPackageInTruck) {
      controllerTruck.reverse();
    }
  }

  void _reset() {
    controllerTruck.reset();
    controllerPackage.reset();
    controllerLines.reset();
    controllerCheck.reset();
    controllerDoors.reset();
    setState(() {
      isDoorsOpen = false;
      isPackageInTruck = false;
      isCompleted = false;
      opacityText = 1;
      linesOpacity = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerDoors.dispose();
    controllerTruck.dispose();
    controllerPackage.dispose();
    controllerLines.dispose();
    controllerCheck.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (isCompleted) {
          _reset();
          return;
        }
        controllerTruck.forward();
        controllerPackage.forward();
        setState(() {
          opacityText = 0;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.zero,
        ),
      ),
      child: SizedBox(
        width: buttonWidth,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
                animation: animationLines,
                builder: (context, __) {
                  return Positioned(
                    left: animationLines.value,
                    child: AnimatedOpacity(
                      opacity: linesOpacity,
                      duration: const Duration(milliseconds: 100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            200,
                            (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  width: 7,
                                  height: 2,
                                )),
                      ),
                    ),
                  );
                }),
            if (!isPackageInTruck)
              AnimatedBuilder(
                  animation: animationPackage,
                  builder: (context, _) {
                    return Positioned(
                      left: animationPackage.value,
                      child: const Package(),
                    );
                  }),
            AnimatedBuilder(
                animation: animationTruck,
                builder: (context, _) {
                  return AnimatedBuilder(
                    animation: animationDoors,
                    builder: (context, child) => Positioned(
                      left: animationTruck.value,
                      child: TruckWidget(
                        doorsDegree: animationDoors.value,
                        opacity: 1,
                      ),
                    ),
                  );
                }),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: opacityText,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isCompleted ? "Order Placed" : "Complete Order",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  if (isCompleted)
                    AnimatedCheck(
                      progress: animationCheck,
                      size: 25,
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
