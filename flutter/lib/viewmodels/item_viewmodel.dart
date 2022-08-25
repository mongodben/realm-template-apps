// :snippet-start: item-viewmodel
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';

class ItemViewModel {
  final ObjectId id;
  String summary;
  bool isComplete;
  int priority; // :emphasize:
  final String ownerId;
  late Item item;
  final Realm realm;

  // :emphasize-start:
  ItemViewModel._(this.realm, this.item, this.id, this.summary, this.ownerId,
      this.isComplete, this.priority);
  ItemViewModel(Realm realm, Item item)
      : this._(realm, item, item.id, item.summary, item.ownerId,
            item.isComplete, item.priority ?? PriorityLevel.low);

  static ItemViewModel create(Realm realm, Item item) {
    final itemInRealm = realm.write<Item>(() => realm.add<Item>(item));
    return ItemViewModel(realm, item);
  }
  // :emphasize-end:

  void delete() {
    realm.write(() => realm.delete(item));
  }

  // :emphasize-start:
  void update({String? summary, bool? isComplete, int? priority}) {
    // :emphasize-end:
    realm.write(() {
      if (summary != null) {
        this.summary = summary;
        item.summary = summary;
      }
      if (isComplete != null) {
        this.isComplete = isComplete;
        item.isComplete = isComplete;
      }
      // :emphasize-start:
      if (priority != null) {
        this.priority = priority;
        item.priority = priority;
      }
      // :emphasize-end:
    });
  }
}

// :emphasize-start:
abstract class PriorityLevel {
  static int severe = 0;
  static int high = 1;
  static int medium = 2;
  static int low = 3;
}
// :emphasize-end:
// :snippet-end:
