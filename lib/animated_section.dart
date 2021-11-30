part of 'custom_dropdown.dart';

class AnimatedSection extends StatefulWidget {
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  const AnimatedSection({
    Key? key,
    this.expand = false,
    required this.animationDismissed,
    required this.child,
  }) : super(key: key);

  @override
  _AnimatedSectionState createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    runExpand();
  }

  void prepareAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.animationDismissed();
        }
      });

    animation = CurvedAnimation(
      parent: animController,
      curve: Curves.linearToEaseOut,
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
  void didUpdateWidget(AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    runExpand();
  }

  @override
  void dispose() {
    super.dispose();
    animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.child,
      ),
    );
  }
}
