import 'package:example/screens/home/presentation/home.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomGridview extends StatelessWidget {
  const CustomGridview({
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final CustomCardItem Function(dynamic context, dynamic index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsetsDirectional.only(
        start: PageHeader.horizontalPadding(context),
        end: PageHeader.horizontalPadding(context),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 290,
        crossAxisSpacing: 6,
        mainAxisSpacing: 10,
        mainAxisExtent: 270,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
