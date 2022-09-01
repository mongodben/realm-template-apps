import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';

Realm initRealm(User currentUser) {
  Configuration config = Configuration.flexibleSync(currentUser, [Item.schema]);
  Realm realm = Realm(
    config,
  );
  // :snippet-start: updated-sub
  final userItemSub = realm.subscriptions.findByName('getUserItems');
  // :emphasize-start:
  final userItemSubWithPriority =
      realm.subscriptions.findByName('getUserItemsWithPriority');
  // :emphasize-end:

  // :emphasize-start:
  if (userItemSubWithPriority == null) {
    // :emphasize-end:
    realm.subscriptions.update((mutableSubscriptions) {
      // :emphasize-start:
      if (userItemSub != null) {
        mutableSubscriptions.remove(userItemSub);
      }
      // :emphasize-end:
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
    // // Syncs in background
    // realm.subscriptions.waitForSynchronization();
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
    // Syncs in background
    // realm.subscriptions.waitForSynchronization();
  }
  // :snippet-end:
}

void _postUpdateWithNullVersion(User user, Configuration config, Realm realm) {
  // :snippet-start: post-update
  // old subscriptions
  final userItemSub = realm.subscriptions.findByName('getUserItems');
  final userItemSubWithPriority =
      realm.subscriptions.findByName('getUserItemsWithPriority');
  // :emphasize-start:
  final userItemSubWithPriorityOrNothing =
      realm.subscriptions.findByName('getUserItemsWithPriorityOrNothing');
  // :emphasize-end:

  // :emphasize-start:
  if (userItemSubWithPriorityOrNothing == null) {
    // :emphasize-end:
    realm.subscriptions.update((mutableSubscriptions) {
      if (userItemSub != null) {
        mutableSubscriptions.remove(userItemSub);
      }
      // :emphasize-start:
      if (userItemSubWithPriority != null) {
        mutableSubscriptions.remove(userItemSubWithPriority);
      }
      // :emphasize-end:
      // server-side rules ensure user only downloads own items
      mutableSubscriptions.add(
          // :emphasize-start:
          realm.query<Item>(
            'priority <= \$0 OR priority == nil',
            [PriorityLevel.high],
          ),
          name: 'getUserItemsWithPriorityOrNothing');
      // :emphasize-end:
    });
    // Syncs in background
    // realm.subscriptions.waitForSynchronization();
  }
  // :snippet-end:
}
