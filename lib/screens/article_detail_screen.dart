import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/article_model.dart';
import '../widgets/custom_text.dart';
import '../widgets/article_dialog.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  final Function(Article)? onArticleUpdated;
  final List<Article> existingArticles; // For duplicate name validation

  const ArticleDetailScreen({
    super.key,
    required this.article,
    this.onArticleUpdated,
    required this.existingArticles,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isEditing = false;
  bool isLoading = false;
  late Article currentArticle;

  @override
  void initState() {
    super.initState();
    currentArticle = widget.article;
  }

  void _openEditDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (ctx) => ArticleDialog(
        article: currentArticle,
        existingArticles: widget.existingArticles,
        onArticleSaved: (updatedArticle) {
          setState(() {
            currentArticle = updatedArticle;
            isEditing = false;
          });
          widget.onArticleUpdated?.call(updatedArticle);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with Image Header
              SliverAppBar(
                expandedHeight: 250.h,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Article Image placeholder
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.8),
                              Theme.of(context).primaryColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.article,
                            size: 80.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 24.sp),
                    onPressed: _openEditDialog,
                  ),
                ],
              ),

              // Article Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Title
                      CustomText(
                        text: currentArticle.title,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        fontFamily: 'Roboto',
                      ),

                      SizedBox(height: 16.h),

                      // Article metadata
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16.sp,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: 'Author: ${currentArticle.name}',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          Spacer(),
                          // Status chip
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: currentArticle.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: CustomText(
                              text: currentArticle.isActive
                                  ? 'Active'
                                  : 'Inactive',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Article content
                      CustomText(
                        text: 'Article Content',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),

                      SizedBox(height: 12.h),

                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: currentArticle.content
                              .map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 6.w,
                                        height: 6.w,
                                        margin: EdgeInsets.only(
                                          top: 6.h,
                                          right: 8.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          text: item,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.justify,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Related articles section (placeholder)
                      CustomText(
                        text: 'Related Articles',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),

                      SizedBox(height: 12.h),

                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomText(
                                text:
                                    'More articles from this author will appear here',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40.h), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: 'Updating article...',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
