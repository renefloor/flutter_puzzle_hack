import 'package:flutter/cupertino.dart';
import 'package:island_slide_puzzle/colors/colors.dart';
import 'package:island_slide_puzzle/layout/layout.dart';
import 'dart:math' as math;

class SunAndMoon extends StatelessWidget {
  const SunAndMoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: ResponsiveLayoutBuilder(
          defaultBuilder: (context, child) => const _SunAndMoon(
            paddingTop: 32,
            paddingRight: 32,
            spaceBetween: 150,
            size: 40,
          ),
          smallWide: (context, child) => const _SunAndMoon(
            paddingTop: 16,
            paddingRight: 32,
            spaceBetween: 75,
            size: 20,
          ),
          large: (context, child) => const _SunAndMoon(
            paddingTop: 32,
            paddingRight: 64,
            spaceBetween: 150,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _SunAndMoon extends StatefulWidget {
  const _SunAndMoon({
    required this.paddingTop,
    required this.paddingRight,
    required this.spaceBetween,
    required this.size,
    Key? key,
  }) : super(key: key);
  final double paddingTop;
  final double paddingRight;
  final double spaceBetween;
  final double size;

  @override
  State<_SunAndMoon> createState() => _SunAndMoonState();
}

class _SunAndMoonState extends State<_SunAndMoon>
    with SingleTickerProviderStateMixin {
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
    List<Widget> widgets;
    if (MediaQuery.of(context).platformBrightness == Brightness.light) {
      widgets = [
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: const Sun(),
        ),
        SizedBox(height: widget.spaceBetween),
        Opacity(
          opacity: 0.9,
          child: Image.asset('assets/images/sun_ellipse.png'),
        ),
      ];
    } else {
      widgets = [
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: Moon(
            moonPhase: _controller.value,
            forward: _controller.status == AnimationStatus.forward,
          ),
        ),
        SizedBox(height: widget.spaceBetween),
        Opacity(
          opacity: 1 - _controller.value,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              PuzzleColors.moon,
              BlendMode.srcATop,
            ),
            child: Image.asset('assets/images/sun_ellipse.png'),
          ),
        ),
      ];
    }
    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        right: widget.paddingRight,
      ),
      child: SizedBox(
        width: widget.size,
        child: Column(
          children: widgets,
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
          padding: const EdgeInsets.only(top: 16, right: 32) +
              const EdgeInsets.only(top: 100),
          child: SizedBox(
            height: 20,
            width: 20,
            child: child,
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.only(top: 32, right: 64) +
              const EdgeInsets.only(top: 200),
          child: SizedBox(
            height: 40,
            width: 40,
            child: child,
          ),
        ),
        child: (_) => brightness == Brightness.light
            ? Image.asset('assets/images/sun_ellipse.png')
            : ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  PuzzleColors.moon,
                  BlendMode.srcATop,
                ),
                child: Image.asset('assets/images/sun_ellipse.png'),
              ),
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

class Moon extends StatelessWidget {
  const Moon({
    required this.moonPhase,
    required this.forward,
    Key? key,
  }) : super(key: key);

  final double moonPhase;
  final bool forward;

  @override
  Widget build(BuildContext context) {
    final moonShape = CustomPaint(
      painter: MoonShape(moonPhase),
    );
    var angle = -math.pi / 5;
    if (forward) {
      angle += math.pi;
    }
    return Transform.rotate(angle: angle, child: moonShape);
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
