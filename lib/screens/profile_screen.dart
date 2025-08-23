import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual login functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login functionality coming soon!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),

                // Login Title
                CustomText(
                  text: 'Login to Your Account',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  fontFamily: 'Roboto',
                ),

                SizedBox(height: 8.h),

                // Subtitle
                CustomText(
                  text: 'Enter your credentials to access your profile',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontFamily: 'Roboto',
                  color: Colors.grey[600],
                ),

                SizedBox(height: 40.h),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32.h),

                // Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: CustomText(
                    text: 'Login',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),

                SizedBox(height: 20.h),

                // Forgot Password Link
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Forgot password functionality coming soon!',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: CustomText(
                    text: 'Forgot Password?',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                SizedBox(height: 20.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Don\'t have an account? ',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      color: Colors.grey[600],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement sign up functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sign up functionality coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: CustomText(
                        text: 'Sign Up',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
