import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/locale_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../../auth/presentation/providers/auth_controllers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/profile_entities.dart';
import '../providers/profile_providers.dart';
import '../widgets/language_picker.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Capturés avant l'appel : l'écran sera quitté pendant la déconnexion.
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final result = await ref.read(logoutControllerProvider.notifier).logout();
    result.when(
      success: (_) => showAppSnackBar(messenger, l10n.logoutSuccess),
      failure: (failure) => showAppSnackBar(
        messenger,
        l10n.failureMessage(failure),
        tone: SnackTone.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(profileProvider);
    final session = ref.watch(sessionInfoProvider);
    final stats = ref.watch(offlineStatsProvider).value;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final isLoggingOut = ref.watch(logoutControllerProvider).isLoading;
    final chosenLocale = ref.watch(localeControllerProvider);

    final account = profile.value?.data;
    final sessionExpired = profile.failure is UnauthorizedFailure;
    final email = account?.email ?? user?.email ?? '';
    final displayName = user?.displayName ?? email;
    final memberSince = account?.createdAt ?? user?.createdAt;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.projecteur,
          backgroundColor: AppColors.salle,
          onRefresh: () async {
            ref
              ..invalidate(profileProvider)
              ..invalidate(offlineStatsProvider);
            await ref
                .read(profileProvider.future)
                .then<void>((_) {}, onError: (Object _) {});
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.gutter,
              AppDimensions.lg,
              AppDimensions.gutter,
              AppDimensions.xxl,
            ),
            children: [
              Text(l10n.profileTitle, style: AppTypography.screenTitle),
              const SizedBox(height: AppDimensions.xl),
              _Identity(
                initials: user?.initials ?? '?',
                name: displayName,
                email: email,
              ),
              const SizedBox(height: AppDimensions.xl),
              if (sessionExpired) ...[
                _SessionExpiredCard(onReconnect: () => _logout(context, ref)),
                const SizedBox(height: AppDimensions.lg),
              ],
              _InfoCard(
                title: l10n.profileAccount,
                rows: [
                  _InfoRow(l10n.profileEmail, Text(email, style: _valueStyle)),
                  _InfoRow(
                    l10n.profileMemberSince,
                    Text(
                      memberSince == null
                          ? l10n.notAvailable
                          : l10n.monthYear(memberSince).toUpperCase(),
                      style: _monoValueStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _InfoCard(
                title: l10n.profileSession,
                rows: [
                  _InfoRow(
                    l10n.profileState,
                    _SessionState(
                      active: !sessionExpired && session.isActive(now),
                    ),
                  ),
                  _InfoRow(
                    l10n.profileAuthentication,
                    Text(_providerLabel(account?.provider), style: _valueStyle),
                  ),
                  _InfoRow(
                    l10n.profileAccessToken,
                    Text(
                      _tokenExpiry(l10n, session, now),
                      style: _monoValueStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _InfoCard(
                title: l10n.profileOfflineData,
                rows: [
                  _InfoRow(
                    l10n.profileCachedMovies,
                    Text(
                      '${stats?.cachedMovies ?? l10n.notAvailable}',
                      style: _monoValueStyle,
                    ),
                  ),
                  _InfoRow(
                    l10n.profileFavorites,
                    Text(
                      '${stats?.favorites ?? l10n.notAvailable}',
                      style: _monoValueStyle,
                    ),
                  ),
                  _InfoRow(
                    l10n.profileLastUpdate,
                    Text(
                      switch (stats?.lastUpdate) {
                        final date? => l10n.timeAgo(date, now: now),
                        null => l10n.profileNever,
                      }.toUpperCase(),
                      style: _monoValueStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _InfoCard(
                title: l10n.profilePreferences,
                rows: [
                  _InfoRow(
                    l10n.profileLanguage,
                    Text(languageName(l10n, chosenLocale), style: _valueStyle),
                    onTap: () => showLanguagePicker(context),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xl),
              OutlinedButton.icon(
                onPressed: isLoggingOut ? null : () => _logout(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.signal,
                  side: const BorderSide(color: AppColors.signalBorder),
                  minimumSize: const Size.fromHeight(56),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.logout),
              ),
              const SizedBox(height: AppDimensions.xl),
              Text(
                l10n.tmdbDisclaimer,
                textAlign: TextAlign.center,
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle get _valueStyle => AppTypography.bodyStrong.copyWith(
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

TextStyle get _monoValueStyle => AppTypography.meta.copyWith(
  color: AppColors.papier,
  fontSize: 14,
  letterSpacing: 1,
);

String _providerLabel(String? provider) => switch (provider) {
  null || 'email' => 'Email · Supabase',
  final other => '${other[0].toUpperCase()}${other.substring(1)} · Supabase',
};

/// « EXPIRE DANS 52 MIN », « EXPIRE DANS 1 H 05 », « EXPIRÉ ».
String _tokenExpiry(AppLocalizations l10n, SessionInfo session, DateTime now) {
  final remaining = session.remaining(now);
  if (remaining == null) return l10n.notAvailable;
  if (remaining.isNegative) return l10n.tokenExpired;
  final minutes = remaining.inMinutes;
  if (minutes < 60) return l10n.tokenExpiresInMinutes(minutes.clamp(1, 59));
  return l10n.tokenExpiresInHours(
    minutes ~/ 60,
    (minutes % 60).toString().padLeft(2, '0'),
  );
}

class _Identity extends StatelessWidget {
  const _Identity({
    required this.initials,
    required this.name,
    required this.email,
  });

  final String initials;
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: AppColors.projecteur,
          child: Text(
            initials,
            style: AppTypography.section.copyWith(
              color: AppColors.onProjecteur,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyStrong.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow {
  const _InfoRow(this.label, this.value, {this.onTap});
  final String label;
  final Widget value;

  /// Ligne interactive (ex. choix de la langue) : chevron affiché.
  final VoidCallback? onTap;
}

/// Carte « COMPTE / SESSION / DONNÉES HORS CONNEXION » à lignes séparées.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg + 2),
      decoration: BoxDecoration(
        color: AppColors.salle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg + 4),
        border: Border.all(color: AppColors.trait),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.lg + 2,
              bottom: AppDimensions.md,
            ),
            child: Text(title, style: AppTypography.overline),
          ),
          for (final row in rows) ...[
            const Divider(),
            InkWell(
              onTap: row.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
                child: Row(
                  children: [
                    // Libellé souple : il passe à la ligne plutôt que de
                    // déborder sur les petits écrans ou en grande police.
                    Flexible(
                      child: Text(
                        row.label,
                        style: AppTypography.body.copyWith(height: 1.3),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: DefaultTextStyle.merge(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          child: row.value,
                        ),
                      ),
                    ),
                    if (row.onTap != null)
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.poussiere,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionState extends StatelessWidget {
  const _SessionState({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.menthe : AppColors.signal;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppDimensions.sm),
        Text(
          active ? context.l10n.sessionActive : context.l10n.sessionExpired,
          style: AppTypography.bodyStrong.copyWith(color: color),
        ),
      ],
    );
  }
}

/// « Votre session a expiré. — Se reconnecter » (composant du design).
class _SessionExpiredCard extends StatelessWidget {
  const _SessionExpiredCard({required this.onReconnect});

  final VoidCallback onReconnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg + 2,
        AppDimensions.sm,
        AppDimensions.sm,
        AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.velours,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.signalBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.failureSessionExpired,
              style: AppTypography.bodyStrong.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onReconnect,
            child: Text(context.l10n.reconnect),
          ),
        ],
      ),
    );
  }
}
