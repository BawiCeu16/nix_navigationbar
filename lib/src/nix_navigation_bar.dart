import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nix_navigation_bar_item.dart';

/// A custom, premium, and beautiful floating pill-style navigation bar widget.
///
/// Features a sliding background pill indicator, drag-to-select hand gesture,
/// responsive width constraints for tablets/desktop, and selection haptics.
class NixNavigationBar extends StatefulWidget {
  /// The items to display in the navigation bar.
  final List<NixNavigationBarItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when an item is selected, passing the index of the selected item.
  final ValueChanged<int> onTap;

  /// The background color of the navigation bar container.
  /// If null, defaults to [ColorScheme.surface] with opacity.
  final Color? backgroundColor;

  /// The background color of the sliding selection indicator.
  /// If null, defaults to [ColorScheme.primary] with opacity.
  final Color? indicatorColor;

  /// The color of the icon and text of the selected item.
  /// If null, defaults to [ColorScheme.primary].
  final Color? selectedItemColor;

  /// The color of the icon and text of the unselected items.
  /// If null, defaults to [ColorScheme.onSurface] with opacity.
  final Color? unselectedItemColor;

  /// The external margin surrounding the floating navigation bar.
  /// Defaults to a floating bottom margin: `EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0)`.
  final EdgeInsetsGeometry margin;

  /// The internal padding inside the navigation bar around the items.
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)`.
  final EdgeInsetsGeometry padding;

  /// Height of the navigation bar. If null, automatically scales based on whether labels are present.
  final double? height;

  /// The maximum width of the navigation bar. Prevents it from stretching too wide on large screens.
  /// Defaults to `600.0`. Set to null or [double.infinity] for full screen width.
  final double? maxWidth;

  /// The alignment of the navigation bar within its layout.
  /// Defaults to [Alignment.bottomCenter].
  final AlignmentGeometry alignment;

  /// The border radius of the outer navigation bar pill.
  /// If null, defaults to `BorderRadius.circular(40.0)`.
  final BorderRadiusGeometry? borderRadius;

  /// The border radius of the sliding indicator bubble.
  /// If null, defaults to `BorderRadius.circular(360.0)`.
  final BorderRadiusGeometry? indicatorBorderRadius;

  /// The internal padding/inset for the sliding indicator bubble.
  /// Defaults to `EdgeInsets.all(4.0)`.
  final EdgeInsetsGeometry indicatorPadding;

  /// A list of shadows cast by the floating navigation bar.
  /// If null and [enableShadow] is true, uses a default Material 3 soft shadow.
  final List<BoxShadow>? shadows;

  /// Whether to display shadows under the navigation bar.
  /// Defaults to `false`.
  final bool enableShadow;

  /// The animation duration for the indicator sliding transition.
  /// Defaults to `Duration(milliseconds: 300)`.
  final Duration duration;

  /// The animation curve for the indicator sliding transition.
  /// Defaults to [Curves.easeInOut].
  final Curve curve;

  /// Whether to trigger selection haptic feedback when the selection changes.
  /// Defaults to `true`.
  final bool enableHapticFeedback;

  /// An optional border to paint around the outer navigation bar.
  /// Defaults to null (no border at all).
  final Border? border;

  /// The blur factor representing the frosted glass blur intensity from 0.0 (0%) to 1.0 (100%).
  /// Defaults to `0.3` (30%).
  final double blurFactor;

  /// The dimming factor representing the background opacity from 0.0 (0%) to 1.0 (100%).
  /// Defaults to `0.15` (15%).
  final double dimFactor;

  /// Whether to enable frosted glass background blur.
  /// Defaults to `false`.
  final bool enableBlur;

  const NixNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
    this.height,
    this.maxWidth = 600.0,
    this.alignment = Alignment.bottomCenter,
    this.borderRadius,
    this.indicatorBorderRadius,
    this.indicatorPadding = EdgeInsets.zero,
    this.shadows,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.enableHapticFeedback = true,
    this.border,
    this.blurFactor = 0.6,
    this.dimFactor = 0.5,
    this.enableBlur = false,
    this.enableShadow = false,
  });

  @override
  State<NixNavigationBar> createState() => _NixNavigationBarState();
}

class _NixNavigationBarState extends State<NixNavigationBar> {
  bool _isDragging = false;
  double _dragX = 0.0;

  void _handleDragStart(
    DragStartDetails details,
    double contentWidth,
    EdgeInsets resolvedPadding,
  ) {
    setState(() {
      _isDragging = true;
      _dragX = (details.localPosition.dx - resolvedPadding.left).clamp(
        0.0,
        contentWidth,
      );
    });
  }

  void _handleDragUpdate(
    DragUpdateDetails details,
    double contentWidth,
    EdgeInsets resolvedPadding,
  ) {
    final double itemWidth = contentWidth / widget.items.length;
    setState(() {
      _dragX = (details.localPosition.dx - resolvedPadding.left).clamp(
        0.0,
        contentWidth,
      );
    });

    final int newIndex = (_dragX / itemWidth).floor().clamp(
      0,
      widget.items.length - 1,
    );
    if (newIndex != widget.currentIndex) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      widget.onTap(newIndex);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _handleTapDown(
    TapDownDetails details,
    double contentWidth,
    EdgeInsets resolvedPadding,
  ) {
    final double itemWidth = contentWidth / widget.items.length;
    final double localX = (details.localPosition.dx - resolvedPadding.left)
        .clamp(0.0, contentWidth);
    final int newIndex = (localX / itemWidth).floor().clamp(
      0,
      widget.items.length - 1,
    );

    if (newIndex != widget.currentIndex) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      widget.onTap(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextDirection textDirection = Directionality.of(context);

    final EdgeInsets resolvedPadding = widget.padding.resolve(textDirection);
    final EdgeInsets resolvedIndicatorPadding = widget.indicatorPadding.resolve(
      textDirection,
    );

    // Resolve styling tokens
    final bool useBlur = widget.enableBlur;
    final Color baseBgColor =
        widget.backgroundColor ??
        (theme.brightness == Brightness.dark ? Colors.black : Colors.white);

    final Color effectiveBgColor = useBlur
        ? baseBgColor.withOpacity(widget.dimFactor)
        : (widget.backgroundColor ?? theme.colorScheme.surface);

    final Color effectiveIndicatorColor =
        widget.indicatorColor ??
        (useBlur
            ? (theme.brightness == Brightness.dark
                  ? theme.colorScheme.primary.withOpacity(0.24)
                  : theme.colorScheme.primary.withOpacity(0.15))
            : theme.colorScheme.primary.withOpacity(0.12));

    final Color effectiveSelectedColor =
        widget.selectedItemColor ?? theme.colorScheme.primary;
    final Color effectiveUnselectedColor =
        widget.unselectedItemColor ??
        theme.colorScheme.onSurface.withOpacity(0.5);

    final BorderRadiusGeometry effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(40.0);
    final BorderRadiusGeometry effectiveIndicatorRadius =
        widget.indicatorBorderRadius ?? BorderRadius.circular(40.0);

    final List<BoxShadow>? effectiveShadows = widget.enableShadow
        ? (widget.shadows ??
              [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ])
        : widget.shadows;

    final bool hasLabel = widget.items.any((item) => item.label != null);
    final double effectiveHeight = widget.height ?? (hasLabel ? 72.0 : 60.0);

    return Align(
      alignment: widget.alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
        ),
        child: Padding(
          padding: widget.margin,
          child: Container(
            height: effectiveHeight,
            decoration: BoxDecoration(
              borderRadius: effectiveRadius,
              boxShadow: effectiveShadows,
              border: widget.border,
            ),
            child: ClipRRect(
              borderRadius: effectiveRadius,
              child: _buildBackground(
                useBlur: useBlur,
                effectiveBgColor: effectiveBgColor,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double totalWidth = constraints.maxWidth;
                    final double contentWidth =
                        (totalWidth -
                                resolvedPadding.left -
                                resolvedPadding.right)
                            .clamp(0.0, double.infinity);
                    final int itemCount = widget.items.length;
                    final double itemWidth = itemCount > 0
                        ? contentWidth / itemCount
                        : 0.0;

                    double indicatorLeft = 0.0;
                    double indicatorWidth = 0.0;

                    if (itemCount > 0) {
                      indicatorWidth =
                          (itemWidth -
                                  resolvedIndicatorPadding.left -
                                  resolvedIndicatorPadding.right)
                              .clamp(0.0, double.infinity);

                      if (_isDragging) {
                        // Slide position centered with finger
                        indicatorLeft = _dragX - (indicatorWidth / 2);
                      } else {
                        indicatorLeft =
                            (widget.currentIndex * itemWidth) +
                            resolvedIndicatorPadding.left;
                      }

                      // Clamp selection boundary
                      final double minLeft = resolvedIndicatorPadding.left;
                      final double maxLeft =
                          (contentWidth -
                                  indicatorWidth -
                                  resolvedIndicatorPadding.right)
                              .clamp(minLeft, double.infinity);
                      indicatorLeft =
                          indicatorLeft.clamp(minLeft, maxLeft) +
                          resolvedPadding.left;
                    }

                    return Stack(
                      children: [
                        // Selection Indicator Bubble
                        if (itemCount > 0)
                          AnimatedPositioned(
                            duration: _isDragging
                                ? Duration.zero
                                : widget.duration,
                            curve: widget.curve,
                            left: indicatorLeft,
                            top: resolvedPadding.top,
                            bottom: resolvedPadding.bottom,
                            child: Padding(
                              padding: widget.indicatorPadding,
                              child: SizedBox(
                                width: indicatorWidth,
                                child: ClipRRect(
                                  borderRadius: effectiveIndicatorRadius,
                                  child: _buildIndicatorBackground(
                                    useBlur: useBlur,
                                    effectiveIndicatorColor:
                                        effectiveIndicatorColor,
                                    borderRadius: effectiveIndicatorRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Gesture and item rendering area
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapDown: (details) => _handleTapDown(
                            details,
                            contentWidth,
                            resolvedPadding,
                          ),
                          onHorizontalDragStart: (details) => _handleDragStart(
                            details,
                            contentWidth,
                            resolvedPadding,
                          ),
                          onHorizontalDragUpdate: (details) =>
                              _handleDragUpdate(
                                details,
                                contentWidth,
                                resolvedPadding,
                              ),
                          onHorizontalDragEnd: _handleDragEnd,
                          onHorizontalDragCancel: () =>
                              setState(() => _isDragging = false),
                          child: Padding(
                            padding: widget.padding,
                            child: Row(
                              children: List.generate(itemCount, (index) {
                                final item = widget.items[index];
                                final isSelected = index == widget.currentIndex;

                                final Color itemColor = isSelected
                                    ? (item.selectedColor ??
                                          effectiveSelectedColor)
                                    : (item.unselectedColor ??
                                          effectiveUnselectedColor);

                                final Widget iconWidget =
                                    item.activeIcon != null && isSelected
                                    ? item.activeIcon!
                                    : item.icon;

                                return Expanded(
                                  child: Semantics(
                                    label:
                                        item.tooltip ??
                                        (item.label is Text
                                            ? (item.label as Text).data
                                            : null),
                                    selected: isSelected,
                                    container: true,
                                    child: Tooltip(
                                      message: item.tooltip ?? '',
                                      child: TweenAnimationBuilder<Color?>(
                                        tween: ColorTween(end: itemColor),
                                        duration: widget.duration,
                                        curve: widget.curve,
                                        builder:
                                            (context, animatedColor, child) {
                                              return AnimatedScale(
                                                scale: isSelected ? 1.08 : 1.0,
                                                duration: widget.duration,
                                                curve: widget.curve,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconTheme.merge(
                                                        data: IconThemeData(
                                                          color: animatedColor,
                                                          size: 24.0,
                                                        ),
                                                        child: iconWidget,
                                                      ),
                                                      if (item.label !=
                                                          null) ...[
                                                        const SizedBox(
                                                          height: 2.0,
                                                        ),
                                                        DefaultTextStyle.merge(
                                                          style: TextStyle(
                                                            color:
                                                                animatedColor,
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                isSelected
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .normal,
                                                          ),
                                                          child: item.label!,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground({
    required bool useBlur,
    required Color effectiveBgColor,
    required Widget child,
  }) {
    if (useBlur) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurFactor * 30.0,
          sigmaY: widget.blurFactor * 30.0,
        ),
        child: Container(color: effectiveBgColor, child: child),
      );
    } else {
      return Container(color: effectiveBgColor, child: child);
    }
  }

  Widget _buildIndicatorBackground({
    required bool useBlur,
    required Color effectiveIndicatorColor,
    required BorderRadiusGeometry borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: effectiveIndicatorColor,
        borderRadius: borderRadius,
      ),
    );
  }
}
