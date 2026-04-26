import 'package:auto_route/auto_route.dart';
import 'package:example/routes/router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  final ProviderRef ref;

  AppRouter(this.ref);

  @override
  List<AutoRoute> get routes => [
        // AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
        // AutoRoute(page: WebViewRoute.page, path: '/webview'),
        // AutoRoute(page: CategoryRoute.page, path: '/category'),
        // AutoRoute(page: HomesRoute.page, initial: true, path: '/home'),
        AutoRoute(page: NiveauRoute.page, path: '/niveau'),
        // AutoRoute(page: HomeRoute.page, path: '/navigation'),
      ];
}
