
import 'dart:math' as math;

import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/devotion.dart';
import 'package:bible/providers/devotional_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionalCard extends StatefulWidget {
  const DevotionalCard({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  State<DevotionalCard> createState() => _DevotionalCardState();
}

class _DevotionalCardState extends State<DevotionalCard>
    with SingleTickerProviderStateMixin {
  static const double _flipDistance = 200;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  double _drag = 0;
  double _startValue = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _controller.stop();
    _startValue = _controller.value;
    _drag = 0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _drag += details.delta.dx;
    final direction = _startValue >= 0.5 ? -1.0 : 1.0;
    _controller.value =
        (_startValue + (_drag.abs() / _flipDistance) * direction).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    double target;
    if (velocity.abs() > 300) {
      target = _startValue >= 0.5 ? 0.0 : 1.0;
    } else {
      target = _controller.value >= 0.5 ? 1.0 : 0.0;
    }
    _controller.animateTo(target, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Consumer<DevotionalProvider>(
      builder: (context, state, __) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final value = _controller.value;
              final showFront = value < 0.5;
              final dragSign = _drag < 0 ? -1.0 : 1.0;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value * math.pi * dragSign),
                child: Card(
                  child: Stack(
                    children: [
                      _buildFace(
                        theme: theme,
                        devotion: state.devotion,
                        isFront: true,
                        show: showFront,
                      ),
                      _buildFace(
                        theme: theme,
                        devotion: state.devotion,
                        isFront: false,
                        show: !showFront,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFace({
    required ThemeData theme,
    required Devotion? devotion,
    required bool isFront,
    required bool show,
  }) {
    final Widget face = Opacity(
      opacity: show ? 1 : 0,
      child: IgnorePointer(
        ignoring: !show,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: isFront ? ColorManager.primary : ColorManager.primary1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFront ? "TODAY'S MESSAGE" : "PRAYER",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ColorManager.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isFront
                        ? "${devotion?.devotional.title}"
                        : "${devotion?.verse.ref}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isFront
                        ? "${devotion?.devotional.body}"
                        : "${devotion?.devotional.prayer}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ColorManager.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _SwipeHint(label: isFront ? "Swipe for prayer" : "Swipe for message"),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (isFront) return face;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: face,
    );
  }
}

class _SwipeHint extends StatelessWidget {
  const _SwipeHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.swipe, size: 16, color: ColorManager.grey),
        SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: ColorManager.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
