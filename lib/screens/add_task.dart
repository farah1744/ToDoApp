import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
class AddTask extends StatefulWidget {
  //const AddTask({super.key});
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser; // Use User instead of FirebaseUser

    if (user != null) {
      String uid = user.uid;
      var time = DateTime.now();
      await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('My Tasks').doc(time.toString()).set({
        'title': titleController.text,
        'description':descriptionController.text,
        'time' : time.toString(),
        'timestamp':time
      });
      Fluttertoast.showToast(msg: 'Data added');
    } else {
       print('User is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('New Task')),
        body: Container(padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Enter Title',
                    border: OutlineInputBorder()),
            ),
            ),
            SizedBox(height :10),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states){
                  if(states.contains(MaterialState.pressed))
                    return Colors.white;
                  return Colors.purple;
                })),
                child: Text('Add Task', style: GoogleFonts.roboto(fontSize: 18),
                ),
                onPressed: (){
                  addTaskToFirebase();
                },
            ))
          ],
        )),
    );
  }
}
