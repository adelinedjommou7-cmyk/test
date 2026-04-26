// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:example/files/folders.dart';
import 'package:example/provider/providers.dart';
import 'package:example/widgets/card_highlight.dart';
import 'package:example/widgets/preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
import 'package:example/keys/licence_manager.dart';
import 'package:example/keys/core/infrastructure/encrypt_service.dart';
import 'package:example/widgets/helper.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme.dart';
import '../widgets/page.dart';

const _kSplitButtonHeight = 32.0;
const _kSplitButtonWidth = 36.0;
const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

const List<String> Niveau = [
  'Pré-scolaire',
  'Niveau 1',
  'Niveau 2',
  'Niveau 3',
  'Niveau 4',
  'Niveau 5',
  'Niveau 6',
];

bool get kIsWindowEffectsSupported {
  return !kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

const _LinuxWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.transparent,
];

const _WindowsWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.solid,
  WindowEffect.transparent,
  WindowEffect.aero,
  WindowEffect.acrylic,
  WindowEffect.mica,
  WindowEffect.tabbed,
];

const _MacosWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.titlebar,
  WindowEffect.selection,
  WindowEffect.menu,
  WindowEffect.popover,
  WindowEffect.sidebar,
  WindowEffect.headerView,
  WindowEffect.sheet,
  WindowEffect.windowBackground,
  WindowEffect.hudWindow,
  WindowEffect.fullScreenUI,
  WindowEffect.toolTip,
  WindowEffect.contentBackground,
  WindowEffect.underWindowBackground,
  WindowEffect.underPageBackground,
];

List<WindowEffect> get currentWindowEffects {
  if (kIsWeb) return [];

  if (defaultTargetPlatform == TargetPlatform.windows) {
    return _WindowsWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.linux) {
    return _LinuxWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    return _MacosWindowEffects;
  }

  return [];
}

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

final indexPage = StateProvider<int>((ref) => 0);

class _SettingsState extends ConsumerState<Settings> with PageMixin {
  final licenseManager = LicenseManager();
  bool? isNot = false;
  bool splitButtonDisabled = false;

  String path = '';

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      licenseManager.init();
      path = CashHelper.getData(key: 'html').toString();
    });
    super.initState();
  }

  AccentColor splitButtonColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final theme = FluentTheme.of(context);
    final appTheme = ref.watch(themeProvider);
    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
    final isThemeSet = CashHelper.getData(key: 'theme') ?? 1;

    final splitButtonFlyout = FlyoutContent(
      constraints: const BoxConstraints(maxWidth: 200.0),
      child: Wrap(
        runSpacing: 10.0,
        spacing: 8.0,
        children: Colors.accentColors.map((color) {
          return IconButton(
            autofocus: splitButtonColor == color,
            style: ButtonStyle(
              padding:WidgetStateProperty.all(const EdgeInsets.all(4.0)) 
            ),
            onPressed: () {
              setState(() => splitButtonColor = color);
              Navigator.of(context).pop(color);
            },
            icon: Container(
              height: _kSplitButtonHeight,
              width: _kSplitButtonHeight,
              color: color,
            ),
          );
        }).toList(),
      ),
    );

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Paramètres')),
      bottomBar: Builder(builder: (context) {
        final licenseKey =
            CashHelper.getData(key: 'licenseKey') as String? ?? '';

        if (licenseKey.isEmpty) {
          return const SizedBox(
            width: double.infinity,
            child: InfoBar(
              severity: InfoBarSeverity.warning,
              title: Text('Licence non activée'),
              content: Text('Aucune clé de licence enregistrée.'),
            ),
          );
        }

        try {
          final expiryDate = decryptMyData(licenseKey);
          final now = DateTime.now();
          final isValid = expiryDate.isAfter(now);
          final daysLeft = expiryDate.difference(now).inDays;
          final day = expiryDate.day.toString().padLeft(2, '0');
          final month = expiryDate.month.toString().padLeft(2, '0');
          final dateStr = '$day/$month/${expiryDate.year}';

          if (isValid) {
            return SizedBox(
              width: double.infinity,
              child: InfoBar(
                severity: InfoBarSeverity.success,
                title: const Text('Licence active'),
                content: Text(
                    'Seeva Education Premium — expire le $dateStr ($daysLeft jours restants)'),
              ),
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: InfoBar(
                severity: InfoBarSeverity.error,
                title: const Text('Licence expirée'),
                content:
                    Text('Votre licence a expiré le $dateStr.'),
              ),
            );
          }
        } catch (_) {
          return const SizedBox(
            width: double.infinity,
            child: InfoBar(
              severity: InfoBarSeverity.error,
              title: Text('Clé invalide'),
              content: Text(
                  'La clé de licence enregistrée est invalide ou corrompue.'),
            ),
          );
        }
      }),
      children: [
        Text('Mode thématique',
            style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ...List.generate(ThemeMode.values.length, (index) {
          final mode = ThemeMode.values[index];
          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: RadioGroup<ThemeMode>(
  groupValue: appTheme.mode,
  onChanged: (mode) {
    if (mode != null) {
      appTheme.mode = mode;
      CashHelper.saveData(
        key: 'theme',
        value: ThemeMode.values.indexOf(mode),
      );
      if (kIsWindowEffectsSupported) {
        appTheme.setEffect(appTheme.windowEffect, context);
      }
    }
  },
  child: RadioButton<ThemeMode>(
    value: mode,
    content: Text(convertModeTitle('$mode'.replaceAll('ThemeMode.', ''))),
  ),
),
            // child: RadioButton(
            //   checked: appTheme.mode == mode,
            //   onChanged: (value) {
            //     if (value) {
            //       appTheme.mode = mode;
            //       if (mode == ThemeMode.dark) {
            //         CashHelper.saveData(key: 'theme', value: index);
            //       } else {
            //         CashHelper.saveData(key: 'theme', value: index);
            //       }
            //       if (kIsWindowEffectsSupported) {
            //         // some window effects require on [dark] to look good.
            //         // appTheme.setEffect(WindowEffect.disabled, context);
            //         appTheme.setEffect(appTheme.windowEffect, context);
            //       }
            //     }
            //   },
            //   content:
            //       Text(convertModeTitle('$mode'.replaceAll('ThemeMode.', ''))),
            // ),
          );
        }),
        biggerSpacer,
        Text(
          'Mode d\'affichage du volet de navigation',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        spacer,
        ...List.generate(PaneDisplayMode.values.length, (index) {
          final mode = PaneDisplayMode.values[index];
          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: RadioGroup<PaneDisplayMode>(
              groupValue: appTheme.displayMode,
              onChanged: (mode) {
                if (mode != null) {
                  appTheme.displayMode = mode;
                }
              },
              child: RadioButton<PaneDisplayMode>(
                value: mode,
                content: Text(
                  convertNavigatorTitle(
                    mode.toString().replaceAll('PaneDisplayMode.', ''),
                  ),
                ),
              ),
            ),
          );
        }),
        biggerSpacer,

        Text('Niveau par defaut',
            style: FluentTheme.of(context).typography.subtitle),
        spacer,
        Wrap(children: [
          ...List.generate(Niveau.length, (index) {
            final color = Colors.accentColors[index];
            return Tooltip(
              message: Niveau[index],
              child: _buildNiveau(appTheme, color, Niveau[index], index),
            );
          }),
        ]),
        biggerSpacer,
        Text(
          'Charger les ressources',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        spacer,
        CardHighlight(
          header: const Text('Chemin parent des ressources'),
          codeSnippet: CashHelper.getData(key: 'html').toString(),
          child: Row(children: [
            const Expanded(
              flex: 3,
              child: TextBox(
                enabled: false,
                placeholder: 'Consulter les ressources disponbile',
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 2,
              child: FilledButton(
                child: const Text('Consulter'),
                onPressed: () {
                  Directory dir = Directory(CashHelper.getData(key: 'html'));
                  openScriptDirectory(dir);
                },
              ),
            )
          ]),
        ),
        if (!isServerActive) ...[
          biggerSpacer,
          Text(
            'Demarrer le serveur',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          spacer,
          CardHighlight(
            header: const Text('Chemin parent du server'),
            codeSnippet: CashHelper.getData(key: 'html').toString(),
            child: Row(children: [
              const Expanded(
                flex: 3,
                child: TextBox(
                  enabled: false,
                  placeholder:
                      'Veuillez saisir http-server',
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 2,
                child: FilledButton(
                  child: const Text('Demarrer'),
                  onPressed: () {
                    Directory dir = Directory(CashHelper.getData(key: 'html'));
                    openTerminal(dir);
                  },
                ),
              )
            ]),
          ),
        ],

        biggerSpacer,

        // Text('Navigation Indicator',
        //     style: FluentTheme.of(context).typography.subtitle),
        // spacer,
        // ...List.generate(NavigationIndicators.values.length, (index) {
        //   final mode = NavigationIndicators.values[index];
        //   return Padding(
        //     padding: const EdgeInsetsDirectional.only(bottom: 8.0),
        //     child: RadioButton(
        //       checked: appTheme.indicator == mode,
        //       onChanged: (value) {
        //         if (value) appTheme.indicator = mode;
        //       },
        //       content: Text(
        //         mode.toString().replaceAll('NavigationIndicators.', ''),
        //       ),
        //     ),
        //   );
        // }),

        // if (kIsWindowEffectsSupported) ...[
        //   biggerSpacer,
        //   Text(
        //     'Window Transparency',
        //     style: FluentTheme.of(context).typography.subtitle,
        //   ),
        //   description(
        //     content: Text(
        //       'Running on ${defaultTargetPlatform.toString().replaceAll('TargetPlatform.', '')}',
        //     ),
        //   ),
        //   spacer,
        //   ...List.generate(currentWindowEffects.length, (index) {
        //     final mode = currentWindowEffects[index];
        //     return Padding(
        //       padding: const EdgeInsetsDirectional.only(bottom: 8.0),
        //       child: RadioButton(
        //         checked: appTheme.windowEffect == mode,
        //         onChanged: (value) {
        //           if (value) {
        //             appTheme.windowEffect = mode;
        //             appTheme.setEffect(mode, context);
        //           }
        //         },
        //         content: Text(
        //           mode.toString().replaceAll('WindowEffect.', ''),
        //         ),
        //       ),
        //     );
        //   }),
        // ],
        // biggerSpacer,
        // Text(
        //   'Text Direction',
        //   style: FluentTheme.of(context).typography.subtitle,
        // ),
        // spacer,
        // ...List.generate(TextDirection.values.length, (index) {
        //   final direction = TextDirection.values[index];
        //   return Padding(
        //     padding: const EdgeInsetsDirectional.only(bottom: 8.0),
        //     child: RadioButton(
        //       checked: appTheme.textDirection == direction,
        //       onChanged: (value) {
        //         if (value) {
        //           appTheme.textDirection = direction;
        //         }
        //       },
        //       content: Text(
        //         '$direction'
        //             .replaceAll('TextDirection.', '')
        //             .replaceAll('rtl', 'Right to left')
        //             .replaceAll('ltr', 'Left to right'),
        //       ),
        //     ),
        //   );
        // }).reversed,
        // biggerSpacer,
        // Text('Locale', style: FluentTheme.of(context).typography.subtitle),
        // description(
        //   content: const Text(
        //     'The locale used by the fluent_ui widgets, such as TimePicker and '
        //     'DatePicker. This does not reflect the language of this showcase app.',
        //   ),
        // ),
        // spacer,
        // Wrap(
        //   spacing: 15.0,
        //   runSpacing: 10.0,
        //   children: List.generate(
        //     supportedLocales.length,
        //     (index) {
        //       final locale = supportedLocales[index];
        //       return Padding(
        //         padding: const EdgeInsetsDirectional.only(bottom: 8.0),
        //         child: RadioButton(
        //           checked: currentLocale == locale,
        //           onChanged: (value) {
        //             if (value) {
        //               appTheme.locale = locale;
        //             }
        //           },
        //           content: Text('$locale'),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  /// Alert dialog for save and export
  void displyDialog(String text) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return ContentDialog(
            title: const Text('Chemin parent'),
            content: SizedBox(
              width: 328.0,
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Text(text),
                ),
              ),
            ),
            actions: <Widget>[
              FilledButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text('D\'accord'),
              )
            ],
          );
        });
  }

  Widget _buildNiveau(
      AppTheme appTheme, AccentColor color, String niveau, int pos) {
    final index = CashHelper.getData(key: 'indexNiveau') ?? 0;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          // appTheme.color = color;
          CashHelper.saveData(key: 'indexNiveau', value: pos);
          ref.read(downloadProvider.notifier).setMenu(pos.toString());
          ref.read(downloadProvider.notifier).setMenuStat(pos.toString());
          ref
              .read(niveauNotifierProvider.notifier)
              .fetchRessource(niveau: convertLevel(pos.toString()));
          setState(() {});
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.isPressed) {
              return color.light;
            } else if (states.isHovered) {
              return color.lighter;
            }
            return color;
          }),
        ),
        child: Container(
            height: 40,
            width: 120,
            alignment: AlignmentDirectional.center,
            child: m.Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 4,
                ),
                Text(
                  niveau,
                  style: TextStyle(color: color.basedOnLuminance()),
                ),
                const SizedBox(
                  width: 4,
                ),
                if (Niveau.elementAt(index) == niveau)
                  Icon(
                    FluentIcons.check_mark,
                    color: color.basedOnLuminance(),
                    size: 22.0,
                  ),
              ],
            )),
      ),
    );
  }

  Widget _buildColorBlock(AppTheme appTheme, AccentColor color) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          appTheme.color = color;
        },
        style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.isPressed) {
              return color.light;
            } else if (states.isHovered) {
              return color.lighter;
            }
            return color;
          }),
        ),
        child: Container(
          height: 40,
          width: 40,
          alignment: AlignmentDirectional.center,
          child: appTheme.color == color
              ? Icon(
                  FluentIcons.check_mark,
                  color: color.basedOnLuminance(),
                  size: 22.0,
                )
              : null,
        ),
      ),
    );
  }
}
