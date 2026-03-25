// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
      balance: (json['balance'] as num).toInt(),
      transactions: PaginatedTransactionsModel.fromJson(
          json['transactions'] as Map<String, dynamic>),
    );

PaginatedTransactionsModel _$PaginatedTransactionsModelFromJson(
        Map<String, dynamic> json) =>
    PaginatedTransactionsModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: TransactionMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );

TransactionMetaModel _$TransactionMetaModelFromJson(
        Map<String, dynamic> json) =>
    TransactionMetaModel(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      redemptionId: json['redemptionId'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
