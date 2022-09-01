import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';

Realm initRealm(User currentUser) async {
  Configuration config = Configuration.flexibleSync(currentUser, [Item.schema]);
  Realm realm = Realm(
    config,
  );
  // :snippet-start: updated-sub
  final userItemSub =
      realm.subscriptions.findByName('getUserItemsWithPriority'); // :emphasize:
  if (userItemSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      // server-side rules ensure user only downloads own items
      mutableSubscriptions.add(
          // :emphasize-start:
          realm.query<Item>(
            'priority <= \$0',
            [PriorityLevel.high],
          ),
          name: 'getUserItemsWithPriority');
      // :emphasize-end:
    });
    await realm.subscriptions.waitForSynchronization();
  }
  // :snippet-end:
  return realm;
}

// old making for bluehawkification
void _oldVersion(User user, Configuration config, Realm realm) {
  // :snippet-start: base-version
  final userItemSub = realm.subscriptions.findByName('getUserItems');
  if (userItemSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      // server-side rules ensure user only downloads own items
      mutableSubscriptions.add(realm.all<Item>(), name: 'getUserItems');
    });
  }
  // :snippet-end:
}

void _postUpdateWithNullVersion(User user, Configuration config, Realm realm) {
  // :snippet-start: post-update
  // :emphasize-start:
  final userItemSub =
      realm.subscriptions.findByName('getUserItemsWithHighOrNoPriority');
  // :emphasize-end:
  if (userItemSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      // server-side rules ensure user only downloads own items
      // :emphasize-start:
      mutableSubscriptions.add(
          realm.query<Item>(
              'priority <= \$0 OR priority == nil', [PriorityLevel.high]),
          name: 'getUserItemsWithHighOrNoPriority');
      // :emphasize-end:
    });
  }
  // :snippet-end:
}
