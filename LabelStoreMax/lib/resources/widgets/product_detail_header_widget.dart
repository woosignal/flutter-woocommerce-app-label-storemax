//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/bootstrap/helpers.dart';
import 'package:woosignal/models/response/product.dart';

class ProductDetailHeaderWidget extends StatelessWidget {
  const ProductDetailHeaderWidget({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Text(
              product?.name ?? "",
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatStringCurrency(total: product?.price),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 20,
                      ),
                  textAlign: TextAlign.right,
                ),
                if (product?.onSale == true && product?.type != "variable")
                  Text(
                    formatStringCurrency(total: product?.regularPrice),
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
