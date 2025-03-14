import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/user_models/splash_screen.dart';
import 'user_authentication/signin/bloc/signin_bloc.dart';
import 'user_prof_mang/bloc/user_prof_mang_bloc.dart';

void main() {
 runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // Adjust according to your design
      minTextAdapt: true, // This is likely missing, causing the error
      splitScreenMode: true,
      builder: (context, child) {
        return  const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigninBloc(),
        ),
        BlocProvider(
          create: (context) => UserProfMangBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
