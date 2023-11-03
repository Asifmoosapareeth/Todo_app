import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  final String title;
  final String details;
  final String date;
  final String time;
  const TodoScreen({super.key, required this.title, required this.details, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      body: Column(
            children: [
              SizedBox(height: 50,),
              Center(child: Text(title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              SizedBox(height: 30,),
              Text(details,),
              SizedBox(height: 25,),

              Text('DATE : ${date}'),
              SizedBox(height: 20,),
              Text('TIME : ${time}')

            ],
      ) ,
    );
  }
}
