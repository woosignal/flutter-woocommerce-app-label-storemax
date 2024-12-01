//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:wp_json_api/wp_json_api.dart';
import '/app/models/bottom_nav_item.dart';
import '/bootstrap/app_helper.dart';
import '/resources/pages/account_detail_page.dart';
import '/resources/pages/account_login_page.dart';
import '/resources/pages/cart_page.dart';
import '/resources/pages/wishlist_page_widget.dart';
import '/resources/pages/home_search_page.dart';
import '/resources/widgets/app_loader_widget.dart';
import '/resources/widgets/compo_home_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class CompoThemeWidget extends StatefulWidget {
  const CompoThemeWidget({super.key, required this.wooSignalApp});
  final WooSignalApp? wooSignalApp;

  @override
  CompoThemeWidgetState createState() => CompoThemeWidgetState();
}

class CompoThemeWidgetState extends State<CompoThemeWidget> {
  Widget? activeWidget;

  int _currentIndex = 0;
  List<BottomNavItem> allNavWidgets = [];

  @override
  void initState() {
    super.initState();

    activeWidget = CompoHomeWidget(wooSignalApp: widget.wooSignalApp);
    _loadTabs();
  }

  _loadTabs() async {
    allNavWidgets = await bottomNavWidgets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeWidget,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: allNavWidgets.isEmpty
          ? AppLoaderWidget()
          : BottomNavigationBar(
              onTap: (currentIndex) =>
                  _changeMainWidget(currentIndex, allNavWidgets),
              currentIndex: _currentIndex,
              unselectedItemColor: Colors.black54,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.black87,
              selectedLabelStyle: TextStyle(color: Colors.black),
              unselectedLabelStyle: TextStyle(
                color: Colors.black87,
              ),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items:
                  allNavWidgets.map((e) => e.bottomNavigationBarItem).toList(),
            ),
    );
  }

  Future<List<BottomNavItem>> bottomNavWidgets() async {
    List<BottomNavItem> items = [];
    items.add(
      BottomNavItem(
          id: 1,
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'.tr(),
          ),
          tabWidget: CompoHomeWidget(wooSignalApp: widget.wooSignalApp)),
    );

    items.add(
      BottomNavItem(
          id: 2,
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search'.tr(),
          ),
          tabWidget: HomeSearchPage()),
    );

    if (AppHelper.instance.appConfig!.wishlistEnabled == true) {
      items.add(BottomNavItem(
        id: 3,
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Wishlist'.tr(),
        ),
        tabWidget: WishListPageWidget(),
      ));
    }

    items.add(BottomNavItem(
      id: 4,
      bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), label: 'Cart'.tr()),
      tabWidget: CartPage(),
    ));

    if (AppHelper.instance.appConfig?.wpLoginEnabled == 1) {
      items.add(BottomNavItem(
        id: 5,
        bottomNavigationBarItem: BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Account'.tr()),
        tabWidget: (await WPJsonAPI.wpUserLoggedIn())
            ? AccountDetailPage(showLeadingBackButton: false)
            : AccountLoginPage(
                showBackButton: false,
              ),
      ));
    }
    return items;
  }

  _changeMainWidget(
      int currentIndex, List<BottomNavItem> bottomNavWidgets) async {
    _currentIndex = currentIndex;
    activeWidget = bottomNavWidgets[_currentIndex].tabWidget;
    setState(() {});
  }
}
