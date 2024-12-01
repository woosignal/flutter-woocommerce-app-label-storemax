import '/resources/widgets/cart_quantity_widget.dart';
import '/resources/pages/cart_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/resources/widgets/shopping_cart_total_widget.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';

class CartRemoveItemEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    CartLineItem cartLineItem = event["cartLineItem"];
    bool complete = (await Cart.getInstance.removeCartItem(cartLineItem));
    if (complete != true) {
      return;
    }

    // update states
    updateState(CartPage.path, data: {"action": "showToastCartItemRemoved"});

    updateState(ShoppingCartTotal.state);
    NyListView.stateReset("shopping_cart_items_list_view");
    updateState(CartQuantity.state);
  }
}
