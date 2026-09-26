import 'package:flutter/widgets.dart';

/// (Re)constructions observées pendant une action, par type de widget.
///
/// S'appuie sur [debugOnRebuildDirtyWidget] (mode debug, donc tests). À
/// utiliser après le premier affichage : tout build compté pendant
/// l'action est une reconstruction provoquée par celle-ci.
class RebuildCounter {
  final _counts = <Type, int>{};

  int of(Type widgetType) => _counts[widgetType] ?? 0;

  Future<void> record(Future<void> Function() action) async {
    final previous = debugOnRebuildDirtyWidget;
    debugOnRebuildDirtyWidget = (element, _) => _counts.update(
      element.widget.runtimeType,
      (n) => n + 1,
      ifAbsent: () => 1,
    );
    try {
      await action();
    } finally {
      debugOnRebuildDirtyWidget = previous;
    }
  }
}
