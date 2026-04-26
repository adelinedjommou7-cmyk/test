import 'package:example/provider/providers.dart';
import 'package:example/screens/home/presentation/favorite_page.dart';
import 'package:example/screens/home/presentation/home.dart';
import 'package:example/screens/home/presentation/ressources.dart';
import 'package:example/screens/home/presentation/search_activity_page.dart';
import 'package:example/widgets/helper.dart';
import 'package:example/widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({
    super.key,
  });

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends ConsumerState<HomeMainPage>
    with PageMixin, SingleTickerProviderStateMixin {
  List<BreadcrumbItem<int>> items = <BreadcrumbItem<int>>[
    const BreadcrumbItem(label: Text('Activité en ligne'), value: 0),
    // BreadcrumbItem(label: Text('Documents'), value: 1),
    // BreadcrumbItem(label: Text('Design'), value: 2),
  ];
  List<BreadcrumbItem<int>> _items = [];

  late PageController pageController;
  late AnimationController animationController;
  int index = 0;

  @override
  void initState() {
    super.initState();

    _items = items.toList();

    pageController =
        PageController(viewportFraction: 1, keepPage: true, initialPage: index);

    pageController.addListener(() {
      setState(() {
        // currentPageValue = controller.page;
        print(pageController.page);
      });
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 650),
        vsync: this,
        reverseDuration: const Duration(milliseconds: 400));
  }

  void resetItems() {
    setState(() => _items = items.toList());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> subPages = [
      HomePage(pageController: pageController),
      RessourcesPage(
        pageController: pageController,
        data: ref.watch(niveauNotifierProvider).result,
      ),
      Favorites(pageController: pageController),
      SearchActivityPage(
        pageController: pageController,
        data: ref.watch(allActivityNotifierProvider).result,
      )
    ];

    return ScaffoldPage(
      // header:
      //     const PageHeader(title: Text('Explorer et apprendre'), padding: 8),
      content: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            // BreadcrumbBar<int>(
            //   onItemPressed: (item) {
            //     setState(() {
            //       final indexHere = _items.indexOf(item);
            //       // print('indexHere : $indexHere');
            //       // print('_items : $index');
            //       _items.removeRange(indexHere.toInt() + 1, _items.length);
            //       pageController.animateToPage(
            //         indexHere,
            //         duration: const Duration(milliseconds: 300),
            //         curve: Curves.decelerate,
            //       );
            //     });
            //   },
            //   items: _items,
            // ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                    // print('onPageChanged : $index');
                    if (_items.length >= 2) {
                      _items.removeRange(index, _items.length);
                    }
                    _items.add(BreadcrumbItem(
                        label: Text(
                            convertLevel(ref.watch(downloadProvider).index)),
                        value: 1));
                  });
                },
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: subPages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
