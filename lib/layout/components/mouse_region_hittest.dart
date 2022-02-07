// TODO: remove this file when issue is resolved: https://github.com/flutter/flutter/issues/73330
//
// copied from basic.dart #6206-6534
// and proxy_box.dart # 2875-3000
// stripped off comments and debug-code
// replaced RenderProxyBox with RenderProxyBoxWithHitTestBehavior, see proxy_box.dart→RenderPointerListener (used e.g. by Draggable)

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MouseRegionHittest extends StatefulWidget {
  const MouseRegionHittest({
    Key? key,
    this.onEnter,
    this.onExit,
    this.onHover,
    this.cursor = MouseCursor.defer,
    this.opaque = true,
    this.child,
  })  : assert(cursor != null),
        assert(opaque != null),
        super(key: key);
  final PointerEnterEventListener? onEnter;
  final PointerHoverEventListener? onHover;
  final PointerExitEventListener? onExit;
  final MouseCursor cursor;
  final bool opaque;
  final Widget? child;
  @override
  _MouseRegionHittestState createState() => _MouseRegionHittestState();
}

class _MouseRegionHittestState extends State<MouseRegionHittest> {
  void handleExit(PointerExitEvent event) {
    if (widget.onExit != null && mounted) widget.onExit!(event);
  }

  PointerExitEventListener? getHandleExit() {
    return widget.onExit == null ? null : handleExit;
  }

  @override
  Widget build(BuildContext context) {
    return _RawMouseRegionHittest(this);
  }
}

class _RawMouseRegionHittest extends SingleChildRenderObjectWidget {
  _RawMouseRegionHittest(this.owner) : super(child: owner.widget.child);
  final _MouseRegionHittestState owner;
  @override
  _RenderMouseRegionHittest createRenderObject(BuildContext context) {
    final MouseRegionHittest widget = owner.widget;
    return _RenderMouseRegionHittest(
      onEnter: widget.onEnter,
      onHover: widget.onHover,
      onExit: owner.getHandleExit(),
      cursor: widget.cursor,
      opaque: widget.opaque,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMouseRegionHittest renderObject) {
    final MouseRegionHittest widget = owner.widget;
    renderObject
      ..onEnter = widget.onEnter
      ..onHover = widget.onHover
      ..onExit = owner.getHandleExit()
      ..cursor = widget.cursor
      ..opaque = widget.opaque;
  }
}

class _RenderMouseRegionHittest extends RenderProxyBoxWithHitTestBehavior
    implements MouseTrackerAnnotation {
  _RenderMouseRegionHittest({
    this.onEnter,
    this.onHover,
    this.onExit,
    MouseCursor cursor = MouseCursor.defer,
    bool validForMouseTracker = true,
    bool opaque = true,
    RenderBox? child,
  })  : assert(opaque != null),
        assert(cursor != null),
        _cursor = cursor,
        _validForMouseTracker = validForMouseTracker,
        _opaque = opaque,
        super(child: child);
  @protected
  // @override
  // bool hitTestSelf(Offset position) => true;
  // @override
  // bool hitTest(BoxHitTestResult result, {Offset position}) {
  //   return super.hitTest(result, position: position) && _opaque;
  // }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (onHover != null && event is PointerHoverEvent) return onHover!(event);
  }

  bool get opaque => _opaque;
  bool _opaque;
  set opaque(bool value) {
    if (_opaque != value) {
      _opaque = value;
      markNeedsPaint();
    }
  }

  @override
  PointerEnterEventListener? onEnter;
  PointerHoverEventListener? onHover;
  @override
  PointerExitEventListener? onExit;
  @override
  MouseCursor get cursor => _cursor;
  MouseCursor _cursor;
  set cursor(MouseCursor value) {
    if (_cursor != value) {
      _cursor = value;
      markNeedsPaint();
    }
  }

  @override
  bool get validForMouseTracker => _validForMouseTracker;
  bool _validForMouseTracker;
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }

  @override
  Size computeSizeForNoChild(BoxConstraints constraints) {
    return constraints.biggest;
  }
}
