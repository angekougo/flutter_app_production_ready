import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/network/api_constants.dart';
import '../extensions/image_x.dart';

/// Portrait rond : photo TMDB, ou initiales sur une teinte propre à la
/// personne (« CS », « YB »… du design).
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.personId,
    required this.initials,
    required this.size,
    this.profilePath,
  });

  final int personId;
  final String initials;
  final double size;
  final String? profilePath;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.posterTint(personId + 3);
    final url = ApiConstants.profile(
      profilePath,
      size: size > 120 ? 'h632' : 'w185',
    );
    final fallback = Center(
      child: Text(
        initials,
        style: AppTypography.section.copyWith(fontSize: size * 0.34),
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tint,
        border: Border.all(color: Color.lerp(tint, AppColors.papier, 0.15)!),
      ),
      // Portrait décoratif : le nom est affiché (et lu) à côté.
      child: ExcludeSemantics(
        child: url == null
            ? fallback
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                memCacheWidth: context.decodeWidth(size),
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
