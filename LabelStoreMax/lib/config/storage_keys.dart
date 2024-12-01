/* Storage Keys
|--------------------------------------------------------------------------
| Add your storage keys here and then use them later to retrieve data.
| E.g. static String userCoins = "USER_COINS";
| String coins = NyStorage.read( StorageKey.userCoins );
|
| Learn more: https://nylo.dev/docs/6.x/storage#storage-keys
|-------------------------------------------------------------------------- */

import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/wp_json_api.dart';

class Keys {
  // Define the keys you want to be synced on boot
  static syncedOnBoot() => () async {
        return [
          auth,
        ];
      };

  static StorageKey auth = WPJsonAPI.storageKey();

  /// Add your storage keys here...
}
