import 'dart:io';
import 'package:example/widgets/preference_helper.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> getGameDataDirectory() async {
  Directory dir;
  String? parentPath;

  if (Platform.isMacOS) {
    dir = await getApplicationDocumentsDirectory();
    parentPath = removeDocumentsDirectoryIOS(dir.path);
  } else if (Platform.isWindows) {
    dir = await getApplicationDocumentsDirectory();
    parentPath = removeDocumentsDirectory(dir.path);
  } else {
    throw UnsupportedError("Ce système d'exploitation n'est pas supporté");
  }
  //just to write some thing and push the code

  String gameDataDir = path.join(parentPath, 'html');
  // Créez le répertoire s'il n'existe pas
  Directory(gameDataDir).create(recursive: true);
  return gameDataDir;

  /* try {
                  final tmpFile = '${tmpPath()}.txt';
                  await File(tmpFile).writeAsString('Hello world!');
                  await _openFileMacosPlugin.open(tmpFile);
                } catch (err) {
                  print(err);
                } */
}

String removeDocumentsDirectoryIOS(String originalPath) {
  // Utilise la méthode `split` pour diviser le chemin en segments
  List<String> pathSegments = path.split(originalPath);

  // Filtre les segments pour supprimer "Documents"
  List<String> filteredSegments =
      pathSegments.where((segment) => segment != 'Documents').toList();

  // Recompose le chemin sans le segment "Documents"
  String newPath = path.joinAll(filteredSegments);

  return newPath;
}

String removeDocumentsDirectory(String originalPath) {
  // Utilise la méthode `split` pour diviser le chemin en segments
  List<String> pathSegments = path.split(originalPath);

  // Filtre les segments pour supprimer "Documents"
  List<String> filteredSegments =
      pathSegments.where((segment) => segment != 'Documents').toList();

  // Recompose le chemin sans le segment "Documents"
  String newPath = path.joinAll(filteredSegments);

  return newPath;
}

Future<void> readGameFiles() async {
  try {
    String htmlDataDir = await getGameDataDirectory();
    CashHelper.saveData(key: 'html', value: htmlDataDir);

    String pdfDataDir = await getGameDataDirectory();
    CashHelper.saveData(key: 'pdf', value: pdfDataDir);

    // List all files in the game data directory
    Directory dir = Directory(htmlDataDir);
    // openScriptDirectory(dir);
    startHttpServer(dir);
  } catch (e) {
    print('Erreur lors de la lecture des fichiers de jeu: $e');
  }
}

void openScriptDirectory(Directory dir) async {
  if (Platform.isMacOS) {
    await Process.run('open', [dir.path]);
  } else if (Platform.isWindows) {
    await Process.run('explorer', [dir.path]);
  }
}

void openTerminal(Directory dir) {
  final directoryPath = dir.path;
  if (Platform.isWindows) {
    // Process.start('cmd.exe', ['/c', 'start powershell']);
    Process.start('powershell', ['-NoExit', 'cd', directoryPath]);
  } else if (Platform.isMacOS) {
    Process.start('open', ['-a', 'Terminal', directoryPath]);
    // Process.start(
    //   'open',
    //   ['-a', 'Terminal'],
    //   workingDirectory: directoryPath,
    // );
  }
}

String appDocPath = '';
HttpServer? _activeHttpServer;

Future<void> startHttpServer(Directory dir) async {
  appDocPath = dir.path;

  if (_activeHttpServer != null) {
    await _activeHttpServer!.close(force: true);
    _activeHttpServer = null;
  }

  try {
    _activeHttpServer = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      8080,
      shared: true,
    );

    _activeHttpServer!.listen((HttpRequest request) async {
      try {
        String requestPath = Uri.decodeFull(request.uri.path);
        if (requestPath.startsWith('/')) requestPath = requestPath.substring(1);
        if (requestPath.isEmpty || requestPath.endsWith('/')) {
          requestPath += 'index.html';
        }

        final filePath = path.join(dir.path, requestPath);
        File file = File(filePath);

        // Si le chemin est un répertoire sans slash final → redirect 301
        // (sinon les chemins relatifs du jeu se résolvent dans le mauvais dossier)
        if (!await file.exists() && await Directory(filePath).exists()) {
          request.response.statusCode = HttpStatus.movedPermanently;
          request.response.headers
              .set('Location', '/$requestPath/');
          await request.response.close();
          return;
        }

        // Si le fichier n'existe pas, tenter index.html dans le répertoire
        if (!await file.exists()) {
          final dirIndex = File(path.join(filePath, 'index.html'));
          if (await dirIndex.exists()) file = dirIndex;
        }

        // Headers requis pour les jeux Construct 3 (ES modules, WASM, SharedArrayBuffer)
        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.add('Cross-Origin-Opener-Policy', 'same-origin');
        request.response.headers.add('Cross-Origin-Embedder-Policy', 'require-corp');

        if (await file.exists()) {
          request.response.headers.contentType = _getContentType(file.path);
          await file.openRead().pipe(request.response);
        } else {
          if (kDebugMode) print('404: $filePath');
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
        }
      } catch (_) {
        try {
          request.response.statusCode = HttpStatus.internalServerError;
          await request.response.close();
        } catch (_) {}
      }
    });

    if (kDebugMode) {
      print('Serveur HTTP démarré sur http://localhost:8080');
      print('Document root: ${dir.path}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur démarrage serveur HTTP: $e');
    }
  }
}

ContentType _getContentType(String filePath) {
  switch (path.extension(filePath).toLowerCase()) {
    case '.html': return ContentType.html;
    case '.js':
    case '.mjs': return ContentType('application', 'javascript');
    case '.css': return ContentType('text', 'css');
    case '.json': return ContentType.json;
    case '.png': return ContentType('image', 'png');
    case '.jpg':
    case '.jpeg': return ContentType('image', 'jpeg');
    case '.gif': return ContentType('image', 'gif');
    case '.svg': return ContentType('image', 'svg+xml');
    case '.wasm': return ContentType('application', 'wasm');
    case '.woff': return ContentType('font', 'woff');
    case '.woff2': return ContentType('font', 'woff2');
    case '.ico': return ContentType('image', 'x-icon');
    default: return ContentType.binary;
  }
}

bool get isServerActive => _activeHttpServer != null;

Future<bool> isServerRunning(String url) async {
  return _activeHttpServer != null;
}
