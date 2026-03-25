import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final int balance;
  final PaginatedTransactionsEntity transactions;
  
  const WalletEntity({required this.balance, required this.transactions});
  
  @override
  List<Object?> get props => [balance, transactions];
}

class PaginatedTransactionsEntity extends Equatable {
  final List<TransactionEntity> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedTransactionsEntity({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [data, total, page, limit, totalPages];
}

class TransactionEntity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final int amount;
  final String? redemptionId;
  final String? note;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.redemptionId,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, type, amount, redemptionId, note, createdAt];
}
