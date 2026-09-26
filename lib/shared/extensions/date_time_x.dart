extension DateTimeX on DateTime {
  /// « il y a 2 min », « il y a 3 h », « il y a 2 j ».
  String timeAgo({DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(this);
    if (diff.inMinutes < 1) return "à l'instant";
    if (diff.inHours < 1) return 'il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'il y a ${diff.inHours} h';
    return 'il y a ${diff.inDays} j';
  }
}
