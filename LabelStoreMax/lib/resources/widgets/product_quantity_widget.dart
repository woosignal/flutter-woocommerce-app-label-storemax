//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProductQuantity extends StatefulWidget {
  const ProductQuantity({super.key});

  static String state = "product_quantity";

  @override
  createState() => _ProductQuantityState();
}

class _ProductQuantityState extends NyState<ProductQuantity> {
  int quantity = 1;

  _ProductQuantityState() {
    stateName = ProductQuantity.state;
  }

  @override
  stateUpdated(dynamic data) async {
    setState(() {
      quantity = data['quantity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      quantity.toString(),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
