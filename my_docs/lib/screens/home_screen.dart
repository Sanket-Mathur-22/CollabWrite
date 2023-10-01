import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_docs/repository/auth_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../models/document_model.dart';
import '../repository/document_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

   void signOut(WidgetRef ref) {
    ref.read(AuthRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }
   void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

   void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: AnimatedTextKit(
  animatedTexts: [
    TyperAnimatedText(
      'CollabWrite',
      textStyle: GoogleFonts.dancingScript(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 22, 133, 230)
      ),
      speed: const Duration(milliseconds: 140),
    ),
  ],
  
  totalRepeatCount: 20,
  pause: const Duration(milliseconds: 200),
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
),
        actions: [
          IconButton(onPressed: () => createDocument(context, ref), icon: Icon(Icons.add),color: Colors.black,),
          IconButton(onPressed: () =>signOut(ref), icon: Icon(Icons.logout),color: Colors.red,),
        ],
      ),
      body:  FutureBuilder(
        future: ref.watch(documentRepositoryProvider).getDocuments(
              ref.watch(userProvider)!.token,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return Center(
            child: Container(
              width: 600,
              margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
              child: ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];

                  return InkWell(
                    onTap: () => navigateToDocument(context, document.id),
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        color: Colors.amber[200],
                        child: Center(
                          child: Text(
                            document.title,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
