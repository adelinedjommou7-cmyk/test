import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/link.dart';

class LinkPaneItemAction extends PaneItem {
  LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build({
    bool? autofocus,
    required BuildContext context,
    int depth = 0,
    required PaneDisplayMode? displayMode,
    required int itemIndex,
    required VoidCallback? onPressed,
    required bool selected,
    bool showTextOnTop = false,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => Semantics(
        link: true,
        child: super.build(
          autofocus: autofocus,
          context: context,
          depth: depth,
          displayMode: displayMode,
          itemIndex: itemIndex,
          onPressed: followLink,
          selected: selected,
          showTextOnTop: showTextOnTop,
        ),
      ),
    );
  }
}
