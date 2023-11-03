
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompletedTodosScreen extends StatefulWidget {
  final List<Map<String, dynamic>> completedTodos ;


  CompletedTodosScreen({ required this.completedTodos});

  @override
  State<CompletedTodosScreen> createState() => _CompletedTodosScreenState();
}

class _CompletedTodosScreenState extends State<CompletedTodosScreen> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Todos'),
      ),
      body: ListView.builder(
        itemCount: widget.completedTodos.length,
        itemBuilder: (context, index) {
          final todo = widget.completedTodos[index];
          return Builder(
              builder: (BuildContext context){
                return  Slidable(
                  endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            onPressed: (BuildContext context){
                              deleteTodo(todo);
                            })
                      ]),




                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 18),
                    child: Card(
                      color: Colors.green,
                      child: ListTile(
                        title: Text(todo['title']),
                        subtitle: Text(todo['date']),

                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void deleteTodo(Map<String, dynamic> todo) {
    widget.completedTodos.remove(todo);
    setState(() {

    });
  }
}

