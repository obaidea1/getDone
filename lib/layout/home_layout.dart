import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getdon/shared/components/components.dart';
import 'package:getdon/shared/cubit/cubit.dart';
import 'package:getdon/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {
            if(state is AppInsertToDatabase){
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.title[cubit.currentIndex]),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            height: 300,
                            width: double.infinity,
                            margin: const EdgeInsets.all(30),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  defaultTextField(
                                    controller: titleController,
                                    label: const Text("Title"),
                                    type: TextInputType.text,
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "title must not be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextField(
                                    controller: timeController,
                                    label: const Text("Time"),
                                    type: TextInputType.none,
                                    prefix: Icons.watch_later_outlined,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "title must not be empty";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultTextField(
                                    controller: dateController,
                                    label: const Text("Date"),
                                    type: TextInputType.none,
                                    prefix: Icons.calendar_today_outlined,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "title must not be empty";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2025-01-01'))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheet(false);
                    });
                    cubit.changeBottomSheet(true);
                  }
                },
                child: Icon(
                  cubit.isBottomSheetShown ? Icons.add : Icons.edit,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeIndex(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.density_medium_rounded),
                    label: "Task",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.done_rounded),
                    label: "Done Task",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "Archaved Task",
                  ),
                ],
              ),
              body: state is AppIsLoadingFromDatabase? const Center(child: CircularProgressIndicator(),): cubit.screen[cubit.currentIndex],
            );
          }),
    );
  }
}
