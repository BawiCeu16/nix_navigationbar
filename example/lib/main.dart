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
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 8),
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
  late final PageController _pageController;
  bool _isAnimatingToPage = false;

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (index == _currentIndex) return;
    _isAnimatingToPage = true;
    setState(() {
      _currentIndex = index;
    });

    if (_pageController.hasClients) {
      final int currentPage = _pageController.page?.round() ?? _currentIndex;
      final int pageDiff = (index - currentPage).abs();
      if (pageDiff > 1) {
        _pageController.jumpToPage(index > currentPage ? index - 1 : index + 1);
      }
      _pageController
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
            _isAnimatingToPage = false;
          });
    } else {
      _isAnimatingToPage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Navigation items
    final List<NixNavigationBarItem> navItems = [
      NixNavigationBarItem(
        icon: const Icon(Icons.dashboard_rounded),
        activeIcon: const Icon(Icons.dashboard_customize_rounded),
        label: _showLabels ? const Text('Dashboard') : null,
        tooltip: 'Dashboard View',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.tune_rounded),
        activeIcon: const Icon(Icons.settings_suggest_rounded),
        label: _showLabels ? const Text('Designer') : null,
        tooltip: 'Configure Design',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.analytics_rounded),
        activeIcon: const Icon(Icons.assessment_rounded),
        label: _showLabels ? const Text('Stats') : null,
        tooltip: 'Statistics',
      ),
      NixNavigationBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        activeIcon: const Icon(Icons.person_rounded),
        label: _showLabels ? const Text('Profile') : null,
        tooltip: 'User Account',
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Content Pages
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (!_isAnimatingToPage) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              children: [
                _buildDashboardTab(theme),
                _buildDesignerTab(theme),
                _buildStatsTab(theme),
                _buildProfileTab(theme),
              ],
            ),
          ),

          // Custom Floating Pill Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NixNavigationBar(
              enableShadow: _enableShadow,
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
              enableHapticFeedback: _enableHaptics,
              blurFactor: _blurFactor,
              dimFactor: _dimFactor,
              enableBlur: _enableBlur,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB PAGES BUILDERS ---

  Widget _buildDashboardTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 110),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Nix',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Modern Floating Navigation Package',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                widget.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dynamic Pill Layout',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This widget floats elegantly above your screen contents, providing a clean minimalist aesthetic. You can interact with it by tapping tabs or dragging the selection bubble directly!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(
                      0.85,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Quick Features', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        _buildFeatureItem(
          theme,
          Icons.swipe_right_rounded,
          'Drag-to-Select Gestures',
          'Touch and drag your finger horizontally across the tabs to fluidly slide the indicator background.',
        ),
        _buildFeatureItem(
          theme,
          Icons.aspect_ratio_rounded,
          'Responsive Constraints',
          'Adapts instantly to large desktop screens, remaining centered at a clean max-width (currently simulated).',
        ),
        _buildFeatureItem(
          theme,
          Icons.vibration_rounded,
          'Tactile Feedback',
          'Triggers subtle selection clicks as your selection crosses item thresholds.',
        ),
      ],
    );
  }

  Widget _buildDesignerTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 110),
      children: [
        Text(
          'Pill Customizer',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Live tune and preview navigation bar configuration',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),
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
          'Vertical Floating Margin (${_marginVertical.toStringAsFixed(0)} px)',
          _marginVertical,
          0.0,
          48.0,
          (val) => setState(() => _marginVertical = val),
        ),
        _buildSliderSetting(
          'Horizontal Floating Margin (${_marginHorizontal.toStringAsFixed(0)} px)',
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
        _buildSliderSetting(
          'Frosted Glass Blur (${(_blurFactor * 100).toStringAsFixed(0)}%)',
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
        const SizedBox(height: 16),
        _buildSectionHeader('Behavior & Colors'),
        SwitchListTile(
          title: const Text('Enable Frosted Glass Blur'),
          subtitle: const Text('Blur the page content behind the bar'),
          value: _enableBlur,
          onChanged: (val) => setState(() => _enableBlur = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Enable Elevation Shadow'),
          subtitle: const Text('Cast a soft M3 shadow below the bar'),
          value: _enableShadow,
          onChanged: (val) => setState(() => _enableShadow = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Show Labels'),
          subtitle: const Text('Show or hide text labels dynamically'),
          value: _showLabels,
          onChanged: (val) => setState(() => _showLabels = val),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Enable Haptic Feedback'),
          subtitle: const Text('Trigger selection vibration on changes'),
          value: _enableHaptics,
          onChanged: (val) => setState(() => _enableHaptics = val),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildStatsTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 110),
      children: [
        Text(
          'Usage Metrics',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard(
              theme,
              'Active Taps',
              '1,248',
              Icons.touch_app_rounded,
            ),
            _buildStatCard(
              theme,
              'Drag Swipes',
              '8,401',
              Icons.gesture_rounded,
            ),
            _buildStatCard(theme, 'Load Time', '4.2 ms', Icons.speed_rounded),
            _buildStatCard(
              theme,
              'Haptic Clicks',
              '9,649',
              Icons.vibration_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 110),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 54,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Icon(
                  Icons.person_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'nix Designer',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'nix.dev',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Account Settings'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('App Theme'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.help_outline_outlined),
            title: Text('Help & Support'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ),
      ],
    );
  }

  // --- HELPERS WIDGETS ---

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: theme.colorScheme.outline,
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
        Text(label, style: const TextStyle(fontSize: 14)),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _buildFeatureItem(
    ThemeData theme,
    IconData icon,
    String title,
    String desc,
  ) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(desc),
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
