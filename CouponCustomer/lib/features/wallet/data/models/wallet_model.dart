import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wallet_entity.dart';

part 'wallet_model.g.dart';

@JsonSerializable(createToJson: false)
class WalletModel extends WalletEntity {
  const WalletModel({
    required super.balance,
    required PaginatedTransactionsModel super.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaginatedTransactionsModel extends PaginatedTransactionsEntity {
  final TransactionMetaModel meta;

  PaginatedTransactionsModel({
    required List<TransactionModel> data,
    required this.meta,
  }) : super(
          data: data,
          total: meta.total,
          page: meta.page,
          limit: meta.limit,
          totalPages: meta.totalPages,
        );

  factory PaginatedTransactionsModel.fromJson(Map<String, dynamic> json) => _$PaginatedTransactionsModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class TransactionMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const TransactionMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory TransactionMetaModel.fromJson(Map<String, dynamic> json) => _$TransactionMetaModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.amount,
    super.redemptionId,
    super.note,
    required super.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}
