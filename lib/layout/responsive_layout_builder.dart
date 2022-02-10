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
  ResponsiveLayoutBuilder({
    Key? key,
    ResponsiveLayoutWidgetBuilder? defaultBuilder,
    ResponsiveLayoutWidgetBuilder? small,
    ResponsiveLayoutWidgetBuilder? medium,
    ResponsiveLayoutWidgetBuilder? large,
    ResponsiveLayoutWidgetBuilder? smallWide,
    ResponsiveLayoutWidgetBuilder? mediumWide,
    ResponsiveLayoutWidgetBuilder? xLarge,
    this.child,
  })  : assert(
          small != null || defaultBuilder != null,
          'supply at least either small or defaultBuilder',
        ),
        small = small ?? defaultBuilder!,
        smallWide = smallWide ?? small ?? defaultBuilder!,
        assert(
          medium != null || defaultBuilder != null,
          'supply at least either medium or defaultBuilder',
        ),
        medium = medium ?? defaultBuilder!,
        mediumWide = mediumWide ?? medium ?? defaultBuilder!,
        assert(
          large != null || defaultBuilder != null,
          'supply at least either large or defaultBuilder',
        ),
        large = large ?? defaultBuilder!,
        xLarge = xLarge ?? large ?? defaultBuilder!,
        super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for small in height, but wide layout.
  final ResponsiveLayoutWidgetBuilder smallWide;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder medium;

  /// [ResponsiveLayoutWidgetBuilder] for medium in height, but wide layout.
  final ResponsiveLayoutWidgetBuilder mediumWide;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// [ResponsiveLayoutWidgetBuilder] for xlarge layout.
  final ResponsiveLayoutWidgetBuilder xLarge;

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

        if (screenWidth <= PuzzleWidthBreakpoints.small) {
          return small(context, child?.call(ResponsiveLayoutSize.small));
        }
        if (screenHeight <= PuzzleHeightBreakpoints.small) {
          if (screenWidth <= PuzzleWidthBreakpoints.smallWide) {
            return small(context, child?.call(ResponsiveLayoutSize.small));
          }
          return smallWide(
            context,
            child?.call(ResponsiveLayoutSize.small),
          );
        }

        if (screenWidth <= PuzzleWidthBreakpoints.medium) {
          return medium(context, child?.call(ResponsiveLayoutSize.medium));
        }
        if (screenHeight <= PuzzleHeightBreakpoints.medium) {
          return mediumWide(
            context,
            child?.call(ResponsiveLayoutSize.medium),
          );
        }

        if (screenWidth <= PuzzleWidthBreakpoints.large ||
            screenHeight <= PuzzleHeightBreakpoints.large) {
          return large(context, child?.call(ResponsiveLayoutSize.large));
        }
        return xLarge(context, child?.call(ResponsiveLayoutSize.large));
      },
    );
  }
}
