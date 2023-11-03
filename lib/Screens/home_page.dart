
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:todo_app/Screens/completed%20todos.dart';
import 'package:todo_app/Screens/todo%20screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myBox = Hive.box('to_do Hive');
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> completedList = [];

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadtodoList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: Text(
          'Todo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedTodosScreen(completedTodos: completedList,)),);},
            child: Row(
              children: [
                Icon(CupertinoIcons.check_mark_circled_solid),
                SizedBox(width: 5),
                Text('Completed',),],
            ),
          ),
        ],
      ),


        body: todoList.isEmpty
          ? Column(
        children: [
          SizedBox(height: 100),
          Image.network('https://www.shipbots.com/wp-content/uploads/2022/01/28.webp'),
          SizedBox(height: 20,),
          Text(
            'What do you want to do today',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      )
          : ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (ctx, index) {
          final mytodoList = todoList[index];
          return Builder(
            builder: (BuildContext context){
            return Slidable(
              startActionPane: ActionPane(motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                        icon: Icons.check,
                        backgroundColor: Colors.green,
                        onPressed: (context) {
                          markAsDone(mytodoList['id']);
                        }
                    ),

                  ]),
              endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children:[
                    SlidableAction(
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      onPressed: (BuildContext context) {
                        deletetodoList(mytodoList['id']);
                        },
                    ),
                  ] ),
              child: GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> TodoScreen(
                      title: mytodoList['title'],
                      details: mytodoList['details'],
                      date: mytodoList['date'],
                      time: mytodoList['time'],)
                )
                );
                  },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 12),
                  child: Card(
                    color: Colors.yellowAccent,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(mytodoList['title'],style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                          Text('pending...')
                        ],
                      ),
                      subtitle: Text(mytodoList['date']),
                      trailing:  IconButton(
                        onPressed: () {
                          showtodoList(context, mytodoList['id']);
                        },
                        icon: const Icon(Icons.edit),),),

                  ),
                ),
              ),
            );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showtodoList(context, null),
        label: Text('Create'),
        icon: Icon(Icons.add),
      ),
    );
  }
  void markAsDone(int id) {
    final index = todoList.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      completedList.add(todoList[index]);
      todoList.removeAt(index);

      setState(() {

      });
    }
  }


  void showtodoList(BuildContext context, int? key) {
    if (key != null) {
      final currenttodoList = todoList.firstWhere((element) => element['id'] == key);
      titleController.text = currenttodoList['title'];
      detailController.text = currenttodoList['details'];
      dateController.text = currenttodoList['date'];
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15,
              bottom: MediaQuery.of(context).viewInsets.top + 50),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [SizedBox(height: 25,),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 250,
                child: TextField(
                  expands: true,
                  controller: detailController,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Details",
                  ),
                ),
              ),
              SizedBox(height: 15),
              SfDateRangePicker(
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  DateTime selectedDate = args.value;
                  dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                },
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: DateTime.now(),
              ),
              ElevatedButton(
                  onPressed: (){
                    showTimePickerDialog(context);
                    timeController.text.trim();
                    },
                  child: Text('pick time')),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      detailController.text.isNotEmpty &&
                      dateController.text.isNotEmpty) {
                    if (key == null) {
                      createTodo({
                        'title': titleController.text.trim(),
                        'details': detailController.text.trim(),
                        'date': dateController.text.trim(),
                        'time': timeController.text.trim()
                      });
                    } else {
                      updatetodoList(key, {
                        'title': titleController.text.trim(),
                        'details': detailController.text.trim(),
                        'date': dateController.text.trim(),
                        'time': timeController.text.trim()
                      });
                    }
                  }
                  titleController.text = "";
                  detailController.text = "";
                  dateController.text = "";
                  timeController.text= "";
                  Navigator.of(context).pop();
                },
                child: Text(key == null ? 'Create' : 'Update'),
              ),

            ],
          ),
        );
      },
    );
  }


  Future<void> createTodo(Map<String, dynamic> noteData) async {
    await myBox.add(noteData);
    loadtodoList();
  }

  void updatetodoList(int? key, Map<String, dynamic> updateData) async {
    await myBox.put(key, updateData);
    loadtodoList();
  }

  void loadtodoList() {
    final todoListData = myBox.keys.map((id) {
      final value = myBox.get(id);
      return {
        'id': id,
        'title': value['title'],
        'details': value['details'],
        'date': value['date'],
        'time': value['time']
      };
    }).toList();

    setState(() {
      todoList = todoListData.reversed.toList();
    });
  }

  void showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  Future<void> deletetodoList(int? key) async {
    await myBox.delete(key);
    loadtodoList();
  }
}
