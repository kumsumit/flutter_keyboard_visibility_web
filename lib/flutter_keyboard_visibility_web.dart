import 'dart:async';
import 'package:web/web.dart';
import 'package:flutter_keyboard_visibility_platform_interface/flutter_keyboard_visibility_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// The web implementation of the [FlutterKeyboardVisibilityPlatform] of the
/// FlutterKeyboardVisibility plugin.
class FlutterKeyboardVisibilityPluginWeb
    extends FlutterKeyboardVisibilityPlatform {
  /// Constructs a [FlutterKeyboardVisibilityPluginWeb].
  FlutterKeyboardVisibilityPluginWeb(Navigator navigator);
  static final _onChangeController =
      StreamController<KeyboardVisibilityStatus>();
  static final _onChange = _onChangeController.stream.asBroadcastStream();

  /// Factory method that initializes the FlutterKeyboardVisibility plugin
  /// platform with an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    FlutterKeyboardVisibilityPlatform.instance =
        FlutterKeyboardVisibilityPluginWeb(window.navigator);
    EventStreamProvider<Event>(
      'resize',
    ).forTarget(window.visualViewport).listen((e) {
      final minKeyboardHeight = 200;

      final screenHeight = window.screen.height;
      final viewportHeight = window.visualViewport?.height.toInt() ?? 0;
      final newState = (screenHeight - minKeyboardHeight) > viewportHeight;
      if (newState) {
        _updateValue(KeyboardVisibilityStatus.visible);
      } else {
        _updateValue(KeyboardVisibilityStatus.notVisible);
      }
    });
  }

  static KeyboardVisibilityStatus get isVisible => _isVisible;
  static KeyboardVisibilityStatus _isVisible =
      KeyboardVisibilityStatus.notVisible;

  static void _updateValue(KeyboardVisibilityStatus newValue) {
    // Don't report the same value multiple times
    if (newValue == _isVisible) {
      return;
    }

    _isVisible = newValue;
    _onChangeController.add(newValue);
  }

  /// Emits changes to keyboard visibility from the platform. Web is not
  /// implemented yet so `notVisible` is returned.
  @override
  Stream<KeyboardVisibilityStatus> get onChange => _onChange;
}
