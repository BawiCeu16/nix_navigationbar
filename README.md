# nix_navigationbar

A premium, highly customizable, and beautiful floating pill-style navigation bar widget for Flutter. Designed to feel responsive, modern, and tactile out-of-the-box.

---

## Features

* **Interactive Sliding Indicator**: A smooth background bubble slides dynamically as you tap or drag your finger horizontally across tabs.
* **Tactile Feedback**: Subtle selection haptics click as the selection crosses items.
* **Frosted Glass Blur**: Premium optional backdrop blur effect that blends elegantly with underneath page content.
* **Responsive Layouts**: Automatically respects a custom maximum width constraint, keeping the navigation bar centered and looking neat on tablets and desktop screens.
* **Highly Customizable**: Easily tune floating margins, outer/inner border radii, shadows, animations, and icons/labels.
* **Highly Optimized**: Pure Dart and Flutter implementation with zero unnecessary render passes.

---

## Getting Started

Add `nix_navigationbar` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  nix_navigationbar: ^2.0.0
```

Import it in your Dart code:

```dart
import 'package:nix_navigationbar/nix_navigationbar.dart';
```

---

## Important Navigation Management Recommendation

> [!IMPORTANT]
> **Recommended Screen Management**: We strongly advise using **List indexing** via `IndexedStack` (or `screens[_currentIndex]`) to switch between screens.
>
> ⚠️ **Warning regarding `PageView`**: While `PageView` can be used to handle swipe transitions, using `PageView` alongside floating navigation bars may lead to gesture conflicts, scroll synchronization glitches, frame rate drops, and unexpected state rebuilds. **Use `PageView` at your own risk.**

---

## Usage Example (Recommended Pattern)

Implement `NixNavigationBar` using screen list indexing (`IndexedStack`):

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of navigation screens
  final List<Widget> _screens = const [
    Center(child: Text('Home Screen')),
    Center(child: Text('Search Screen')),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // IndexedStack preserves widget state across tab switches cleanly
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),

          // Floating Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NixNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                NixNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_filled),
                  label: Text('Home'),
                ),
                NixNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
                NixNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Properties & Defaults

| Property | Type | Default Value | Description |
|---|---|---|---|
| `items` | `List<NixNavigationBarItem>` | *Required* | Navigation items to display. |
| `currentIndex` | `int` | *Required* | Index of the currently selected tab. |
| `onTap` | `ValueChanged<int>` | *Required* | Callback function triggered when a tab is tapped or dragged into. |
| `margin` | `EdgeInsetsGeometry` | `EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0)` | Floating margin space around the navigation bar. |
| `borderRadius` | `BorderRadiusGeometry?` | `BorderRadius.circular(360.0)` (100% pill) | Outer corner rounding of the navigation bar. |
| `indicatorBorderRadius` | `BorderRadiusGeometry?` | `BorderRadius.circular(360.0)` (100% pill) | Corner rounding of the sliding bubble indicator. |
| `blur` | `bool` | `false` | Enable or disable the frosted glass background blur. |
| `blurFactor` | `double` | `0.6` | Frosted glass blur intensity (0.0 to 1.0). |
| `dimFactor` | `double` | `0.5` | Opacity of the background surface (0.0 to 1.0). |
| `shadow` | `bool` | `false` | Cast a soft Material 3 shadow below the bar. |
| `hapticFeedback` | `bool` | `true` | Trigger tactile feedback clicks on selection changes. |
| `maxWidth` | `double?` | `600.0` | Limit horizontal expansion on large tablet/desktop screen layouts. |

---

## License

This package is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
