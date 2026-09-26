import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/date_time_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../../auth/presentation/providers/auth_controllers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/profile_entities.dart';
import '../providers/profile_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Capturé avant l'appel : l'écran sera quitté pendant la déconnexion.
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(logoutControllerProvider.notifier).logout();
    result.when(
      success: (_) =>
          showAppSnackBar(messenger, 'Vous êtes déconnecté. À bientôt !'),
      failure: (failure) =>
          showAppSnackBar(messenger, failure.message, tone: SnackTone.error),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(profileProvider);
    final session = ref.watch(sessionInfoProvider);
    final stats = ref.watch(offlineStatsProvider).value;
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final isLoggingOut = ref.watch(logoutControllerProvider).isLoading;

    final account = profile.value?.data;
    final sessionExpired = profile.failure is UnauthorizedFailure;
    final email = account?.email ?? user?.email ?? '';
    final displayName = user?.displayName ?? email;

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
              Text('Profil', style: AppTypography.screenTitle),
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
                title: 'COMPTE',
                rows: [
                  _InfoRow('Email', Text(email, style: _valueStyle)),
                  _InfoRow(
                    'Membre depuis',
                    Text(
                      _memberSince(account?.createdAt ?? user?.createdAt),
                      style: _monoValueStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _InfoCard(
                title: 'SESSION',
                rows: [
                  _InfoRow(
                    'État',
                    _SessionState(
                      active: !sessionExpired && session.isActive(now),
                    ),
                  ),
                  _InfoRow(
                    'Authentification',
                    Text(_providerLabel(account?.provider), style: _valueStyle),
                  ),
                  _InfoRow(
                    'Jeton d’accès',
                    Text(_tokenExpiry(session, now), style: _monoValueStyle),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.lg),
              _InfoCard(
                title: 'DONNÉES HORS CONNEXION',
                rows: [
                  _InfoRow(
                    'Films en cache',
                    Text(
                      '${stats?.cachedMovies ?? '—'}',
                      style: _monoValueStyle,
                    ),
                  ),
                  _InfoRow(
                    'Favoris',
                    Text('${stats?.favorites ?? '—'}', style: _monoValueStyle),
                  ),
                  _InfoRow(
                    'Dernière mise à jour',
                    Text(
                      stats?.lastUpdate?.timeAgo(now: now).toUpperCase() ??
                          'JAMAIS',
                      style: _monoValueStyle,
                    ),
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
                label: const Text('Se déconnecter'),
              ),
              const SizedBox(height: AppDimensions.xl),
              Text(
                'Ce produit utilise l’API TMDB mais n’est ni approuvé ni '
                'certifié par TMDB.',
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

const _months = [
  'JANVIER', 'FÉVRIER', 'MARS', 'AVRIL', 'MAI', 'JUIN', //
  'JUILLET', 'AOÛT', 'SEPTEMBRE', 'OCTOBRE', 'NOVEMBRE', 'DÉCEMBRE',
];

/// « MARS 2026 »
String _memberSince(DateTime? date) =>
    date == null ? '—' : '${_months[date.month - 1]} ${date.year}';

String _providerLabel(String? provider) => switch (provider) {
  null || 'email' => 'Email · Supabase',
  final other => '${other[0].toUpperCase()}${other.substring(1)} · Supabase',
};

/// « EXPIRE DANS 52 MIN », « EXPIRE DANS 1 H 05 », « EXPIRÉ ».
String _tokenExpiry(SessionInfo session, DateTime now) {
  final remaining = session.remaining(now);
  if (remaining == null) return '—';
  if (remaining.isNegative) return 'EXPIRÉ';
  final minutes = remaining.inMinutes;
  if (minutes < 60) return 'EXPIRE DANS ${minutes.clamp(1, 59)} MIN';
  return 'EXPIRE DANS ${minutes ~/ 60} H '
      '${(minutes % 60).toString().padLeft(2, '0')}';
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
  const _InfoRow(this.label, this.value);
  final String label;
  final Widget value;
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
            Padding(
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
                ],
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
          active ? 'Active' : 'Expirée',
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
              const UnauthorizedFailure().message,
              style: AppTypography.bodyStrong.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onReconnect,
            child: const Text('Se reconnecter'),
          ),
        ],
      ),
    );
  }
}
