import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh functionality
            await Future.delayed(Duration(seconds: 1));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Refreshing notifications...'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Notification Icon
                      Icon(
                        Icons.notifications_none,
                        size: 80.sp,
                        color: Colors.grey[400],
                      ),

                      SizedBox(height: 24.h),

                      // Title
                      CustomText(
                        text: 'No Notifications Yet',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        fontFamily: 'Roboto',
                      ),

                      SizedBox(height: 16.h),

                      // Description
                      CustomText(
                        text:
                            'You\'ll see notifications about new articles, updates, and important news here when they become available.',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        fontFamily: 'Roboto',
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
