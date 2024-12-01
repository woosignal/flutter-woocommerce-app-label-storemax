//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/cart_quantity_widget.dart';
import '/resources/widgets/product_quantity_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/product_variation.dart'
    as ws_product_variation;

import 'controller.dart';

class ProductDetailController extends Controller {
  int quantity = 1;
  Product? product;

  viewExternalProduct() {
    if (product?.externalUrl?.isNotEmpty ?? false) {
      openBrowserTab(url: product!.externalUrl!);
    }
  }

  itemAddToCart(
      {required CartLineItem cartLineItem, Function? onSuccess}) async {
    await Cart.getInstance.addToCart(cartLineItem: cartLineItem);
    showStatusAlert(
      context,
      title: trans("Success"),
      subtitle: trans("Added to cart"),
      duration: 1,
      icon: Icons.add_shopping_cart,
    );
    updateState(CartQuantity.state);
    if (onSuccess != null) {
      onSuccess();
    }
  }

  addQuantityTapped({Function? onSuccess}) {
    if (product?.manageStock == true) {
      if (quantity >= (product?.stockQuantity ?? 0)) {
        showToastNotification(context!,
            title: trans("Maximum quantity reached"),
            description:
                "${trans("Sorry, only")} ${product?.stockQuantity ?? "0"} ${trans("left")}",
            style: ToastNotificationStyleType.info);
        return;
      }
    }
    if (quantity != 0) {
      quantity++;
      if (onSuccess != null) {
        onSuccess();
      }
      updateState(ProductQuantity.state,
          data: {"product_id": product?.id, "quantity": quantity});
    }
  }

  removeQuantityTapped({Function? onSuccess}) {
    if ((quantity - 1) >= 1) {
      quantity--;
      if (onSuccess != null) {
        onSuccess();
      }
      updateState(ProductQuantity.state,
          data: {"product_id": product?.id, "quantity": quantity});
    }
  }

  ws_product_variation.ProductVariation? findProductVariation(
      {required Map<int, dynamic> tmpAttributeObj,
      required List<ws_product_variation.ProductVariation> productVariations}) {
    ws_product_variation.ProductVariation? tmpProductVariation;

    Map<String?, dynamic> tmpSelectedObj = {};
    for (var attributeObj in tmpAttributeObj.values) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    }

    for (var productVariation in productVariations) {
      Map<String?, dynamic> tmpVariations = {};

      for (var attr in productVariation.attributes) {
        tmpVariations[attr.name] = attr.option;
      }

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }
    }

    if (tmpProductVariation != null) {
      return tmpProductVariation;
    }

    // attempt to find product variation
    List<String> tmpKeys = [];
    for (var productVariation in productVariations) {
      for (var attr in productVariation.attributes) {
        String? attrName = attr.name;
        if (attrName == null) continue;
        tmpKeys.add(attrName);
      }
    }

    // Find matching product variation
    tmpSelectedObj.removeWhere((key, value) => !tmpKeys.contains(key));

    for (var productVariation in productVariations) {
      bool hasMatch = false;
      for (var attr in productVariation.attributes) {
        if (tmpSelectedObj[attr.name] == attr.option) {
          hasMatch = true;
        } else {
          hasMatch = false;
          break;
        }
      }

      if (hasMatch) {
        return productVariation;
      }
    }

    return null;
  }
}
