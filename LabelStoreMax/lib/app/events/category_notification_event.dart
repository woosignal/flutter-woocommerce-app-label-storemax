import 'package:firebase_messaging/firebase_messaging.dart';
import '/resources/pages/browse_category_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/wp_json_api.dart';

class CategoryNotificationEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    RemoteMessage message = event['RemoteMessage'];

    if (!message.data.containsKey('order_id')) {
      return;
    }
    if (!message.data.containsKey('user_id')) {
      return;
    }

    String userId = message.data['user_id'];

    if ((await WPJsonAPI.wpUserLoggedIn()) != true) {
      return;
    }

    String? currentUserId = await WPJsonAPI.wpUserId();
    if (currentUserId != userId) {
      return;
    }

    routeTo(BrowseCategoryPage.path,
        data: int.parse(message.data['category_id']));
  }
}
