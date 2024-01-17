import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/screens/add_task.dart';
import 'package:todoapp/screens/description.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid='';

  @override
  void initState() {
    getUid();
    super.initState();
  }

  Future<void> getUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    } else {
      print('User is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('MY TODO LIST'),
        actions: [
          IconButton(icon : Icon(Icons.logout),onPressed: () async{
                await FirebaseAuth.instance.signOut();
    }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('My Tasks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No tasks available'),
              );
            }

            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var time = (docs[index]['timestamp'] as Timestamp).toDate();

                return InkWell(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(title: docs[index]['title'],
                      description: docs[index]['description'],
                      )));
                  },
                  child:Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child : Text(docs[index]['title'] ?? 'No title',
                              style: GoogleFonts.roboto(fontSize: 20))
                      ),
                          SizedBox(height: 5,),

                          Container(
                              margin: EdgeInsets.only(left: 20),

                              child: Text(DateFormat.yMd().add_jm().format(time))
                          )
                ]),
                      Container(child: IconButton
                        (icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: ()async{
                          await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('My Tasks').doc(docs[index]['time']).delete();
                        },),)
                    ],

                  ),
                )
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
        },
      ),
    );
  }
}
