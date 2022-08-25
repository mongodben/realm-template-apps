import 'package:flutter_todo/viewmodels/item_viewmodel.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';

Realm initRealm(User currentUser) {
  Configuration config = Configuration.flexibleSync(currentUser, [Item.schema]);
  Realm realm = Realm(
    config,
  );
  final userTaskSub =
      realm.subscriptions.findByName('getUserItemsWithPriority2');
  if (userTaskSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      // server-side rules ensure user only downloads own tasks
      mutableSubscriptions.add(
          realm.query<Item>(
            'priority <= \$0 OR priority == nil',
            [PriorityLevel.high],
          ),
          name: 'getUserItemsWithPriority2');
    });
  }
  return realm;
}
