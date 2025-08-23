import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/article_model.dart';
import '../widgets/custom_text.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                  // Article Image
                  article.imageUrl.isNotEmpty
                      ? Image.asset(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.8),
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
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
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.white, size: 24.sp),
                onPressed: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Share functionality coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
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
                    text: article.title,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.left,
                    fontFamily: 'Roboto',
                  ),

                  SizedBox(height: 16.h),

                  // Article metadata
                  Row(
                    children: [
                      Icon(Icons.person, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'User ID: ${article.userId}',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                      Spacer(),
                      Icon(Icons.article, size: 16.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'Article #${article.id}',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Article body
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
                    child: CustomText(
                      text: article.body,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.justify,
                      fontFamily: 'Roboto',
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
    );
  }
}
