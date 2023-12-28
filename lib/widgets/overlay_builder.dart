part of '../custom_dropdown.dart';

class _OverlayBuilder extends StatefulWidget {
  final Widget Function(Size, VoidCallback hide) overlay;
  final Widget Function(VoidCallback show) child;

  const _OverlayBuilder({
    super.key,
    required this.overlay,
    required this.child,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  final overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayController,
      overlayChildBuilder: (_) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        return widget.overlay(size, overlayController.hide);
      },
      child: widget.child(overlayController.show),
    );
  }
}
