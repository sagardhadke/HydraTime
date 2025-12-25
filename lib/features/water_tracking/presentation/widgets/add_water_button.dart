import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class AddWaterButton extends StatefulWidget {
  final double amount;
  final VoidCallback onPressed;

  const AddWaterButton({
    super.key,
    required this.amount,
    required this.onPressed,
  });

  @override
  State<AddWaterButton> createState() => _AddWaterButtonState();
}

class _AddWaterButtonState extends State<AddWaterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:  const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    _animationController.forward().then((_) {
      _animationController.reset();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale:  Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _animationController, curve:  Curves.easeInOut),
      ),
      child: GestureDetector(
        onTap: _onPressed,
        child: Container(
          padding:  const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors. primaryColor.withOpacity(0.2),
                AppColors.primaryColor.withOpacity(0.1),
              ],
              begin:  Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:  BorderRadius.circular(12),
            border: Border.all(
              color: AppColors. primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.amount.toInt()} ml',
                style:  Theme.of(context).textTheme.titleSmall?. copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight. w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}