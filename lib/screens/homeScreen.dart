import 'package:flutter/material.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/model.dart';

import '../add_update-screen.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff3f0e9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          backgroundColor: Color(0xffe7dfcf),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
          title: Text(
            'Notlarım',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return Center(
                      child: Text(
                        "Not Bulunamadı.",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(81, 124, 99, 1),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          int todoId = snapshot.data![index].id!.toInt();
                          String todoTitle =
                              snapshot.data![index].title.toString();
                          String todoDesc =
                              snapshot.data![index].desc.toString();
                          String todoDT =
                              snapshot.data![index].dateandtime.toString();
                          return Dismissible(
                            key: ValueKey<int>(todoId),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent,
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(todoId);
                                dataList = dbHelper!.getDataList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color(0xffe7dfcf),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 1),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        todoTitle,
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ),
                                    subtitle: Text(
                                      todoDesc,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          todoDT,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUpdateTask(
                                                    todoId: todoId,
                                                    todoTitle: todoTitle,
                                                    todoDesc: todoDesc,
                                                    todoDT: todoDT,
                                                    update: true,
                                                  ),
                                                ));
                                          },
                                          child: Icon(
                                            Icons.edit_note,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(81, 124, 99, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(81, 124, 99, 1),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUpdateTask(),
                ));
          },
        ),
      ),
    );
  }
}
