import 'package:flutter/material.dart';

/// Shared gallery settings — Dark / On-color / RTL — persisted across pages.
class GallerySettings extends ChangeNotifier {
  bool _dark = false;
  bool _onColor = false;
  bool _rtl = false;

  bool get dark => _dark;
  bool get onColor => _onColor;
  bool get rtl => _rtl;
  TextDirection get textDirection => _rtl ? TextDirection.rtl : TextDirection.ltr;

  set dark(bool v) {
    if (_dark == v) return;
    _dark = v;
    notifyListeners();
  }

  set onColor(bool v) {
    if (_onColor == v) return;
    _onColor = v;
    notifyListeners();
  }

  set rtl(bool v) {
    if (_rtl == v) return;
    _rtl = v;
    notifyListeners();
  }
}

/// InheritedNotifier lets any descendant read the settings and rebuild when
/// they change without pulling in a state-management dependency.
class GallerySettingsScope extends InheritedNotifier<GallerySettings> {
  const GallerySettingsScope({
    super.key,
    required GallerySettings super.notifier,
    required super.child,
  });

  static GallerySettings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GallerySettingsScope>();
    assert(scope?.notifier != null, 'GallerySettingsScope missing above this widget');
    return scope!.notifier!;
  }
}
