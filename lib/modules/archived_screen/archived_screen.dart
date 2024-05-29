import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getdon/shared/components/components.dart';
import 'package:getdon/shared/cubit/cubit.dart';
import 'package:getdon/shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).archivedTasks;
          return tasks.isEmpty
              ?  const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list,size: 100,color: Colors.grey,),
                      const Text("There's no task , try add some Task..",style: TextStyle(fontSize: 20),)
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) =>
                      taskWidget(tasks[index], context),
                  separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                      ),
                  itemCount: tasks.length);
        },
        listener: (context, state) {});
  }
}
