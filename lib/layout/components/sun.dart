import 'package:flutter/cupertino.dart';
import 'package:island_slide_puzzle/colors/colors.dart';
import 'package:island_slide_puzzle/layout/layout.dart';
import 'dart:math' as math;

class SunAndMoon extends StatelessWidget {
  const SunAndMoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: ResponsiveLayoutBuilder(
          defaultBuilder: (context, child) => Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              height: 40,
              width: 40,
              child: child,
            ),
          ),
          smallWide: (context, child) => Padding(
            padding: const EdgeInsets.only(top: 16, right: 32),
            child: SizedBox(
              height: 20,
              width: 20,
              child: child,
            ),
          ),
          large: (context, child) => Padding(
            padding: const EdgeInsets.only(top: 32, right: 64),
            child: SizedBox(
              height: 40,
              width: 40,
              child: child,
            ),
          ),
          child: (_) =>
              brightness == Brightness.light ? const Sun() : const Moon(),
        ),
      ),
    );
  }
}


class SunAndMoonReflection extends StatelessWidget {
  const SunAndMoonReflection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Align(
      alignment: Alignment.topRight,
      child: ResponsiveLayoutBuilder(
        defaultBuilder: (context, child) => Padding(
          padding: const EdgeInsets.all(32) + const EdgeInsets.only(top: 200),
          child: SizedBox(
            height: 40,
            width: 40,
            child: child,
          ),
        ),
        smallWide: (context, child) => Padding(
          padding: const EdgeInsets.only(top: 16, right: 32) + const EdgeInsets.only(top: 100),
          child: SizedBox(
            height: 20,
            width: 20,
            child: child,
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.only(top: 32, right: 64) + const EdgeInsets.only(top: 200),
          child: SizedBox(
            height: 40,
            width: 40,
            child: child,
          ),
        ),
        child: (_) =>
        brightness == Brightness.light ?
        Image.asset('assets/images/sun_ellipse.png') :
        Image.asset('assets/images/sun_ellipse.png'),
      ),
    );
  }
}


class Sun extends StatelessWidget {
  const Sun({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: PuzzleColors.sun,
      ),
    );
  }
}

class Moon extends StatefulWidget {
  const Moon({Key? key}) : super(key: key);

  @override
  _MoonState createState() => _MoonState();
}

class _MoonState extends State<Moon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fraction = _controller.value;
    final moonShape = CustomPaint(
      painter: MoonShape(fraction),
    );
    var angle = -math.pi / 5;
    if (_controller.status == AnimationStatus.forward) {
      angle += math.pi;
    }
    return Transform.rotate(angle: angle, child: moonShape);

    if (_controller.status == AnimationStatus.reverse) {
      return moonShape;
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: moonShape,
      );
    }
  }
}

class MoonShape extends CustomPainter {
  final painter = Paint();

  MoonShape(this.fraction) {
    painter.color = PuzzleColors.moon;
  }

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..arcToPoint(
        Offset(size.width, size.height / 2),
        radius: Radius.circular(size.width / 2),
      )
      ..arcToPoint(
        Offset(size.width / 2, size.height),
        radius: Radius.circular(size.width / 2),
      )
      ..arcToPoint(
        Offset(size.width * fraction, size.height / 2),
        clockwise: fraction < 1 / 2,
        radius: Radius.elliptical(
          size.height / 2 * (1 - fraction * 2),
          size.width / 2,
        ),
      )
      ..arcToPoint(
        Offset(size.width / 2, 0),
        clockwise: fraction < 1 / 2,
        radius: Radius.elliptical(
          size.height / 2 * (1 - fraction * 2),
          size.width / 2,
        ),
      );

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
