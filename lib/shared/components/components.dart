import 'package:flutter/material.dart';
import 'package:getdon/shared/cubit/cubit.dart';

Widget defaultTextField({
  required controller,
  required label,
  required TextInputType type,
  required String? Function(String?)? validate,
  void Function()? onTap,
  IconData? prefix,
  bool? isObscure,
  void Function(String)? onChange,
  void Function(String)? onSubmitted,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isObscure ?? false,
    decoration: InputDecoration(
      label: label,
      prefixIcon: Icon(prefix),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    onChanged: onChange,
    onFieldSubmitted: onSubmitted,
    keyboardType: type,
    onTap: onTap,
    validator: validate,
  );
}

Widget taskWidget(Map model,BuildContext context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Text(
              "${model['time']}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model['title']}",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${model['date']}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: (){
            AppCubit.get(context).updatestate(state: 'done', id: model['id']);
          } , icon: Icon(Icons.check_box_outlined,color: Theme.of(context).colorScheme.primary,)),
          IconButton(onPressed: (){
            AppCubit.get(context).updatestate(state: 'archived', id: model['id']);
          }, icon: const Icon(Icons.archive_outlined,color: Colors.grey,))
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}

