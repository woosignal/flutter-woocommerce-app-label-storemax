//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:io';

import 'package:wp_json_api/models/wp_user.dart';
import 'package:wp_json_api/wp_json_api.dart';

import '/app/models/billing_details.dart';
import '/app/models/cart.dart';
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

Future<OrderWC> buildOrderWC({TaxRate? taxRate, bool markPaid = true}) async {
  CheckoutSession checkoutSession = CheckoutSession.getInstance;
  OrderWC orderWC = OrderWC();
  WooSignalApp wooSignalApp = AppHelper.instance.appConfig!;

  String paymentMethodName = checkoutSession.paymentType!.name;

  orderWC.paymentMethod = Platform.isAndroid
      ? "$paymentMethodName - Android App"
      : "$paymentMethodName - IOS App";

  orderWC.paymentMethodTitle = paymentMethodName.toLowerCase();

  orderWC.setPaid = markPaid;
  orderWC.status = "pending";
  orderWC.currency = wooSignalApp.currencyMeta!.code!.toUpperCase();
  WpUser? wpUser = await WPJsonAPI.wpUser();
  if (wpUser != null && wooSignalApp.wpLoginEnabled == 1) {
    orderWC.customerId = int.parse(wpUser.id.toString());
  }

  List<LineItems> lineItems = [];
  List<CartLineItem> cartItems = await Cart.getInstance.getCart();
  for (var cartItem in cartItems) {
    LineItems tmpLineItem = LineItems();
    tmpLineItem.quantity = cartItem.quantity;
    tmpLineItem.name = cartItem.name;
    tmpLineItem.productId = cartItem.productId;
    if (cartItem.variationId != null && cartItem.variationId != 0) {
      tmpLineItem.variationId = cartItem.variationId;
    }

    tmpLineItem.subtotal = (parseWcPrice(cartItem.subtotal) *
            parseWcPrice(cartItem.quantity.toString()))
        .toString();
    lineItems.add(tmpLineItem);
  }

  orderWC.lineItems = lineItems;

  BillingDetails billingDetails = checkoutSession.billingDetails!;

  Billing billing = Billing();
  billing.firstName = billingDetails.billingAddress?.firstName;
  billing.lastName = billingDetails.billingAddress?.lastName;
  billing.address1 = billingDetails.billingAddress?.addressLine;
  billing.city = billingDetails.billingAddress?.city;
  billing.postcode = billingDetails.billingAddress?.postalCode;
  billing.email = billingDetails.billingAddress?.emailAddress;
  if (billingDetails.billingAddress?.phoneNumber != "") {
    billing.phone = billingDetails.billingAddress?.phoneNumber;
  }
  if (billingDetails.billingAddress?.customerCountry?.hasState() ?? false) {
    billing.state = billingDetails.billingAddress?.customerCountry!.state!.name;
  }
  billing.country = billingDetails.billingAddress?.customerCountry!.name;

  orderWC.billing = billing;

  Shipping shipping = Shipping();

  shipping.firstName = billingDetails.shippingAddress?.firstName;
  shipping.lastName = billingDetails.shippingAddress?.lastName;
  shipping.address1 = billingDetails.shippingAddress?.addressLine;
  shipping.city = billingDetails.shippingAddress?.city;
  shipping.postcode = billingDetails.shippingAddress?.postalCode;
  if (billingDetails.shippingAddress?.customerCountry?.hasState() ?? false) {
    shipping.state =
        billingDetails.shippingAddress?.customerCountry?.state?.name;
  }
  shipping.country = billingDetails.shippingAddress?.customerCountry?.name;

  orderWC.shipping = shipping;

  orderWC.shippingLines = [];
  if (wooSignalApp.disableShipping != 1) {
    Map<String, dynamic>? shippingLineFeeObj =
        checkoutSession.shippingType!.toShippingLineFee();
    if (shippingLineFeeObj != null) {
      ShippingLines shippingLine = ShippingLines();
      shippingLine.methodId = shippingLineFeeObj['method_id'];
      shippingLine.methodTitle = shippingLineFeeObj['method_title'];
      shippingLine.total = shippingLineFeeObj['total'];
      orderWC.shippingLines!.add(shippingLine);
    }
  }

  if (taxRate != null) {
    orderWC.feeLines = [];
    FeeLines feeLines = FeeLines();
    feeLines.name = taxRate.name;
    feeLines.total = await Cart.getInstance.taxAmount(taxRate);
    feeLines.taxClass = "";
    feeLines.taxStatus = "taxable";
    orderWC.feeLines!.add(feeLines);
  }

  if (checkoutSession.coupon != null) {
    orderWC.couponLines = [];
    CouponLines couponLine = CouponLines(code: checkoutSession.coupon!.code);
    orderWC.couponLines!.add(couponLine);
  }

  if (checkoutSession.customerNote?.isNotEmpty ?? false) {
    orderWC.customerNote = checkoutSession.customerNote;
  }

  return orderWC;
}
