part of '../custom_dropdown.dart';

/// Built-in open/close transitions for the [CustomDropdown] overlay.
///
/// All transitions are anchored to the dropdown field edge (they grow/scale/
/// slide from the side the overlay opens towards).
enum DropdownAnimationType {
  /// Reveal by growing the overlay height.
  size,

  /// Fade the overlay in/out.
  fade,

  /// Grow the height while fading (the historical default).
  sizeFade,

  /// Scale the overlay up from the field edge.
  scale,

  /// Scale up while fading.
  scaleFade,

  /// Slide in from the field edge while fading.
  slide,
}

/// Signature for a fully custom overlay transition.
///
/// [animation] is the curved 0→1 animation (forward = opening), [axisAlignment]
/// is `1.0` when the overlay opens below the field and `-1.0` when it opens
/// above, and [child] is the overlay content to wrap.
typedef DropdownTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  double axisAlignment,
  Widget child,
);

/// Controls how the [CustomDropdown] overlay animates open and closed.
class CustomDropdownAnimation {
  /// The built-in transition to use. Ignored when [builder] is provided.
  final DropdownAnimationType type;

  /// Duration of the opening animation.
  final Duration duration;

  /// Duration of the closing animation. Defaults to [duration] when null.
  final Duration? reverseDuration;

  /// Curve used while opening.
  final Curve curve;

  /// Curve used while closing.
  final Curve reverseCurve;

  /// When `false` the overlay opens/closes instantly (no animation).
  final bool enabled;

  /// Optional fully custom transition. When provided it takes precedence over
  /// [type], receiving the curved animation, the open direction and the child.
  final DropdownTransitionBuilder? builder;

  /// When `true`, list items fade + slide in with a cascading stagger each time
  /// the overlay opens. Ignored when [enabled] is `false`.
  final bool staggerItems;

  /// Delay added per list item for the staggered entrance (capped for long
  /// lists). Only used when [staggerItems] is `true`.
  final Duration itemStagger;

  /// Duration of each list item's entrance animation. Only used when
  /// [staggerItems] is `true`.
  final Duration itemDuration;

  const CustomDropdownAnimation({
    this.type = DropdownAnimationType.sizeFade,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.enabled = true,
    this.builder,
    this.staggerItems = false,
    this.itemStagger = const Duration(milliseconds: 40),
    this.itemDuration = const Duration(milliseconds: 250),
  });

  /// No animation — the overlay appears/disappears instantly.
  static const CustomDropdownAnimation none =
      CustomDropdownAnimation(enabled: false);
}
