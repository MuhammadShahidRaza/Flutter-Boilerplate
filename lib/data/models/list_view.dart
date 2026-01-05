class AppListState<T> {
  final List<T> items;
  final bool loadingInitial;
  final bool loadingMore;
  final bool refreshing;
  final String? error;
  final bool hasMore;

  const AppListState({
    this.items = const [],
    this.loadingInitial = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.error,
    this.hasMore = true,
  });

  AppListState<T> copyWith({
    List<T>? items,
    bool? loadingInitial,
    bool? loadingMore,
    bool? refreshing,
    String? error,
    bool? hasMore,
  }) {
    return AppListState<T>(
      items: items ?? this.items,
      loadingInitial: loadingInitial ?? this.loadingInitial,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
