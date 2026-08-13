import 'package:flutter/material.dart';
import 'app_page_transitions.dart';

/// Animates tab changes with the same slide transition used for pushed routes,
/// while keeping every tab mounted to preserve screen state.
class TabPageTransition extends StatefulWidget {
  const TabPageTransition({
    super.key,
    required this.currentIndex,
    required this.forward,
    required this.children,
  });

  final int currentIndex;
  final bool forward;
  final List<Widget> children;

  @override
  State<TabPageTransition> createState() => _TabPageTransitionState();
}

class _TabPageTransitionState extends State<TabPageTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late int _fromIndex;
  late int _toIndex;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.currentIndex;
    _toIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: AppPageTransitions.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppPageTransitions.curve,
      reverseCurve: AppPageTransitions.reverseCurve,
    );
  }

  @override
  void didUpdateWidget(TabPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex == oldWidget.currentIndex) {
      return;
    }

    setState(() {
      _fromIndex = oldWidget.currentIndex;
      _toIndex = widget.currentIndex;
      _isAnimating = true;
    });
    
    _controller.forward(from: 0).whenComplete(() {
      if (mounted) {
        setState(() => _isAnimating = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _incomingOffset(double progress) {
    final start = widget.forward ? 1.0 : -1.0;
    return start * (1.0 - progress);
  }

  double _outgoingOffset(double progress) {
    final end =
        widget.forward
            ? -AppPageTransitions.parallaxFactor
            : AppPageTransitions.parallaxFactor;
    return end * progress;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimating) {
      return IndexedStack(
        index: widget.currentIndex,
        children: widget.children,
      );
    }

    final width = MediaQuery.sizeOf(context).width;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final progress = _animation.value;

        return ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Transform.translate(
                offset: Offset(width * _outgoingOffset(progress), 0),
                child: widget.children[_fromIndex],
              ),
              Transform.translate(
                offset: Offset(width * _incomingOffset(progress), 0),
                child: widget.children[_toIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}
