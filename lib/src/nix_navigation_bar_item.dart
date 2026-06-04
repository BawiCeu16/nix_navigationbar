import 'package:flutter/material.dart';

/// An item in a [NixNavigationBar].
///
/// Contains the configuration for a single tab/item, such as the icon,
/// optional active icon, label, and colors.
class NixNavigationBarItem {
  /// The widget to display as the icon of this item. Typically an [Icon].
  final Widget icon;

  /// An optional widget to display as the icon when this item is selected.
  /// If null, [icon] will be displayed instead.
  final Widget? activeIcon;

  /// An optional widget to display as the label below or beside the icon.
  /// Typically a [Text] widget.
  final Widget? label;

  /// An optional tooltip string to display when the user long-presses this item.
  final String? tooltip;

  /// Custom color for this item when selected. Override package-level selected colors.
  final Color? selectedColor;

  /// Custom color for this item when unselected. Override package-level unselected colors.
  final Color? unselectedColor;

  /// Creates an item for [NixNavigationBar].
  const NixNavigationBarItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.tooltip,
    this.selectedColor,
    this.unselectedColor,
  });
}
