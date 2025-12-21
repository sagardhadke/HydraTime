import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatefulWidget {
  final double size;
  final bool showTooltip;

  const ThemeToggleButton({
    super.key,
    this.size = 24,
    this.showTooltip = true,
  });

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme(ThemeProvider provider) {
    _animationController.forward().then((_) {
      _animationController.reset();
    });
    provider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final button = IconButton(
          onPressed: () => _toggleTheme(themeProvider),
          icon: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  size: widget.size,
                  color: AppColors.primaryColor,
                ),
              );
            },
          ),
        );

        if (widget.showTooltip) {
          return Tooltip(
            message: themeProvider.isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            child: button,
          );
        }

        return button;
      },
    );
  }
}