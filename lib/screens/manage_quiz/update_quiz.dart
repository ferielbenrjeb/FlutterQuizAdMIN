import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final int quiz_code;

  const UpdateScreen(this.quiz_code, {Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');
  late List<Map<String, dynamic>> _questions = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }
  // charger donnee men firestore 
  Future<void> _loadQuizData() async {
    try {
      final QuerySnapshot querySnapshot = await quizzesCollection
          .where("quiz_code", isEqualTo: widget.quiz_code)
          .get();//mech yjiblik quiz eli code=quiz_code
      final DocumentSnapshot quizSnapshot = querySnapshot.docs.first;//yan3ni awil wahid tal9ah 3ando code adhaka tistokih fi variable quizSnapshot
      print(quizSnapshot);

      final data = quizSnapshot.data();//donee de quiz yitsajlo fi data ykono forma Map<String, dynamic>
      print(widget.quiz_code.toString());
      print(data);
      if (data != null && data is Map<String, dynamic>) {
        setState(() {//houni kan donnee mech null tsajilhom fi variable _question
          _questions = List<Map<String, dynamic>>.from(
              data['questions'] as List<dynamic>);
        });
        print("Données chargées : $_questions");
        print("Format des données : ${_questions.runtimeType}");
      } else {
        setState(() {
          _errorMessage = 'No questions found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // fonction update de question 
  Future<void> _updateQuiz() async {
    try {
      final QuerySnapshot querySnapshot = await quizzesCollection
          .where("quiz_code", isEqualTo: widget.quiz_code)
          .get();
      final DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      final DocumentReference quizRef = quizzesCollection.doc(quizSnapshot.id);

      // Check if the document exists before attempting to update it
      //final DocumentSnapshot quizSnapshot = await quizRef.get();
      if (quizSnapshot.exists) {
        
        //La mise à jour est effectuée en utilisant la méthode update() de la référence de document qui prend 
        //un objet Map contenant les nouvelles valeurs de propriétés pour le document
        await quizRef.update({
          'questions': _questions, // Update the questions list
        });

        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'Quiz not found.';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  

  Widget _buildQuestionTextField(Map<String, dynamic> question) {
    final TextEditingController _questionController =
        TextEditingController(text: question['question'] as String);
    final TextEditingController _optionAController =
        TextEditingController(text: question['option_a'] as String);
    final TextEditingController _optionBController =
        TextEditingController(text: question['option_b'] as String);
    final TextEditingController _optionCController =
        TextEditingController(text: question['option_c'] as String);
    final TextEditingController _answerController =
        TextEditingController(text: question['answer'] as String);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Question ${_questions.indexOf(question) + 1}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 15, 102, 174),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _questionController,
          decoration: InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.help_outline),
          ),
          onChanged: (value) =>
              question['question'] = _questionController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionAController,
          decoration: InputDecoration(
            labelText: 'Option A',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.circle),
          ),
          onChanged: (value) =>
              question['option_a'] = _optionAController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionBController,
          decoration: InputDecoration(
            labelText: 'Option B',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.square),
          ),
          onChanged: (value) =>
              question['option_b'] = _optionBController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionCController,
          decoration: InputDecoration(
            labelText: 'Option C',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.star), 
          ),
          onChanged: (value) =>
              question['option_c'] = _optionCController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: 'Answer',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.check),
          ),
          onChanged: (value) =>
              question['answer'] = _answerController.text.trim(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Quiz'),
        backgroundColor:Color.fromARGB(255, 179, 91, 81),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Questions',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildQuestionTextField(_questions[index]);
                          },
                        ),
                         SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _updateQuiz,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Update Quiz'),
                            ),
                            SizedBox(width: 20),
                           
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}
