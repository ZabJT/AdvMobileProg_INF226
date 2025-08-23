import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              CustomText(
                text: 'Appearance',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 16.h),

              // Theme Toggle Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Icon(
                        themeModel.isDark ? Icons.dark_mode : Icons.light_mode,
                        size: 24.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Dark Mode',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: 'Toggle between light and dark theme',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: themeModel.isDark,
                        onChanged: (_) => themeModel.toggleTheme(),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // App Info Section
              CustomText(
                text: 'App Information',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 16.h),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildInfoRow('App Name', 'News Blog Mobile App'),
                      Divider(height: 1.h),
                      _buildInfoRow('Version', '1.0.0'),
                      Divider(height: 1.h),
                      _buildInfoRow('Developer', 'Zab Tumang'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 14.sp, fontWeight: FontWeight.w500),
          CustomText(text: value, fontSize: 14.sp, fontWeight: FontWeight.w400),
        ],
      ),
    );
  }
}
