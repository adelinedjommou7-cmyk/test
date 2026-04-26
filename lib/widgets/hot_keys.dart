import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotKeys {
  //final WidgetRef ref;
  /// [HotKeys] object instance. Must call [HotKeys.initialize].
  static HotKeys instance = HotKeys();

  static Future<void> initialize() async {
    await Future.wait(
      [
        HotKeyManager.instance
            .register(_spaceHotkey, keyDownHandler: (_) => {}),
      ],
    );
  }

  Future<void> disableSpaceHotKey() async {
    await HotKeyManager.instance.unregister(_spaceHotkey);
  }

  Future<void> enableSpaceHotKey() async {
    await HotKeyManager.instance
        .register(_spaceHotkey, keyDownHandler: (_) => {}
            //AudioControlCentre.audioControlCentre.playOrPause(),
            );
  }
}

HotKey _spaceHotkey = HotKey(
  key: PhysicalKeyboardKey.keyQ,
  modifiers: [HotKeyModifier.alt],
  // Set hotkey scope (default is HotKeyScope.system)
  scope: HotKeyScope.inapp, // Set as inapp-wide hotkey.
);
