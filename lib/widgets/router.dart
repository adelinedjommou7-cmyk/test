import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/home/presentation/home_main.dart';
import 'package:example/widgets/deferred_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../screens/settings.dart';
import '../screens/splash/splash_page.dart';
import '../routes/forms.dart' deferred as forms;
import '../routes/inputs.dart' deferred as inputs;
import '../routes/navigation.dart' deferred as navigation;
import '../routes/popups.dart' deferred as popups;
import '../routes/surfaces.dart' deferred as surfaces;
import '../routes/theming.dart' deferred as theming;

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return SplashPage(
        shellContext: _shellNavigatorKey.currentContext,
        child: child,
      );
      // return MyHomePage(
      //     // shellContext: _shellNavigatorKey.currentContext,
      //     // child: child,
      //     );
    },
    routes: [
      /// Home
      GoRoute(path: '/', builder: (context, state) => const HomeMainPage()),

      /// Settings
      GoRoute(path: '/settings', builder: (context, state) => const Settings()),

      /// /// Input
      /// Buttons
      GoRoute(
        path: '/category/activite_en_ligne',
        builder: (context, state) => DeferredWidget(
          inputs.loadLibrary,
          () => inputs.ButtonPage(),
        ),
      ),

      /// Checkbox
      GoRoute(
        path: '/category/b_projet_stim',
        builder: (context, state) => DeferredWidget(
          inputs.loadLibrary,
          () => inputs.CheckBoxPage(),
        ),
      ),

      /// Slider
      GoRoute(
        path: '/category/fiche_activite',
        builder: (context, state) => DeferredWidget(
          inputs.loadLibrary,
          () => inputs.SliderPage(),
        ),
      ),

      /// ToggleSwitch
      GoRoute(
        path: '/category/jeu_en_ligne',
        builder: (context, state) => DeferredWidget(
          inputs.loadLibrary,
          () => inputs.ToggleSwitchPage(),
        ),
      ),

      /// /// Form
      /// TextBox
      GoRoute(
        path: '/category/historiq_perso',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.TextBoxPage(),
        ),
      ),

      /// AutoSuggestBox
      GoRoute(
        path: '/category/material_class',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.AutoSuggestBoxPage(),
        ),
      ),

      /// ComboBox
      GoRoute(
        path: '/forms/combobox',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.ComboBoxPage(),
        ),
      ),

      /// NumberBox
      GoRoute(
        path: '/forms/numberbox',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.NumberBoxPage(),
        ),
      ),

      GoRoute(
        path: '/forms/passwordbox',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.PasswordBoxPage(),
        ),
      ),

      /// TimePicker
      GoRoute(
        path: '/forms/time_picker',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.TimePickerPage(),
        ),
      ),

      /// DatePicker
      GoRoute(
        path: '/forms/date_picker',
        builder: (context, state) => DeferredWidget(
          forms.loadLibrary,
          () => forms.DatePickerPage(),
        ),
      ),

      /// /// Navigation
      /// NavigationView
      GoRoute(
        path: '/navigation/navigation_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
          () => navigation.NavigationViewPage(),
        ),
      ),
      GoRoute(
        path: '/navigation_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
          () => navigation.NavigationViewShellRoute(),
        ),
      ),

      /// TabView
      GoRoute(
        path: '/navigation/tab_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
          () => navigation.TabViewPage(),
        ),
      ),

      /// TreeView
      GoRoute(
        path: '/navigation/tree_view',
        builder: (context, state) => DeferredWidget(
          navigation.loadLibrary,
          () => navigation.TreeViewPage(),
        ),
      ),

      // /// BreadcrumbBar
      // GoRoute(
      //   path: '/navigation/breadcrumb_bar',
      //   builder: (context, state) => DeferredWidget(
      //     navigation.loadLibrary,
      //     () => navigation.BreadcrumbBarPage(),
      //   ),
      // ),

      /// /// Surfaces
      /// Acrylic
      GoRoute(
        path: '/surfaces/acrylic',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.AcrylicPage(),
        ),
      ),

      /// CommandBar
      GoRoute(
        path: '/surfaces/command_bar',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.CommandBarsPage(),
        ),
      ),

      /// Expander
      GoRoute(
        path: '/surfaces/expander',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.ExpanderPage(),
        ),
      ),

      /// InfoBar
      GoRoute(
        path: '/surfaces/info_bar',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.InfoBarsPage(),
        ),
      ),

      /// Progress Indicators
      GoRoute(
        path: '/surfaces/progress_indicators',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.ProgressIndicatorsPage(),
        ),
      ),

      /// Tiles
      GoRoute(
        path: '/surfaces/tiles',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => surfaces.TilesPage(),
        ),
      ),

      /// Popups
      /// ContentDialog
      GoRoute(
        path: '/popups/content_dialog',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => popups.ContentDialogPage(),
        ),
      ),

      /// Tooltip
      GoRoute(
        path: '/popups/tooltip',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => popups.TooltipPage(),
        ),
      ),

      /// Flyout
      GoRoute(
        path: '/popups/flyout',
        builder: (context, state) => DeferredWidget(
          surfaces.loadLibrary,
          () => popups.Flyout2Screen(),
        ),
      ),

      /// /// Theming
      /// Colors
      GoRoute(
        path: '/theming/colors',
        builder: (context, state) => DeferredWidget(
          theming.loadLibrary,
          () => theming.ColorsPage(),
        ),
      ),

      /// Typography
      GoRoute(
        path: '/theming/typography',
        builder: (context, state) => DeferredWidget(
          theming.loadLibrary,
          () => theming.TypographyPage(),
        ),
      ),

      /// Icons
      GoRoute(
        path: '/theming/icons',
        builder: (context, state) => DeferredWidget(
          theming.loadLibrary,
          () => theming.IconsPage(),
        ),
      ),

      /// Reveal Focus
      GoRoute(
        path: '/theming/reveal_focus',
        builder: (context, state) => DeferredWidget(
          theming.loadLibrary,
          () => theming.RevealFocusPage(),
        ),
      ),
    ],
  ),
]);
