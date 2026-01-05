class PaginatedResult<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;
  final int? perPage;
  final int? total;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
    this.perPage,
    this.total,
  });

  bool get hasMore => nextPageUrl != null && currentPage < lastPage;

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json, {
    required List<T> Function(dynamic raw) itemsParser,
    String itemsKey = 'bookings',
  }) {
    final items = itemsParser(json[itemsKey]);
    final currentPage = (json['current_page'] as num?)?.toInt() ?? 1;
    final lastPage = (json['last_page'] as num?)?.toInt() ?? currentPage;
    final nextPageUrl = json['next_page_url']?.toString();
    final perPage = (json['per_page'] as num?)?.toInt();
    final total = (json['total'] as num?)?.toInt();

    return PaginatedResult<T>(
      items: items,
      currentPage: currentPage,
      lastPage: lastPage,
      nextPageUrl: nextPageUrl,
      perPage: perPage,
      total: total,
    );
  }
}
