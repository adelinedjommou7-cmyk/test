// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:example/onboarding/presentation/onboarding_page.dart' as _i2;
import 'package:example/screens/niveau/niveau_page.dart' as _i1;
import 'package:flutter/material.dart' as _i4;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    NiveauRoute.name: (routeData) {
      final args = routeData.argsAs<NiveauRouteArgs>();
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.NiveauPage(
          key: args.key,
          child: args.child,
          shellContext: args.shellContext,
        ),
      );
    },
    OnboardingRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.OnboardingPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.NiveauPage]
class NiveauRoute extends _i3.PageRouteInfo<NiveauRouteArgs> {
  NiveauRoute({
    _i4.Key? key,
    required _i4.Widget child,
    required _i4.BuildContext? shellContext,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          NiveauRoute.name,
          args: NiveauRouteArgs(
            key: key,
            child: child,
            shellContext: shellContext,
          ),
          initialChildren: children,
        );

  static const String name = 'NiveauRoute';

  static const _i3.PageInfo<NiveauRouteArgs> page =
      _i3.PageInfo<NiveauRouteArgs>(name);
}

class NiveauRouteArgs {
  const NiveauRouteArgs({
    this.key,
    required this.child,
    required this.shellContext,
  });

  final _i4.Key? key;

  final _i4.Widget child;

  final _i4.BuildContext? shellContext;

  @override
  String toString() {
    return 'NiveauRouteArgs{key: $key, child: $child, shellContext: $shellContext}';
  }
}

/// generated route for
/// [_i2.OnboardingPage]
class OnboardingRoute extends _i3.PageRouteInfo<void> {
  const OnboardingRoute({List<_i3.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
