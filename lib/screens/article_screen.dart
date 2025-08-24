import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/article_model.dart';
import '../services/article_service.dart';
import '../widgets/custom_text.dart';
import 'article_detail_screen.dart';

class ArticleScreen extends StatefulWidget {
  final TextEditingController? searchController;
  const ArticleScreen({super.key, this.searchController});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    // Listen to search controller changes
    widget.searchController?.addListener(_filterArticles);
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ArticleService().getAllArticles();
      _allArticles = (response).map((e) => Article.fromJson(e)).toList();
      _filteredArticles = _allArticles;
    } catch (e) {
      _allArticles = [];
      _filteredArticles = [];
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
              article.body.toLowerCase().contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: _buildArticlesList())],
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

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: _filteredArticles.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final article = _filteredArticles[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: article),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: article.imageUrl.isNotEmpty
                        ? Image.asset(
                            article.imageUrl,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 30.sp,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              size: 30.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        CustomText(
                          text: article.title,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          // prevent overflow
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        // Body preview
                        CustomText(
                          text: article.body,
                          fontSize: 13.sp,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.searchController?.removeListener(_filterArticles);
    super.dispose();
  }
}
