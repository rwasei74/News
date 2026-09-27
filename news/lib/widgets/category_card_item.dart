import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_text_styles.dart';

enum CategoryCardAlignment {
  imageLeft,
  imageRight,
}

/// CategoryCardItem is a clean, reusable widget matching the design specifications:
/// - Supports alternating layouts (image left vs. image right)
/// - Perfectly aligns with Light & Dark themes
/// - Text rendered cleanly using GoogleFonts Inter without overlapping image text
/// - Interactive pill button ('View All' / 'عرض الكل' with circular arrow)
class CategoryCardItem extends StatelessWidget {
  final String title;
  final String lightImagePath;
  final String darkImagePath;
  final CategoryCardAlignment alignment;
  final VoidCallback? onViewAllPressed;

  const CategoryCardItem({
    super.key,
    required this.title,
    required this.lightImagePath,
    required this.darkImagePath,
    required this.alignment,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final Color cardBackground = isDark ? AppColors.darkCard : AppColors.lightCard;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color circleBg = isDark ? AppColors.viewAllCircleDark : AppColors.viewAllCircleLight;
    final Color arrowColor = isDark ? AppColors.lightTextPrimary : AppColors.darkTextPrimary;

    final bool isImageLeft = alignment == CategoryCardAlignment.imageLeft;
    final String activeImage = isDark ? darkImagePath : lightImagePath;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background clean illustration (without baked-in text)
          Positioned.fill(
            child: Image.asset(
              activeImage,
              fit: BoxFit.cover,
              alignment: isImageLeft ? Alignment.centerLeft : Alignment.centerRight,
            ),
          ),

          // Content Layer (Custom Inter Title & View All button)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Column(
                crossAxisAlignment:
                    isImageLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title rendered cleanly with GoogleFonts Inter
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      title,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),

                  // Pill Button (View All)
                  InkWell(
                    onTap: onViewAllPressed,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.viewAllPill.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: isImageLeft
                            ? [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                  child: Text(
                                    localizations.viewAll,
                                    style: AppTextStyles.buttonText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: circleBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isRtl
                                        ? Icons.arrow_back_ios_new_rounded
                                        : Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: arrowColor,
                                  ),
                                ),
                              ]
                            : [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: circleBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isRtl
                                        ? Icons.arrow_forward_ios_rounded
                                        : Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: arrowColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                  child: Text(
                                    localizations.viewAll,
                                    style: AppTextStyles.buttonText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
