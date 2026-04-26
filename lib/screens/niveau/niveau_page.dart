import 'package:auto_route/auto_route.dart';
import 'package:example/audio/audio_manager.dart';
import 'package:example/keys/licence_manager.dart';
import 'package:example/keys/license_error_screen.dart';
import 'package:example/screens/niveau/widget/image_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'widget/app_style.dart';
import 'widget/responsive.dart';

@RoutePage()
class NiveauPage extends ConsumerStatefulWidget {
  const NiveauPage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  _NiveauPageState createState() => _NiveauPageState();
}

class _NiveauPageState extends ConsumerState<NiveauPage> {
  LicenseManager licenseManager = LicenseManager();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() async {
    licenseManager.init();
    // Add this line to override the default close handler
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // Adapt.init(context);
    double sizeH = SizeConfig.blockSizeH!;
    // double sizeV = SizeConfig.blockSizeV!;
    List<StaggeredGridTile> items = [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/prescolaire.png',
            index: 0,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau1.png',
            index: 1,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau2.png',
            index: 2,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau3.png',
            index: 3,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau4.png',
            index: 4,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau5.png',
            index: 5,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau6.png',
            index: 6,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
    ];
    List<StaggeredGridTile> item = [
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/prescolaire.png',
            index: 0,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau1.png',
            index: 1,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau2.png',
            index: 2,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau3.png',
            index: 3,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau4.png',
            index: 4,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau5.png',
            index: 5,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: ImageWidget(
            url: 'assets/images/niveau/niveau6.png',
            index: 6,
            shellContext: widget.shellContext,
            child: widget.child,
            onTap: () {
              setState(() {});
            }),
      ),
    ];
    return FutureBuilder<bool>(
      future: licenseManager.validateLicense(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const m.CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(50),
              // height: ScreenUtil().screenHeight,
              // width: ScreenUtil().screenWidth,
              child: SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      'Définissons ensemble le niveau d\'activité par défaut.',
                      style: kTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sizeH * 3,
                    ),
                    Responsive(
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
                  ],
                ),
              ),
            ),
          );
        } else {
          return const LicenseErrorScreen();
        }
      },
    );
  }
}
