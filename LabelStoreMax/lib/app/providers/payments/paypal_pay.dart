//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/bootstrap/paypal/paypal_checkout_view.dart';
import '/app/models/cart.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import '/bootstrap/data/order_wc.dart';
import '/resources/pages/checkout_status_page.dart';
import '/app/models/cart_line_item.dart';
import '/app/models/checkout_session.dart';
import '/resources/pages/checkout_confirmation_page.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import 'package:nylo_framework/nylo_framework.dart';

payPalPay(context, {TaxRate? taxRate}) async {
  await checkout(taxRate, (total, billingDetails, cart) async {
    WooSignalApp? wooSignalApp = AppHelper.instance.appConfig;

    List<CartLineItem> cartLineItems = await cart.getCart();
    String taxTotal = await cart.taxAmount(taxRate);
    String subtotal = await Cart.getInstance.getSubtotal();

    String? currencyCode = wooSignalApp?.currencyMeta?.code;

    String shippingTotal =
        CheckoutSession.getInstance.shippingType?.getTotal() ?? "0";
    String description =
        "(${cartLineItems.length}) items from ${getEnv('APP_NAME')}"
            .tr(arguments: {"appName": getEnv('APP_NAME')});

    if (taxTotal == "") {
      taxTotal = "0";
    }

    if (shippingTotal == "") {
      shippingTotal = "0";
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: getEnv('PAYPAL_LIVE_MODE') != true,
          clientId: getEnv('PAYPAL_CLIENT_ID'),
          secretKey: getEnv('PAYPAL_SECRET_KEY'),
          note: "Contact us for any questions on your order.".tr(),
          transactions: [
            {
              "amount": {
                "total": total,
                "currency": currencyCode?.toUpperCase(),
                "details": {
                  "subtotal": subtotal,
                  "shipping": shippingTotal,
                  "shipping_discount": 0,
                  "tax": taxTotal
                }
              },
              "description": description,
              "item_list": {
                "items": cartLineItems
                    .map((item) => {
                          "name": item.name,
                          "quantity": item.quantity,
                          "price": item.total,
                          "currency": currencyCode?.toUpperCase()
                        })
                    .toList(),
                "shipping_address": {
                  "recipient_name":
                      "${billingDetails?.shippingAddress?.nameFull()}",
                  "line1": billingDetails?.shippingAddress?.addressLine,
                  "line2": "",
                  "city": billingDetails?.shippingAddress?.city,
                  "country_code": billingDetails
                      ?.shippingAddress?.customerCountry?.countryCode,
                  "postal_code": billingDetails?.shippingAddress?.postalCode,
                  "phone": billingDetails?.shippingAddress?.phoneNumber,
                  "state": billingDetails
                      ?.shippingAddress?.customerCountry?.state?.name
                },
              }
            }
          ],
          onSuccess: (Map params) async {
            OrderWC orderWC = await buildOrderWC(taxRate: taxRate);
            Order? order =
                await (appWooSignal((api) => api.createOrder(orderWC)));

            if (order == null) {
              updateState(CheckoutConfirmationPage.path.nyPageName(), data: {
                "reloadState": false,
                "toast": {
                  "title": trans("Error"),
                  "description":
                      trans("Something went wrong, please contact our store")
                }
              });
              return;
            }

            routeTo(CheckoutStatusPage.path, data: order);
          },
          onError: (error) {
            NyLogger.error(error.toString());
            showToastNotification(
              context,
              title: trans("Error"),
              description:
                  trans("Something went wrong, please contact our store"),
            );
            updateState(CheckoutConfirmationPage.path.nyPageName(),
                data: {"reloadState": false});
          },
          onCancel: () {
            showToastNotification(
              context,
              title: trans("Payment Cancelled"),
              description: trans("The payment has been cancelled"),
            );
            updateState(CheckoutConfirmationPage.path.nyPageName(),
                data: {"reloadState": false});
          },
        ),
      ),
    );
  });
}
