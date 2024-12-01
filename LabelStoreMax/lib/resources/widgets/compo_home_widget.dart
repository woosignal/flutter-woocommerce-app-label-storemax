//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '/resources/widgets/store_logo_widget.dart';
import '/resources/widgets/notification_icon_widget.dart';
import '/resources/widgets/product_item_container_widget.dart';
import '/resources/pages/browse_category_page.dart';
import '/resources/pages/product_detail_page.dart';
import 'package:woosignal/models/response/product_category_collection.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/app_loader_widget.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/cached_image_widget.dart';
import '/resources/widgets/home_drawer_widget.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/product_category.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product.dart';

class CompoHomeWidget extends StatefulWidget {
  const CompoHomeWidget({super.key, required this.wooSignalApp});

  final WooSignalApp? wooSignalApp;

  @override
  createState() => _CompoHomeWidgetState();
}

class _CompoHomeWidgetState extends NyState<CompoHomeWidget> {
  @override
  get init => () async {
        await _loadHome();
      };

  _loadHome() async {
    if ((widget.wooSignalApp?.productCategoryCollections ?? []).isNotEmpty) {
      List<int> productCategoryId = widget
              .wooSignalApp?.productCategoryCollections
              .map((e) => int.parse(e.collectionId!))
              .toList() ??
          [];
      categories = await (appWooSignal((api) => api.getProductCategories(
          parent: 0,
          perPage: 50,
          hideEmpty: true,
          include: productCategoryId)));
      categories.sort((category1, category2) {
        ProductCategoryCollection? productCategoryCollection1 =
            widget.wooSignalApp?.productCategoryCollections.firstWhereOrNull(
                (element) => element.collectionId == category1.id.toString());
        ProductCategoryCollection? productCategoryCollection2 =
            widget.wooSignalApp?.productCategoryCollections.firstWhereOrNull(
                (element) => element.collectionId == category2.id.toString());

        if (productCategoryCollection1 == null) return 0;
        if (productCategoryCollection2 == null) return 0;

        if (productCategoryCollection1.position == null) return 0;
        if (productCategoryCollection2.position == null) return 0;

        return productCategoryCollection1.position!
            .compareTo(productCategoryCollection2.position!);
      });
    } else {
      categories = await (appWooSignal((api) =>
          api.getProductCategories(parent: 0, perPage: 50, hideEmpty: true)));
      categories.sort((category1, category2) =>
          category1.menuOrder!.compareTo(category2.menuOrder!));
    }

    for (var category in categories) {
      List<Product> products = await (appWooSignal(
        (api) => api.getProducts(
          perPage: 10,
          category: category.id.toString(),
          status: "publish",
          stockStatus: "instock",
        ),
      ));
      if (products.isNotEmpty) {
        categoryAndProducts.addAll({category: products});
      }
    }
  }

  List<ProductCategory> categories = [];
  Map<ProductCategory, List<Product>> categoryAndProducts = {};

  @override
  Widget view(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> bannerImages = widget.wooSignalApp?.bannerImages ?? [];
    return Scaffold(
      drawer: HomeDrawerWidget(
          wooSignalApp: widget.wooSignalApp, productCategories: categories),
      appBar: AppBar(
        centerTitle: true,
        title: StoreLogo(),
        actions: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: NotificationIcon(),
          )),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: categoryAndProducts.isEmpty
            ? AppLoaderWidget()
            : ListView(
                shrinkWrap: true,
                children: [
                  if (bannerImages.isNotEmpty)
                    SizedBox(
                      height: size.height / 2.5,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return CachedImageWidget(
                            image: bannerImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                        itemCount: bannerImages.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      ),
                    ),
                  ...categoryAndProducts.entries.map((catProds) {
                    double containerHeight = size.height / 1.1;
                    bool hasImage = catProds.key.image != null;
                    if (hasImage == false) {
                      containerHeight = (containerHeight / 2);
                    }
                    return Container(
                      height: containerHeight,
                      width: size.width,
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          if (hasImage)
                            InkWell(
                              child: CachedImageWidget(
                                image: catProds.key.image!.src,
                                height: containerHeight / 2,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              onTap: () => _showCategory(catProds.key),
                            ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 50,
                              minWidth: double.infinity,
                              maxHeight: 80.0,
                              maxWidth: double.infinity,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      parseHtmlString(catProds.key.name!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      width: size.width / 4,
                                      child: LinkButton(
                                        title: trans("View All"),
                                        action: () =>
                                            _showCategory(catProds.key),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: hasImage
                                ? (containerHeight / 2) / 1.2
                                : containerHeight / 1.2,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: false,
                              itemBuilder: (cxt, i) {
                                Product product = catProds.value[i];
                                return SizedBox(
                                  height: MediaQuery.of(cxt).size.height,
                                  width: size.width / 2.5,
                                  child: ProductItemContainer(
                                      product: product,
                                      onTap: () => _showProduct(product)),
                                );
                              },
                              itemCount: catProds.value.length,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  _showCategory(ProductCategory productCategory) {
    routeTo(BrowseCategoryPage.path, data: productCategory);
  }

  _showProduct(Product product) =>
      routeTo(ProductDetailPage.path, data: product);
}
