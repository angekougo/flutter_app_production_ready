import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/network/api_constants.dart';
import 'package:flutter_app_production_ready/shared/extensions/image_x.dart';
import 'package:flutter_test/flutter_test.dart';

/// Les images sont téléchargées et décodées à la taille affichée, pas plus.
void main() {
  test('taille d’affiche TMDB : la plus petite qui couvre l’affichage', () {
    expect(ApiConstants.posterSizeFor(192), 'w342'); // vignette 64 dp ×3
    expect(ApiConstants.posterSizeFor(150), 'w154');
    expect(ApiConstants.posterSizeFor(180), 'w185');
    expect(ApiConstants.posterSizeFor(900), 'w500');
    expect(
      ApiConstants.poster('/a.jpg', size: ApiConstants.posterSizeFor(150)),
      'https://image.tmdb.org/t/p/w154/a.jpg',
    );
  });

  test('taille d’image de fond selon la largeur d’écran', () {
    expect(ApiConstants.backdropSizeFor(720), 'w780');
    expect(ApiConstants.backdropSizeFor(1170), 'w1280');
  });

  testWidgets('largeur de décodage = largeur affichée × densité', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    late int pixels;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          pixels = context.decodeWidth(64);
          return const SizedBox();
        },
      ),
    );
    expect(pixels, 192);
  });
}
