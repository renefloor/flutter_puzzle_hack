import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:very_good_slide_puzzle/layout/breakpoints.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';

/// Represents the layout size passed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  /// Small layout
  small,

  /// Medium layout
  medium,

  /// Large layout
  large
}

/// Signature for the individual builders (`small`, `medium`, `large`).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    Key? key,
    required this.small,
    required this.medium,
    required this.large,
    this.xLarge,
    this.child,
  }) : super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder? xLarge;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(ResponsiveLayoutSize currentSize)? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        if (screenWidth <= PuzzleWidthBreakpoints.small ||
            screenHeight <= PuzzleHeightBreakpoints.small) {
          return small(context, child?.call(ResponsiveLayoutSize.small));
        }
        if (screenWidth <= PuzzleWidthBreakpoints.medium ||
            screenHeight <= PuzzleHeightBreakpoints.medium) {
          return medium(context, child?.call(ResponsiveLayoutSize.medium));
        }
        if (screenWidth <= PuzzleWidthBreakpoints.large ||
            screenHeight <= PuzzleHeightBreakpoints.large) {
          return large(context, child?.call(ResponsiveLayoutSize.large));
        }

        final builder = xLarge ?? large;
        return builder(context, child?.call(ResponsiveLayoutSize.large));
      },
    );
  }
}
