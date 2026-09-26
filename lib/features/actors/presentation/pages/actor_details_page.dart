import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/person_avatar.dart';
import '../../../../shared/widgets/poster_grid.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../../movies/domain/entities/movie_details.dart';
import '../../domain/entities/actor_details.dart';
import '../providers/actor_providers.dart';

/// Fiche acteur. [preview] (l'acteur tel qu'affiché dans le casting) permet
/// d'afficher le portrait et le nom pendant le chargement.
class ActorDetailsPage extends ConsumerWidget {
  const ActorDetailsPage({super.key, required this.actorId, this.preview});

  final int actorId;
  final CastMember? preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actor = ref.watch(actorDetailsProvider(actorId));

    final Widget body = switch (actor) {
      AsyncValue(:final value?) => _ActorContent(
        actor: value.data,
        fromCache: value.fromCache,
        cachedAt: value.cachedAt,
      ),
      AsyncValue(:final failure?) => _ActorError(
        failure: failure,
        onRetry: () => ref.invalidate(actorDetailsProvider(actorId)),
      ),
      _ => _ActorLoading(preview: preview),
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter - 4,
                AppDimensions.sm,
                AppDimensions.gutter,
                0,
              ),
              child: OutlinedButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(RoutePaths.home),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(56, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: const StadiumBorder(),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  semanticLabel: context.l10n.back,
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// « NÉE LE 14.03.1988 · LYON » / « BORN MAR 14, 1988 · LYON »
String actorBirthLine(ActorDetails actor, AppLocalizations l10n) {
  final gender = l10n.genderKey(actor.gender);
  // « Kingston upon Thames, London, England, UK » → « KINGSTON UPON THAMES ».
  final place = actor.placeOfBirth?.split(',').first.trim();
  return [
    if (actor.birthday case final birthday?)
      l10n.actorBorn(gender, l10n.longDate(birthday).toUpperCase()),
    if (place != null && place.isNotEmpty) place.toUpperCase(),
    if (actor.deathday case final deathday?)
      l10n.actorDied(gender, l10n.longDate(deathday).toUpperCase()),
  ].join(' · ');
}

class _ActorContent extends StatelessWidget {
  const _ActorContent({
    required this.actor,
    required this.fromCache,
    this.cachedAt,
  });

  final ActorDetails actor;
  final bool fromCache;
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final birthLine = actorBirthLine(actor, l10n);
    final knownFor = l10n.actorKnownFor(l10n.genderKey(actor.gender));
    final count = actor.credits.length;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.lg),
              PersonAvatar(
                personId: actor.id,
                initials: initialsOf(actor.name),
                profilePath: actor.profilePath,
                size: 176,
              ),
              const SizedBox(height: AppDimensions.xl),
              Padding(
                padding: AppDimensions.screenPadding,
                child: Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(fontSize: 36),
                ),
              ),
              if (birthLine.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.md),
                Padding(
                  padding: AppDimensions.screenPadding,
                  child: Text(
                    birthLine,
                    textAlign: TextAlign.center,
                    style: AppTypography.overline.copyWith(fontSize: 13),
                  ),
                ),
              ],
              if (fromCache)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.gutter,
                    AppDimensions.xl,
                    AppDimensions.gutter,
                    0,
                  ),
                  child: OfflineBanner(cachedAt: cachedAt),
                ),
              const SizedBox(height: AppDimensions.xl),
              Padding(
                padding: AppDimensions.screenPadding,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: l10n.actorFilms,
                          child: Text(
                            '$count',
                            style: AppTypography.display.copyWith(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: _StatCard(
                          label: knownFor,
                          child: Text(
                            l10n.departmentLabel(actor.knownForDepartment),
                            style: AppTypography.bodyStrong.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xxl),
              Padding(
                padding: AppDimensions.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.biography,
                      style: AppTypography.section.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    ExpandableText(
                      actor.biography ?? l10n.biographyUnavailable,
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        color: AppColors.papier.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.xxl),
              SectionHeader(
                title: l10n.filmography,
                tag: l10n.filmCount(count),
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        ),
        SliverPadding(
          padding: AppDimensions.screenPadding,
          sliver: SliverPosterGrid(
            itemCount: count,
            itemBuilder: (context, index) {
              final credit = actor.credits[index];
              return PosterGridItem(
                movieId: credit.movieId,
                title: credit.title,
                posterPath: credit.posterPath,
                caption: [
                  if (credit.year != null) '${credit.year}',
                  if (credit.role != null) credit.role!.toUpperCase(),
                ].join(' · '),
                semanticLabel: context.l10n.movieSummary(
                  credit.title,
                  year: credit.year,
                  genre: credit.role,
                ),
                onTap: () => context.push(RoutePaths.movie(credit.movieId)),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg + 2),
      decoration: BoxDecoration(
        color: AppColors.salle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.trait),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTypography.overline.copyWith(fontSize: 11)),
          const SizedBox(height: AppDimensions.sm),
          child,
        ],
      ),
    );
  }
}

class _ActorLoading extends StatelessWidget {
  const _ActorLoading({this.preview});

  final CastMember? preview;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: AppDimensions.lg),
        Center(
          child: preview == null
              ? const SkeletonBox(width: 176, height: 176, radius: 88)
              : PersonAvatar(
                  personId: preview!.id,
                  initials: preview!.initials,
                  profilePath: preview!.profilePath,
                  size: 176,
                ),
        ),
        const SizedBox(height: AppDimensions.xl),
        Center(
          child: preview == null
              ? const SkeletonBox(width: 220, height: 36, radius: 8)
              : Text(
                  preview!.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(fontSize: 36),
                ),
        ),
        const SizedBox(height: AppDimensions.xl),
        const Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            children: [
              SkeletonBox(height: 84, radius: AppDimensions.radiusLg),
              SizedBox(height: AppDimensions.xxl),
              SkeletonBox(height: 120, radius: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActorError extends StatelessWidget {
  const _ActorError({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return switch (failure) {
      NotFoundFailure() => StateMessageView(
        tone: StateTone.error,
        icon: Icons.person_off_outlined,
        title: l10n.failureMessage(failure),
        message: l10n.actorNotFoundMessage,
      ),
      CacheFailure() => StateMessageView(
        icon: Icons.wifi_off_rounded,
        title: l10n.detailsOfflineTitle,
        message: l10n.detailsOfflineMessage,
        primaryLabel: l10n.retry,
        onPrimary: onRetry,
      ),
      _ => StateMessageView(
        tone: StateTone.error,
        icon: Icons.person_outline_rounded,
        title: l10n.loadErrorTitle,
        message: l10n.failureMessage(failure),
        primaryLabel: l10n.retry,
        onPrimary: onRetry,
      ),
    };
  }
}
