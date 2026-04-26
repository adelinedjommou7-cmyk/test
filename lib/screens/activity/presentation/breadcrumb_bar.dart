import 'package:example/screens/niveau/widget/image_widget.dart';
import 'package:example/screens/niveau/widget/responsive.dart';
import 'package:example/widgets/page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BreadcrumbBarPage extends StatefulWidget {
  const BreadcrumbBarPage({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<BreadcrumbBarPage> createState() => _BreadcrumbBarPageState();
}

class _BreadcrumbBarPageState extends State<BreadcrumbBarPage> with PageMixin {
  

  @override
  Widget build(BuildContext context) {
    List<StaggeredGridTile> items = [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/prescolaire.png',
            index: 0,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau1.png',
            index: 1,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau2.png',
            index: 2,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau3.png',
            index: 3,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau4.png',
            index: 4,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau5.png',
            index: 5,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau6.png',
            index: 6,
            onTap: () {
              setState(() {});
            }),
      ),
    ];
    List<StaggeredGridTile> item = [
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/prescolaire.png',
            index: 0,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau1.png',
            index: 1,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau2.png',
            index: 2,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau3.png',
            index: 3,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau4.png',
            index: 4,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau5.png',
            index: 5,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: ActivityWidget(
            pageController: widget.pageController,
            url: 'assets/images/niveau/niveau6.png',
            index: 6,
            onTap: () {
              setState(() {});
            }),
      ),
    ];
    const biggerSpacer = SizedBox(height: 40.0);

    return ScaffoldPage.scrollable(
      // header: const PageHeader(title: Text('Explorer, apprendre')),
      children: [
        biggerSpacer,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 30, bottom: 30),
              child: Responsive(
                mobile: Column(
                  children: [
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: items,
                    ),
                  ],
                ),
                tablet: Column(
                  children: [
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: items,
                    ),
                  ],
                ),
                desktop: Column(
                  children: [
                    StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: item,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

//         description(
//           content: const Text(
//             'The BreadcrumbBar control provides a commmon horizontal layout to '
//             'display the trail of navigation taken to the current location. '
//             'Resize to see the nodes crumble, starting at the root.',
//           ),
//         ),
//         subtitle(content: const Text('A BreadcrumbBar control')),
//         CardHighlight(
//           header: Row(children: [
//             const Expanded(child: Text('Source code')),
//             Button(
//               onPressed: resetItems,
//               child: const Text('Reset sample'),
//             ),
//           ]),
//           codeSnippet: '''final _items = <BreadcrumbItem<int>>[
//   BreadcrumbItem(label: Text('Home'), value: 0),
//   BreadcrumbItem(label: Text('Documents'), value: 1),
//   BreadcrumbItem(label: Text('Design'), value: 2),
//   BreadcrumbItem(label: Text('Northwind'), value: 3),
//   BreadcrumbItem(label: Text('Images'), value: 4),
//   BreadcrumbItem(label: Text('Folder1'), value: 5),
//   BreadcrumbItem(label: Text('Folder2'), value: 6),
//   BreadcrumbItem(label: Text('Folder3'), value: 7),
//   BreadcrumbItem(label: Text('Folder4'), value: 8),
//   BreadcrumbItem(label: Text('Folder5'), value: 9),
//   BreadcrumbItem(label: Text('Folder6'), value: 10),
// ];

// BreadcrumbBar<int>(
//   items: _items,
//   onItemPressed: (item) {
//     setState(() {
//       final index = _items.indexOf(item);
//       _items.removeRange(index + 1, _items.length);
//     });
//   },
// ),''',
//           child: BreadcrumbBar<int>(
//             onItemPressed: (item) {
//               setState(() {
//                 final index = _items.indexOf(item);
//                 _items.removeRange(index + 1, _items.length);
//               });
//             },
//             items: _items,
//           ),
//         ),
      ],
    );
  }
}
