import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start_quiz/passquestion.dart';

class BeginStartScreen extends StatefulWidget {
  final String title;
  final int quiz_code;

  BeginStartScreen(this.title, this.quiz_code, {Key? key}) : super(key: key);

  static const routeName = '/beginStartScreen';

  @override
  State<BeginStartScreen> createState() => _BeginStartScreenState();
}

class _BeginStartScreenState extends State<BeginStartScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor:Color.fromARGB(255, 179, 91, 81),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(//hiya ta5o 2 argument(Streamer ya3ni flux quizzecollection w builder hiya widget eli titbadil)
          stream: quizzesCollection
              .where('quiz_code', isEqualTo: widget.quiz_code)
              .snapshots()
              .map((query) => query.docs.first),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Une erreur est survenue : ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              );
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final doc = snapshot.data!;//houni mech ta5o donnee mta3 quiz
            final numberPlayers = doc['number_players'] ?? 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: 16),  
              Image(
                  image: AssetImage('assets/images/start2.png'),
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),
                Text(
                  'Code du quiz : ${widget.quiz_code}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Nombre de joueurs : $numberPlayers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 32),
                if (numberPlayers >= 2)///houni test 3la nb de joueurs
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 141, 120, 247),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      final quizRef = quizzesCollection.doc(doc.id);//mech ya5i id mta3 quiz

                      await quizRef.update({'quiz_start': true});//houni ybadlo true ki yinzil commencer le quiz 

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassQuestion(widget.quiz_code),
                        ),
                      );
                    },
                    child: Text(
                      'Commencer',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
