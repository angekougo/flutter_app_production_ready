extension RatingFormatX on double {
  /// Note au format français : 7.863 → « 7,9 ».
  String get asRating => toStringAsFixed(1).replaceAll('.', ',');
}

extension RuntimeFormatX on int {
  /// Durée en minutes au format du design : 118 → « 1H58 ».
  String get asRuntime {
    final hours = this ~/ 60;
    final minutes = this % 60;
    if (hours == 0) return '${minutes}MIN';
    return '${hours}H${minutes.toString().padLeft(2, '0')}';
  }
}

extension DateFormatX on DateTime {
  String get _dd => day.toString().padLeft(2, '0');
  String get _mm => month.toString().padLeft(2, '0');

  /// « 12.03.24 » (bandeau de la fiche film).
  String get asShortDate =>
      '$_dd.$_mm.${(year % 100).toString().padLeft(2, '0')}';

  /// « 14.03.1988 » (date de naissance).
  String get asLongDate => '$_dd.$_mm.$year';
}

extension PopularityFormatX on double {
  /// Popularité TMDB : 91.43 → « 91,4 ».
  String get asPopularity => toStringAsFixed(1).replaceAll('.', ',');
}
