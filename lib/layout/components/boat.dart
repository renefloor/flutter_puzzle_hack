import 'package:flutter/material.dart';

import '../responsive_layout_builder.dart';

class Boat extends StatelessWidget {
  const Boat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const _SizedBoat(size: 1, offSet: 1.3),
      medium: (_, __) => const _SizedBoat(size: 1.2, offSet: 1.4),
      large: (_, __) => const _SizedBoat(
        size: 2,
        offSet: 2,
      ),
      xLarge: (_, __) => const _SizedBoat(
        size: 2,
        offSet: 1.4,
      ),
    );
  }
}

class _SizedBoat extends StatelessWidget {
  const _SizedBoat({
    required this.size,
    required this.offSet,
    Key? key,
  }) : super(key: key);
  final double size;
  final double offSet;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(offSet, offSet * 0.8),
      child: _AnimatedBoat(width: size * 150),
    );
  }
}

class _AnimatedBoat extends StatefulWidget {
  const _AnimatedBoat({required this.width, Key? key}) : super(key: key);
  final double width;

  @override
  __AnimatedBoatState createState() => __AnimatedBoatState();
}

class __AnimatedBoatState extends State<_AnimatedBoat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waterAnimation;
  late Animation<double> _boatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _controller.reset();
          });
        }
      });

    _waterAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _boatAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.width,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0 - _waterAnimation.value * (widget.width * 0.1),
            left: 0 - _waterAnimation.value * (widget.width * 0.2),
            right: 0 - _waterAnimation.value * (widget.width * 0.2),
            child: Opacity(
              opacity: 1 - _waterAnimation.value,
              child: Image.asset(
                'assets/images/boat_water_lines.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: widget.width * 0.05),
            child: Transform.rotate(
              angle: 0 - (_boatAnimation.value - _controller.value) * 0.1,
              child: GestureDetector(
                onTap: _startBoatAnimation,
                child: Image.asset(
                  'assets/images/boat.png',
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startBoatAnimation() {
    _controller
      ..reset()
      ..forward();
  }
}
