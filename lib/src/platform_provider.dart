import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A Provider that provides access to the functions of swicthing platforms.
///
/// When placed at the root, it will rebuild the application with the new platform
/// and therefore when [PlatformWidgets] are used within the application
/// will render based on those widgets
///
/// Usage:
/// ```dart
/// return PlatformProvider(
///    builder: (BuildContext context) MaterialApp(...)
/// );
/// ```
///
/// Gain access through the InheritedWidget:
/// ```dart
/// PlatformProvider.of(context).changeToMaterialPlatform();
///
/// or
///
/// PlatformProvider.of(context).changeToCupertinoPlatform();
/// ```
class PlatformProvider extends StatefulWidget {
  const PlatformProvider({
    @required this.builder,
    this.initialPlatform,
    this.settings,
  }) : assert(builder != null);

  final WidgetBuilder builder;
  final TargetPlatform initialPlatform;
  final PlatformSettingsData settings;

  static PlatformProviderState of(BuildContext context) {
    _PlatformProviderState state =
        context.findAncestorStateOfType<_PlatformProviderState>();

    return state?.state;
  }

  @override
  _PlatformProviderState createState() => _PlatformProviderState();
}

class _PlatformProviderState extends State<PlatformProvider> {
  TargetPlatform platform;

  PlatformProviderState get state => PlatformProviderState._(this);

  @override
  void initState() {
    super.initState();
    platform = widget.initialPlatform;
  }

  void changeToPlatform(TargetPlatform platform) {
    setState(() {
      this.platform = platform;
    });
  }

  /// Sets the platform to be [TargetPlatform.android]
  void changeToMaterialPlatform() {
    setState(() {
      platform = TargetPlatform.android;
    });
  }

  /// Sets the platform to be [TargetPlatform.iOS]
  void changeToCupertinoPlatform() {
    setState(() {
      platform = TargetPlatform.iOS;
    });
  }

  void changeToAutoDetectPlatform() {
    setState(() {
      platform = null;
    });
  }

  PlatformSettingsData get settings => widget.settings;

  @override
  Widget build(BuildContext context) {
    if (platform == null) return widget.builder(context);

    return Theme(
      data: Theme.of(context).copyWith(platform: platform),
      child: Builder(
        builder: (context) => widget.builder(context),
      ),
    );
  }
}

class PlatformProviderState {
  PlatformProviderState._(this._parent);

  final _PlatformProviderState _parent;

  TargetPlatform get platform => _parent.platform;

  PlatformSettingsData get settings =>
      _parent.settings ?? PlatformSettingsData();

  void changeToMaterialPlatform() {
    _parent.changeToMaterialPlatform();
  }

  void changeToCupertinoPlatform() {
    _parent.changeToCupertinoPlatform();
  }

  void changeToAutoDetectPlatform() {
    _parent.changeToAutoDetectPlatform();
  }
}

class PlatformSettingsData {
  /// If there is a mixture of Material and Cupertino widgets it maybe
  /// useful to wrap in a Material. This will affect font and colors
  /// particulary ios dark mode may not work as expected.
  /// Alternatively when using Material widgets ensure that a parent Material widget exists.
  final bool iosUsesMaterialWidgets;

  /// The style each platform will use. Either [PlatformStyle.Material] or
  /// [PlatformStyle.Cupertino].
  final PlatformStyleData platformStyle;

  PlatformSettingsData({
    this.iosUsesMaterialWidgets = false,
    this.platformStyle = const PlatformStyleData(),
  })  : assert(iosUsesMaterialWidgets != null),
        assert(platformStyle != null);
}

enum PlatformStyle {
  Material,
  Cupertino,
}

class PlatformStyleData {
  final PlatformStyle android;
  final PlatformStyle ios;
  final PlatformStyle macos;
  final PlatformStyle windows;
  final PlatformStyle web;
  final PlatformStyle fuchsia;
  final PlatformStyle linux;

  const PlatformStyleData({
    this.android = PlatformStyle.Material,
    this.ios = PlatformStyle.Cupertino,
    this.macos = PlatformStyle.Cupertino,
    this.windows = PlatformStyle.Material,
    this.web = PlatformStyle.Material,
    this.fuchsia = PlatformStyle.Material,
    this.linux = PlatformStyle.Material,
  })  : assert(android != null),
        assert(android != null),
        assert(ios != null),
        assert(macos != null),
        assert(windows != null),
        assert(web != null),
        assert(fuchsia != null),
        assert(linux != null);
}
