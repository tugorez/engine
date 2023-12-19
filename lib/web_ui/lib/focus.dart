// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of ui;

class FocusStateChange {
  final FocusState previousState;
  final FocusState currentState;

  FocusStateChange({
    required this.previousState,
    required this.currentState,
  });
}

class FocusState {
  final bool isFocused;
  final FocusDirection direction;

  FocusState({
    required this.isFocused,
    required this.direction,
  });
}

enum FocusDirection {
  unknown,
  forward,
  backwards,
}
