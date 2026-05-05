import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/get_wallet_usecase.dart';

class WalletNotifier extends AutoDisposeAsyncNotifier<WalletEntity> {
  @override
  Future<WalletEntity> build() async {
    final usecase = GetIt.I<GetWalletUseCase>();
    final result = await usecase(limit: 5);
    return result.fold((f) => throw f.message, (w) => w);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final walletProvider =
    AutoDisposeAsyncNotifierProvider<WalletNotifier, WalletEntity>(
        WalletNotifier.new);

class WalletLedgerNotifier
    extends AutoDisposeAsyncNotifier<List<TransactionEntity>> {
  int _page = 1;
  bool _hasMore = true;
  final List<TransactionEntity> _transactions = [];

  @override
  Future<List<TransactionEntity>> build() async {
    _page = 1;
    _hasMore = true;
    _transactions.clear();
    return _fetch();
  }

  Future<List<TransactionEntity>> _fetch() async {
    final usecase = GetIt.I<GetWalletUseCase>();
    final result = await usecase(page: _page);
    return result.fold(
      (f) => throw f.message,
      (w) {
        _transactions.addAll(w.transactions.data);
        _hasMore = _page < w.transactions.totalPages;
        return List.unmodifiable(_transactions);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }
}

final walletLedgerProvider = AutoDisposeAsyncNotifierProvider<
    WalletLedgerNotifier, List<TransactionEntity>>(WalletLedgerNotifier.new);
