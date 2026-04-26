import 'package:example/screens/niveau/niveau_page.dart';
import 'package:example/screens/theming/icons.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as m;
import 'package:example/keys/licence_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LicenseErrorScreen extends ConsumerStatefulWidget {
  const LicenseErrorScreen({super.key});

  @override
  _LicenseErrorScreenState createState() => _LicenseErrorScreenState();
}

final indexPage = StateProvider<int>((ref) => 0);

class _LicenseErrorScreenState extends ConsumerState<LicenseErrorScreen> {
  final _licenseManager = LicenseManager();
  final _formKey = GlobalKey<FormState>();
  final _newLicenseKeyController = TextEditingController();

  @override
  void dispose() {
    _newLicenseKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  elevation: 4,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Votre licence a expiré !',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Veuillez saisir une nouvelle clé de licence pour continuer.',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _newLicenseKeyController,
                            decoration: const InputDecoration(
                              labelText: 'Nouvelle clé de licence',
                            ),
                            style: m.FluentTheme.of(context)
                                .typography
                                .title
                                ?.copyWith(fontSize: 12),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir une clé de licence valide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40.0),
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String newLicenseKey =
                                    _newLicenseKeyController.text;

                                if (_licenseManager.isValid(newLicenseKey)) {
                                  // Set the new license key and expiration date (replace with actual values)
                                  await _licenseManager
                                      .setLicense(newLicenseKey);
                                  //DateTime.now().add(const Duration(days: 30))
                                  // Navigate back to the main screen or reload the app
                                  if (_licenseManager.isLicenseValid(ref)) {
                                    Navigator.pop(context);
                                    const transitionDuration =
                                        Duration(milliseconds: 100);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration: transitionDuration,
                                        reverseTransitionDuration:
                                            transitionDuration,
                                        pageBuilder: (_, animation, ___) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: NiveauPage(
                                              shellContext: context,
                                              child: Container(),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                } else {
                                  showSnackbar(context,
                                      'La clé de license semble invalide ou a déjà expiré');
                                }
                              }
                            },
                            child: const Text('Activer la nouvelle clé'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:example/keys/licence_manager.dart';
// import 'package:fluent_ui/fluent_ui.dart' as m;
// import 'package:flutter/material.dart';

// class LicenseErrorScreen extends StatefulWidget {
//   const LicenseErrorScreen({super.key});

//   @override
//   _LicenseErrorScreenState createState() => _LicenseErrorScreenState();
// }

// class _LicenseErrorScreenState extends State<LicenseErrorScreen> {
//   final _licenseManager = LicenseManager();
//   final _formKey = GlobalKey<FormState>();
//   final _newLicenseKeyController = TextEditingController();

//   @override
//   void dispose() {
//     _newLicenseKeyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding:
//               const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.6,
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: Card(
//                   elevation: 4,
//                   child: Form(
//                     key: _formKey,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Votre licence a expiré !',
//                             style: TextStyle(
//                                 fontSize: 20.0, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 20.0),
//                           const Text(
//                             'Veuillez saisir une nouvelle clé de licence pour continuer.',
//                             style: TextStyle(fontSize: 14.0),
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _newLicenseKeyController,
//                             decoration: const InputDecoration(
//                               labelText: 'Nouvelle clé de licence',
//                             ),
//                             style: m.FluentTheme.of(context)
//                                 .typography
//                                 .title
//                                 ?.copyWith(fontSize: 12),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Veuillez saisir une clé de licence valide';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 40.0),
//                           FilledButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 String newLicenseKey =
//                                     _newLicenseKeyController.text;
//                                 // Set the new license key and expiration date (replace with actual values)
//                                 _licenseManager.setLicense(
//                                     newLicenseKey,
//                                     DateTime.now()
//                                         .add(const Duration(days: 30)));

//                                 // Navigate back to the main screen or reload the app
//                                 Navigator.pop(context);
//                               }
//                             },
//                             child: const Text('Activer la nouvelle clé'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
