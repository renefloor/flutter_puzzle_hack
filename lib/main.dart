// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:island_slide_puzzle/app/app.dart';
import 'package:island_slide_puzzle/bootstrap.dart';

import 'layout/components/island_puzzle_tile.dart';

void main() {
  bootstrap(() => const App());
  Future<void>.delayed(const Duration(seconds: 1))
      .then((_) => tileAudioPlayer.setAsset('assets/sounds/splash_small2.mp3'));
}
