extension RuntimeFormatX on int {
  /// Durée en minutes au format du design : 118 → « 1H58 ».
  String get asRuntime {
    final hours = this ~/ 60;
    final minutes = this % 60;
    if (hours == 0) return '${minutes}MIN';
    return '${hours}H${minutes.toString().padLeft(2, '0')}';
  }
}
