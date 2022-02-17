import 'package:flutter/foundation.dart';

String? getDownloadUrl(){
  if(!kIsWeb) return null;
  switch(defaultTargetPlatform){
    case TargetPlatform.windows:
      return 'https://www.microsoft.com/store/productId/9PLKVQWCH0ZV';
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return null;
  }
}