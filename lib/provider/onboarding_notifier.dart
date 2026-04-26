import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
part 'onboarding_notifier.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const OnboardingState._();
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.onboarded() = _Onboarded;
  const factory OnboardingState.unOnboarded() = _UnOnboarded;
}

class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  OnboardingStateNotifier() : super(const OnboardingState.initial());
  // final OnboardStorage _onboardStorage;this._onboardStorage
  Future<void> setOnboarded() async {
    try {
      // await _onboardStorage.setOnboardedLocal();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setStateAsOnboarded() {
    state = const OnboardingState.onboarded();
  }

  Future<OnboardingState> getOnboardedState() async {
    try {
      final bool stateValue =
          false; //await _onboardStorage.readOnboardedLocal();
      if (stateValue) {
        state = const OnboardingState.onboarded();
      } else {
        state = const OnboardingState.unOnboarded();
      }
    } catch (e) {
      state = const OnboardingState.onboarded();
    }
    return state;
  }
}
