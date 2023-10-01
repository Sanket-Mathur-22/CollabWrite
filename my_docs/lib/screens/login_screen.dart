import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_docs/models/error_model.dart';
import 'package:my_docs/repository/auth_repository.dart';
import 'package:my_docs/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(AuthRepositoryProvider).signInWitGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push('/');
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
  animatedTexts: [
    TyperAnimatedText(
      'CollabWrite',
      textStyle: GoogleFonts.dancingScript(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 22, 133, 230)
      ),
      speed: const Duration(milliseconds: 180),
    ),
  ],
  
  totalRepeatCount: 1,
  pause: const Duration(milliseconds: 100),
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
),
            Image.asset('assets/login_logo.jpg',height: 300,),
            SizedBox(
              height: 40,
            ),
            Transform.scale(
              scale: 1.1,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white
                ),
                  onPressed: () => signInWithGoogle(ref, context),
                  icon: Image.asset(
                    'assets/g-logo-2.png',
                    height: 23,
                  ),
                  label: Text(
                    "Sign in with Google",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
