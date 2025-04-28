import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/helpers/is_dark_mode.dart';
import 'package:notspotify/common/widgets/appbar/basic_app_bar.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BasicAppBar(
          hideBack: true,
          title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_homeTopCard(), _tabs()],
          ),
        ),
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 188,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(AppImages.obito, height: 250, width: 250),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: Colors.green,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      tabAlignment: TabAlignment.center,
      tabs: [
        const Text(
          'Recommend Songs',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Text(
          'Recently Played',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }
}
