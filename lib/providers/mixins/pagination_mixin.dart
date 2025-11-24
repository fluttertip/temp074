mixin PaginationMixin {
  static const int defaultPageSize = 10;

  int _currentPage = 0;
  int _pageSize = defaultPageSize;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  void resetPagination() {
    _currentPage = 0;
    _hasMoreData = true;
    _isLoadingMore = false;
  }

  void setPageSize(int size) {
    _pageSize = size;
  }

  void setLoadingMore(bool loading) {
    _isLoadingMore = loading;
  }

  void updatePagination(int itemsLoaded) {
    _currentPage++;
    _hasMoreData = itemsLoaded >= _pageSize;
    _isLoadingMore = false;
  }

  void setNoMoreData() {
    _hasMoreData = false;
    _isLoadingMore = false;
  }
}
