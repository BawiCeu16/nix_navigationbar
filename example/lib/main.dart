import 'package:flutter/material.dart';
import 'package:nix_navigationbar/nix_navigationbar.dart';

void main() {
  runApp(const NixDemoApp());
}

class NixDemoApp extends StatefulWidget {
  const NixDemoApp({super.key});

  @override
  State<NixDemoApp> createState() => _NixDemoAppState();
}

class _NixDemoAppState extends State<NixDemoApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NixNavigationBar Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: DemoHomeScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: (val) => setState(() => _isDarkMode = val),
      ),
    );
  }
}

class DemoHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const DemoHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  int _currentIndex = 0;

  // Customization parameters for the NixNavigationBar
  double _maxWidth = 550.0;
  double _borderRadius = 40.0;
  double _marginVertical = 30.0;
  double _marginHorizontal = 40.0;
  double _indicatorPadding = 0.0;
  bool _enableHaptics = true;
  bool _showLabels = false;
  double _blurFactor = 0.6;
  double _dimFactor = 0.5;
  bool _enableBlur = false;
  bool _enableShadow = true;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<NixNavigationBarItem> navItems = [
      NixNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home_rounded),
        label: _showLabels ? const Text('Home') : null,
        tooltip: 'Home',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.tune_rounded),
        activeIcon: const Icon(Icons.settings_suggest_rounded),
        label: _showLabels ? const Text('Configuration') : null,
        tooltip: 'Configuration Design',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.search_rounded),
        activeIcon: const Icon(Icons.search_rounded),
        label: _showLabels ? const Text('Search') : null,
        tooltip: 'Search',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        activeIcon: const Icon(Icons.person_rounded),
        label: _showLabels ? const Text('Profile') : null,
        tooltip: 'Profile',
      ),
    ];

    final List<Widget> screens = [
      _buildSimplePage(theme, Icons.home_rounded, 'Home Screen'),
      _buildConfigurationScreen(theme),
      _buildSimplePage(theme, Icons.search_rounded, 'Search Screen'),
      _buildSimplePage(theme, Icons.person_rounded, 'Profile Screen'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NixNavigationBar Example'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NixNavigationBar(
              shadow: _enableShadow,
              items: navItems,
              currentIndex: _currentIndex,
              onTap: _onTabChanged,
              maxWidth: _maxWidth,
              borderRadius: BorderRadius.circular(_borderRadius),
              indicatorBorderRadius: BorderRadius.circular(
                (_borderRadius - 4).clamp(0.0, double.infinity),
              ),
              margin: EdgeInsets.only(
                left: _marginHorizontal,
                right: _marginHorizontal,
                bottom: _marginVertical,
              ),
              indicatorPadding: EdgeInsets.all(_indicatorPadding),
              hapticFeedback: _enableHaptics,
              blurFactor: _blurFactor,
              dimFactor: _dimFactor,
              blur: _enableBlur,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplePage(ThemeData theme, IconData icon, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationScreen(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
      children: [
        Text(
          'Configuration Design',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Live tune navigation bar properties',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('Sizing & Layout'),
        _buildSliderSetting(
          'Max Width (${_maxWidth.toStringAsFixed(0)} px)',
          _maxWidth,
          320.0,
          900.0,
          (val) => setState(() => _maxWidth = val),
        ),
        _buildSliderSetting(
          'Border Radius (${_borderRadius.toStringAsFixed(0)} px)',
          _borderRadius,
          0.0,
          40.0,
          (val) => setState(() => _borderRadius = val),
        ),
        _buildSliderSetting(
          'Vertical Margin (${_marginVertical.toStringAsFixed(0)} px)',
          _marginVertical,
          0.0,
          48.0,
          (val) => setState(() => _marginVertical = val),
        ),
        _buildSliderSetting(
          'Horizontal Margin (${_marginHorizontal.toStringAsFixed(0)} px)',
          _marginHorizontal,
          0.0,
          64.0,
          (val) => setState(() => _marginHorizontal = val),
        ),
        _buildSliderSetting(
          'Indicator Padding (${_indicatorPadding.toStringAsFixed(1)} px)',
          _indicatorPadding,
          0.0,
          12.0,
          (val) => setState(() => _indicatorPadding = val),
        ),
        const SizedBox(height: 12),
        _buildSectionHeader('Blur & Dimming'),
        _buildSliderSetting(
          'Frosted Blur (${(_blurFactor * 100).toStringAsFixed(0)}%)',
          _blurFactor,
          0.0,
          1.0,
          (val) => setState(() => _blurFactor = val),
        ),
        _buildSliderSetting(
          'Background Dimming (${(_dimFactor * 100).toStringAsFixed(0)}%)',
          _dimFactor,
          0.0,
          1.0,
          (val) => setState(() => _dimFactor = val),
        ),
        const SizedBox(height: 12),
        _buildSectionHeader('Behavior & Features'),
        SwitchListTile(
          title: const Text('Enable Frosted Glass Blur'),
          value: _enableBlur,
          onChanged: (val) => setState(() => _enableBlur = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Enable Elevation Shadow'),
          value: _enableShadow,
          onChanged: (val) => setState(() => _enableShadow = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Show Item Labels'),
          value: _showLabels,
          onChanged: (val) => setState(() => _showLabels = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Enable Haptic Feedback'),
          value: _enableHaptics,
          onChanged: (val) => setState(() => _enableHaptics = val),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
