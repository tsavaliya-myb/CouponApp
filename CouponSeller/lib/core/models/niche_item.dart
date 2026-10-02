import 'package:freezed_annotation/freezed_annotation.dart';

part 'niche_item.freezed.dart';
part 'niche_item.g.dart';

@freezed
class NicheItem with _$NicheItem {
  const factory NicheItem({
    required String id,
    required String name,
    required String slug,
  }) = _NicheItem;

  factory NicheItem.fromJson(Map<String, dynamic> json) => _$NicheItemFromJson(json);
}
