import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getdon/modules/archived_screen/archived_screen.dart';
import 'package:getdon/modules/done_task_screen/done_task_screen.dart';
import 'package:getdon/modules/task_screen/task_screen.dart';
import 'package:getdon/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  bool isBottomSheetShown = false;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screen = const [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<String> title = [
    "Current Task",
    "Done Task",
    "Archived Task",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase('task.db', version: 1, onCreate: (db, version) {
      db
          .execute(
            "CREATE TABLE TASK(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)",
          )
          .then(
            (value) => print("the table created successfuly"),
          )
          .catchError((erorr) {
        print("somthing happenen while creating table");
      });
    }, onOpen: (db) {
      getDatabase(db);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              "INSERT INTO TASK(title,time,date,status) VALUES ('$title','$time','$date','New')")
          .then(
        (value) {
          print("$value the data inserted successfully");
          emit(AppInsertToDatabase());
          getDatabase(database);
        },
      ).catchError((error) {
        print("Somthing happened while insert data ${error.toString()}");
      });
      return Future(() => null);
    });
  }

  void getDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppIsLoadingFromDatabase());
    database.rawQuery('SELECT * FROM TASK').then((value) {
      value.forEach((elemant) {
        if (elemant['status'] == 'New')
          newTasks.add(elemant);
        else if (elemant['status'] == 'done')
          doneTasks.add(elemant);
        else
          archivedTasks.add(elemant);
      });
      emit(AppGetDatabase());
      print(newTasks);
    });
  }

  void updatestate({required String state, required int id}) async {
    await database.rawUpdate(
      "UPDATE TASK SET status = ? WHERE id = ?",
      ['$state', id],
    ).then((value) {
      emit(AppUpdateDatabase());
      getDatabase(database);
    });
  }
  void deleteData ({required int id}) async{
    await database.rawDelete('DELETE FROM TASK WHERE id = ?',[id]).then((value){
      emit(AppDeleteDatabase());
      getDatabase(database);
    });
  }

  void changeBottomSheet(bool isShow) {
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheet());
  }
}
