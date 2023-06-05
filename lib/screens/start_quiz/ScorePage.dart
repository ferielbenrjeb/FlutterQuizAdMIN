import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
class ScorePageScreen extends StatefulWidget {
  final int quiz_code;

  const ScorePageScreen(this.quiz_code, {Key? key}) : super(key: key);

  static const routeName = '/Edit_screen';

  @override
  State<ScorePageScreen> createState() => _ScorePageScreenState();
}

class _ScorePageScreenState extends State<ScorePageScreen> {
  String _playerWithHighestScore = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPlayerWithHighestScore();
  }

 Future<void> _getPlayerWithHighestScore() async {
  final quizCode = widget.quiz_code;
  final quizDocSnapshot = await FirebaseFirestore.instance
      .collection('quizzes')
      .where('quiz_code', isEqualTo: quizCode)
      .limit(1)
      .get();
   if (quizDocSnapshot.docs.isNotEmpty) {
    final quizDoc = quizDocSnapshot.docs.first;
    final List<dynamic> players = quizDoc['players'];//ya5o liste de players 
    players.sort((a, b) => b['score'].compareTo(a['score']));//ya3mil tri selon score 
    final playerWithHighestScore = players[0]['name'];// enregistrer nom 
    setState(() {
      _playerWithHighestScore = playerWithHighestScore;
      _isLoading = false;
      print("Player with highest score: $_playerWithHighestScore");
    });
  }
}


 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
         flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ Color.fromARGB(255, 179, 91, 81)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Score Page',
         
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/score3.png',
                    height: 200,
                  ),
                  SizedBox(height: 32),
                  Text(
                    _playerWithHighestScore.isNotEmpty
                        ? 'Player with the highest score is $_playerWithHighestScore'
                        : 'Loading...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
}
