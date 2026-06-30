part of '../custom_dropdown.dart';

class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, VoidCallback hide) overlay;
  final Widget Function(VoidCallback show) child;
  final OverlayPortalController? overlayPortalController;
  final Function(bool)? visibility;
  final bool initiallyOpen;

  const _OverlayBuilder({
    required this.overlay,
    required this.child,
    this.overlayPortalController,
    this.visibility,
    this.initiallyOpen = false,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  late OverlayPortalController overlayController;

  @override
  void initState() {
    super.initState();
    overlayController =
        widget.overlayPortalController ?? OverlayPortalController();
    if (widget.initiallyOpen) {
      // Show after the first frame so the OverlayPortal is mounted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !overlayController.isShowing) showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant _OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep in sync if the caller passes a different controller instance (e.g.
    // one recreated on rebuild). Without this the OverlayPortal stays bound to
    // the original controller and the caller's show()/hide() calls do nothing.
    if (widget.overlayPortalController != oldWidget.overlayPortalController) {
      overlayController =
          widget.overlayPortalController ?? OverlayPortalController();
    }
  }

  void showOverlay() {
    overlayController.show();

    if (widget.visibility != null) {
      widget.visibility!(true);
    }
  }

  void hideOverlay() {
    overlayController.hide();

    if (widget.visibility != null) {
      widget.visibility!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        return widget.overlay(size, hideOverlay);
      },
      child: widget.child(showOverlay),
    );
  }
}
