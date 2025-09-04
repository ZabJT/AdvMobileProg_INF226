import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'article_screen.dart';
import 'settings_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

import '../widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, this.username = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  VoidCallback? _resetArticlePage;

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Articles';
      case 1:
        return 'Notifications';
      case 2:
        return 'Profile';
      default:
        return 'Articles';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: _selectedIndex == 0
            ? Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search articles...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              )
            : CustomText(
                text: _getPageTitle(),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 24.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          ArticleScreen(
            searchController: _searchController,
            onResetPage: (VoidCallback resetCallback) {
              _resetArticlePage = resetCallback;
            },
          ),
          const NotificationScreen(),
          const ProfileScreen(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // selected item
        showUnselectedLabels: false, // unselected item
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);

    // If tapping home button (index 0), reset article screen to first page
    if (value == 0) {
      _resetArticlePage?.call();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
