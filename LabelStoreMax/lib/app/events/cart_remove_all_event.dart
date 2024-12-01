import '/resources/pages/cart_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/resources/widgets/shopping_cart_total_widget.dart';
import '/app/models/cart.dart';

class CartRemoveAllEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    await Cart.getInstance.clear();

    // update states
    updateState(ShoppingCartTotal.state);
    NyListView.stateReset("shopping_cart_items_list_view");
    updateState(CartPage.path, data: {"action": "showToastCartCleared"});
  }
}
