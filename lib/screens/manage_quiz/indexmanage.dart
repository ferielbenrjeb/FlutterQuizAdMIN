import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/manage_quiz/update_quiz.dart';

class IndexManageScreen extends StatefulWidget {
  const IndexManageScreen({Key? key}) : super(key: key);
  static const routeName = '/Edit_screen';

  @override
  State<IndexManageScreen> createState() => _IndexManageScreenState();
}

class _IndexManageScreenState extends State<IndexManageScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  //asyn ya3ni yistana get  donnee 9bale maymail execution mta3 methode
  Future<List<DocumentSnapshot>> getQuizzes() async {
    //tarj3ina liste de document (liste de quiz )w kol wahid de type DocumentSnaphoche
    try {
      //Future ya3ni haja mech dispo taw
      QuerySnapshot snapshot = await quizzesCollection.get(); //get database
      return snapshot.docs; //ya3ni mech raj3o lista wa9ite appel fonction
    } catch (error) {
      print("Error getting quizzes: $error");
      return [];
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Liste des quiz'),
      backgroundColor: Color.fromARGB(255, 179, 91, 81),
    ),
    body: FutureBuilder(
      future: getQuizzes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur lors du chargement des quiz'),
          );
        }
          List<DocumentSnapshot> quizzes =
              snapshot.data as List<DocumentSnapshot>;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              String title = quizzes[index].get('title');
              int quiz_code = quizzes[index].get('quiz_code');

              return Card(
                child: ListTile(
                  leading: Icon(Icons.quiz),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateScreen(quiz_code),
                        ),
                      );
                    },
                    icon: Icon(Icons.update),
                    label: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 142, 200, 66),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
