import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/article_model.dart';
import '../services/article_service.dart';
import '../widgets/custom_text.dart';
import '../widgets/article_dialog.dart';
import 'article_detail_screen.dart';

class ArticleScreen extends StatefulWidget {
  final TextEditingController? searchController;
  final Function(VoidCallback)? onResetPage;
  const ArticleScreen({super.key, this.searchController, this.onResetPage});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen>
    with TickerProviderStateMixin {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  List<Article> _paginatedArticles = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  int _currentPage = 1;
  late int _itemsPerPage;
  int _totalPages = 0;

  // Fade animation for Add button
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isAtBottom = false;
  Timer? _fadeTimer;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Initialize pagination settings from environment variables
    try {
      if (dotenv.isInitialized) {
        _itemsPerPage = int.tryParse(dotenv.env['ITEMS_PER_PAGE'] ?? '6') ?? 6;
      } else {
        _itemsPerPage = 6; // fallback to default if not initialized
      }
    } catch (e) {
      print('Error accessing ITEMS_PER_PAGE from env: $e');
      _itemsPerPage = 6; // fallback to default
    }

    // Initialize scroll controller
    _scrollController = ScrollController();

    _loadArticles();
    // Listen to search controller changes
    widget.searchController?.addListener(_filterArticles);

    // Set up the reset callback
    widget.onResetPage?.call(resetToFirstPage);

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void resetToFirstPage() async {
    setState(() {
      _isRefreshing = true;
      _currentPage = 1;
    });

    // Scroll to top immediately
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Simulate a brief loading time for better UX
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isRefreshing = false;
    });
    _updatePagination();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ArticleService().getAllArticles();
      _allArticles = (response).map((e) => Article.fromJson(e)).toList();
      // Reverse the list to show newest articles first (chronological order: newest to oldest)
      _allArticles = _allArticles.reversed.toList();
      _filteredArticles = _allArticles;
      _updatePagination();
    } catch (e) {
      _allArticles = [];
      _filteredArticles = [];
      _paginatedArticles = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterArticles() {
    final searchQuery = widget.searchController?.text.toLowerCase() ?? '';

    if (searchQuery.isEmpty) {
      setState(() {
        _filteredArticles = _allArticles;
      });
    } else {
      setState(() {
        _filteredArticles = _allArticles.where((article) {
          return article.title.toLowerCase().contains(searchQuery) ||
              article.name.toLowerCase().contains(searchQuery) ||
              article.content.any(
                (content) => content.toLowerCase().contains(searchQuery),
              );
        }).toList();
      });
    }
    _updatePagination();
  }

  void _updatePagination() {
    _totalPages = (_filteredArticles.length / _itemsPerPage).ceil();
    if (_currentPage > _totalPages && _totalPages > 0) {
      _currentPage = _totalPages;
    }

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      0,
      _filteredArticles.length,
    );

    setState(() {
      _paginatedArticles = _filteredArticles.sublist(startIndex, endIndex);
      // Reset button state when content changes
      _isAtBottom = false;
    });

    // Ensure button is visible when content changes
    _fadeController.reverse();
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
        // Reset the bottom state when changing pages
        _isAtBottom = false;
      });
      _updatePagination();
      // Reset the fade animation to show the button
      _fadeController.reverse();

      // Scroll to top when changing pages
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _openAddArticleDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ArticleDialog(
        existingArticles: _allArticles,
        onArticleSaved: (newArticle) {
          setState(() {
            _allArticles.insert(
              0,
              newArticle,
            ); // Add to beginning for newest-first order
            _filterArticles();
            // New article will be on the first page
            _currentPage = 1;
            _updatePagination();
          });
        },
      ),
    );
  }

  Widget _statusChip(bool active) {
    return Chip(
      label: Text(active ? 'Active' : 'Inactive'),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: active ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isAtBottom
          ? null
          : AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: FloatingActionButton.extended(
                    onPressed: _openAddArticleDialog,
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                  ),
                );
              },
            ),
      body: Column(
        children: [
          // Modern loading indicator at top
          if (_isRefreshing)
            Container(
              height: 4.h,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          // Page indicator at top
          if (_totalPages > 1)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Center(
                child: CustomText(
                  text: 'Page $_currentPage',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Search text field must be here
                  SizedBox(height: 10.h),
                  Expanded(child: _buildArticlesList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator.adaptive(strokeWidth: 3.sp),
            SizedBox(height: 10.h),
            CustomText(text: 'Loading articles...', fontSize: 14.sp),
          ],
        ),
      );
    }

    if (_allArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: CustomText(text: 'No articles to display.', fontSize: 14.sp),
        ),
      );
    }

    if (_filteredArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              CustomText(
                text: 'No articles found matching your search.',
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount:
            _paginatedArticles.length +
            (_totalPages > 1 ? 1 : 0), // +1 for pagination
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // Show pagination after the last article
          if (index == _paginatedArticles.length) {
            return _buildPaginationControls();
          }

          final article = _paginatedArticles[index];
          final preview = article.content.isNotEmpty
              ? article.content.first
              : '';

          return Card(
            elevation: 1,
            child: InkWell(
              onTap: () {
                debugPrint('Tapped index $index: ${article.aid}');
                // Navigation to DetailScreen must be here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      article: article,
                      existingArticles: _allArticles,
                      onArticleUpdated: (updatedArticle) {
                        setState(() {
                          final index = _allArticles.indexWhere(
                            (a) => a.aid == updatedArticle.aid,
                          );
                          if (index != -1) {
                            _allArticles[index] = updatedArticle;
                            _filterArticles();
                          }
                        });
                      },
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(15),
                  vertical: ScreenUtil().setHeight(15),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: article.title.isEmpty
                                      ? 'Untitled'
                                      : article.title,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                              ),
                              _statusChip(article.isActive),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          CustomText(text: article.name, fontSize: 13.sp),
                          if (preview.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            CustomText(
                              text: preview,
                              fontSize: 12.sp,
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginationControls() {
    if (_totalPages <= 1) return SizedBox.shrink();

    // Get max pagination pages from environment variables
    int maxPaginationPages;
    try {
      if (dotenv.isInitialized) {
        maxPaginationPages =
            int.tryParse(dotenv.env['MAX_PAGINATION_PAGES'] ?? '5') ?? 5;
      } else {
        maxPaginationPages = 5; // fallback to default if not initialized
      }
    } catch (e) {
      print('Error accessing MAX_PAGINATION_PAGES from env: $e');
      maxPaginationPages = 5; // fallback to default
    }

    // Calculate the sliding window of pages
    int startPage = _currentPage;
    int endPage = _currentPage + (maxPaginationPages - 1);

    // Adjust if we're near the end
    if (endPage > _totalPages) {
      endPage = _totalPages;
      startPage = (_totalPages - (maxPaginationPages - 1)).clamp(
        1,
        _totalPages,
      );
    }

    // Adjust if we're near the beginning
    if (startPage < 1) {
      startPage = 1;
      endPage = maxPaginationPages.clamp(1, _totalPages);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          // Page info
          CustomText(
            text:
                'Page $_currentPage of $_totalPages (${_filteredArticles.length} articles)',
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16.h),
          // Pagination controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              IconButton(
                onPressed: _currentPage > 1
                    ? () => _goToPage(_currentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage > 1
                      ? Colors.blue
                      : Colors.grey[300],
                  foregroundColor: _currentPage > 1
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),

              SizedBox(width: 8.w),

              // Page numbers (sliding window of 5)
              Row(
                children: [
                  for (int i = startPage; i <= endPage; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: InkWell(
                        onTap: () => _goToPage(i),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: '$i',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: _currentPage == i
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 8.w),

              // Next button
              IconButton(
                onPressed: _currentPage < _totalPages
                    ? () => _goToPage(_currentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage < _totalPages
                      ? Colors.blue
                      : Colors.grey[300],
                  foregroundColor: _currentPage < _totalPages
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification ||
        notification is ScrollEndNotification) {
      final scrollPosition = notification.metrics.pixels;
      final maxScrollExtent = notification.metrics.maxScrollExtent;

      // Only check if we have content to scroll
      if (maxScrollExtent > 0) {
        // Check if we're near the pagination area (within 100 pixels of bottom)
        bool isNearPagination = scrollPosition >= maxScrollExtent - 100;

        if (isNearPagination && !_isAtBottom) {
          // Just reached the pagination area - fade out immediately
          setState(() {
            _isAtBottom = true;
          });
          _fadeTimer?.cancel();
          _fadeController.forward();
        } else if (!isNearPagination && _isAtBottom) {
          // Scrolled away from pagination area - fade in immediately
          setState(() {
            _isAtBottom = false;
          });
          _fadeTimer?.cancel();
          _fadeController.reverse();
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    widget.searchController?.removeListener(_filterArticles);
    _fadeController.dispose();
    _fadeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
