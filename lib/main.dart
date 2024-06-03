import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luminar_control_app/providers/theme_provider.dart';
import 'package:luminar_control_app/screens/home_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

const Color seedAppColor = Color.fromARGB(255, 166, 255, 188);

TextTheme myAppTextTheme = const TextTheme(
  headlineSmall: TextStyle(fontSize: 12.0),
  headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
  headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: seedAppColor,
  ),
  textTheme: myAppTextTheme,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: seedAppColor,
  ),
  textTheme: myAppTextTheme,
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightThemeActive = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Lunar Control App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isLightThemeActive ? ThemeMode.light : ThemeMode.dark,
      home: AnimatedSplashScreen.withScreenFunction(
        backgroundColor:
            isLightThemeActive ? lightTheme.colorScheme.primaryContainer : darkTheme.colorScheme.primaryContainer,
        splash: RepeatingBounceIcon(
          icon: Icons.electric_bolt_outlined,
          color: !isLightThemeActive ? lightTheme.colorScheme.inversePrimary : darkTheme.colorScheme.inversePrimary,
          size: 100,
        ),

        screenFunction: () async {
          //
          // connect to Home Assistant
          // await Future.delayed(const Duration(seconds: 2), () {});

          return const HomeScreen();
        },
        // splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

class RepeatingBounceIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const RepeatingBounceIcon({super.key, required this.icon, required this.color, required this.size});

  @override
  _RepeatingBounceIconState createState() => _RepeatingBounceIconState();
}

class _RepeatingBounceIconState extends State<RepeatingBounceIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0.5,
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: _controller, curve: Curves.bounceIn).value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}