import 'package:flutter/material.dart';

class WidgetButtonPress extends StatefulWidget {
  const WidgetButtonPress({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    this.lowerBound = 0.0,
    this.upperBound = 0.05,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final double lowerBound;
  final double upperBound;

  @override
  State<WidgetButtonPress> createState() => _WidgetButtonPressState();
}

class _WidgetButtonPressState extends State<WidgetButtonPress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;

  void _onTapDown(PointerDownEvent details) {
    _controller.forward();
  }

  void _onTapUp(PointerUpEvent details) {
    _controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: widget.lowerBound,
      upperBound: widget.upperBound,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return Listener(
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
