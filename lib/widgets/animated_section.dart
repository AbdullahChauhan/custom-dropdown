part of '../custom_dropdown.dart';

class _AnimatedSection extends StatefulWidget {
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  final double axisAlignment;
  final CustomDropdownAnimation animation;

  const _AnimatedSection({
    super.key,
    this.expand = false,
    required this.animationDismissed,
    required this.child,
    required this.axisAlignment,
    this.animation = const CustomDropdownAnimation(),
  });

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    runExpand();
  }

  Duration get _forwardDuration =>
      widget.animation.enabled ? widget.animation.duration : Duration.zero;

  Duration get _reverseDuration => widget.animation.enabled
      ? (widget.animation.reverseDuration ?? widget.animation.duration)
      : Duration.zero;

  void prepareAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: _forwardDuration,
      reverseDuration: _reverseDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          // Defer to after the current frame: the listener can fire mid-build/
          // layout, and animationDismissed() hides the overlay (marking the
          // tree dirty), which would trip a SchedulerPhase assertion.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.animationDismissed();
          });
        }
      });

    animation = CurvedAnimation(
      parent: animController,
      curve: widget.animation.curve,
      reverseCurve: widget.animation.reverseCurve,
    );
  }

  void runExpand() {
    if (widget.expand) {
      animController.forward();
    } else {
      animController.reverse();
    }
  }

  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep controller timings in sync if the animation config changes.
    animController.duration = _forwardDuration;
    animController.reverseDuration = _reverseDuration;
    runExpand();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  // Alignment matching the size animation's anchor edge: 1.0 -> bottom edge,
  // -1.0 -> top edge.
  Alignment get _anchor => Alignment(0, widget.axisAlignment);

  Widget _sizeTransition(Widget child) => SizeTransition(
        axisAlignment: widget.axisAlignment,
        sizeFactor: animation,
        child: child,
      );

  Widget _fadeTransition(Widget child) =>
      FadeTransition(opacity: animation, child: child);

  Widget _scaleTransition(Widget child) => ScaleTransition(
        scale: animation,
        alignment: _anchor,
        child: child,
      );

  Widget _slideTransition(Widget child) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -0.1 * widget.axisAlignment),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    if (widget.animation.builder != null) {
      return widget.animation.builder!(
        context,
        animation,
        widget.axisAlignment,
        widget.child,
      );
    }

    return switch (widget.animation.type) {
      DropdownAnimationType.size => _sizeTransition(widget.child),
      DropdownAnimationType.fade => _fadeTransition(widget.child),
      DropdownAnimationType.sizeFade =>
        _fadeTransition(_sizeTransition(widget.child)),
      DropdownAnimationType.scale => _scaleTransition(widget.child),
      DropdownAnimationType.scaleFade =>
        _fadeTransition(_scaleTransition(widget.child)),
      DropdownAnimationType.slide =>
        _fadeTransition(_slideTransition(widget.child)),
    };
  }
}
