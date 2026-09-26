import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

/// Bloc gris pulsé affiché pendant le chargement.
///
/// La pulsation anime l'opacité d'un calque ([FadeTransition]) : aucun
/// widget n'est reconstruit pendant l'animation, et [RepaintBoundary] limite
/// le repeint au bloc lui-même.
class SkeletonBox extends HookWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppDimensions.radiusMd,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 900),
    );
    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, [controller]);

    final shape = BorderRadius.circular(radius);
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.salle,
            borderRadius: shape,
          ),
          child: FadeTransition(
            opacity: controller,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.velours,
                borderRadius: shape,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
