import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/trip.dart';

class DialogCheckList extends StatelessWidget {
  const DialogCheckList({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Check list')),
      contentPadding: EdgeInsets.all(12),
      titlePadding: EdgeInsets.only(top: 12),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.height * 0.7,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: trip.members.length,
          itemBuilder: (ctx, index) =>
              ItemCheckList(member: trip.members[index]),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[500],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Trip')
                  .doc(trip.idTrip)
                  .update({'status': 'completed'});
              
              Navigator.pop(context, true);
            },
            child: Text('Ok'))
      ],
    );
  }
}

class ItemCheckList extends StatefulWidget {
  const ItemCheckList({super.key, required this.member});

  final Member member;

  @override
  State<ItemCheckList> createState() => _ItemCheckListState();
}

class _ItemCheckListState extends State<ItemCheckList> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(widget.member.image),
              ),
              SizedBox(
                width: 22,
              ),
              Text('Day la ten')
            ]),
          ),
          Checkbox(
              value: selected,
              onChanged: (value) {
                setState(() {
                  selected = value!;
                });
              })
        ],
      ),
    );
  }
}
