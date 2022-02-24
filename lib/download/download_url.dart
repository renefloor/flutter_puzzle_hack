import 'package:flutter/foundation.dart';

String? getDownloadUrl() {
  if (!kIsWeb) return null;
  switch (defaultTargetPlatform) {
    case TargetPlatform.windows:
      return 'https://www.microsoft.com/store/productId/9PLKVQWCH0ZV';
    case TargetPlatform.android:
      return 'https://play.google.com/store/apps/details?id=nl.renefloor.puzzle';
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return 'https://apps.apple.com/us/app/island-slide-puzzle/id1611128660';
    case TargetPlatform.linux:
      return 'https://snapcraft.io/island-slide-puzzle';
    case TargetPlatform.fuchsia:
      return null;
  }
}
