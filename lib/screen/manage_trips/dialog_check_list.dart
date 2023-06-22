import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/custom_user.dart';
import 'package:go_together/model/trip.dart';
import 'package:logger/logger.dart';
import 'package:collection/collection.dart';

class DialogCheckList extends StatefulWidget {
  const DialogCheckList({super.key, required this.trip});

  final Trip trip;

  @override
  State<DialogCheckList> createState() => _DialogCheckListState();
}

class _DialogCheckListState extends State<DialogCheckList> {
  List<bool> listJoin = [];

  @override
  void initState() {
    for (var e in widget.trip.members) {
      listJoin.add(false);
    }
    print(widget.trip.idTrip);
    super.initState();
  }

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
          itemCount: widget.trip.members.length,
          itemBuilder: (ctx, index) => ItemCheckList(
              member: widget.trip.members[index],
              onPress: () {
                listJoin[index] = !listJoin[index];
              }),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[500],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              for (int i = 0; i < listJoin.length; i++) {
                if (listJoin[i]) {
                  for (int j = 0; j < widget.trip.members.length; j++) {
                    if (i == j) {
                      continue;
                    }
                    final data1 = await FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.trip.members[i].idUser)
                        .get();
                    final data2 = await FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.trip.members[j].idUser)
                        .get();
                    final user1 = CustomUser.fromJson(data1.data()!);
                    final user2 = CustomUser.fromJson(data2.data()!);
                    Logger().v(user1);
                    await FirebaseFirestore.instance
                        .collection('TripMembersJoin')
                        .add({
                      "idTrip": widget.trip.idTrip,
                      'idCreator': widget.trip.idCreator,
                      'idUser1': user1.idUser,
                      'idUser2': user2.idUser,
                      'nameTrip': widget.trip.title,
                      'userName': user2.fullName,
                      'phone': user2.phone,
                      'status': false,
                      'image': user2.image
                    }).then((value) async {
                      await FirebaseFirestore.instance
                          .collection('TripMembersJoin')
                          .doc(value.id)
                          .update({
                        'idTripMembersJoin': value.id,
                      });
                    });
                  }
                }
              }
              await FirebaseFirestore.instance
                  .collection('Trip')
                  .doc(widget.trip.idTrip)
                  .update({'status': 'completed'});
              // await FirebaseFirestore.instance
              //     .collection('TripMembersJoin')
              //     .doc(widget.trip.idTrip)
              //     .set({
              //   "idTrip": widget.trip.idTrip,
              //   'listMember': listJoin
              //       .mapIndexed((index, element) => listJoin[index]
              //           ? widget.trip.members[index].toJson()
              //           : null)
              //       .toList(),
              //   'idCreator': widget.trip.idCreator,
              // }).then((value) async {
              //   await FirebaseFirestore.instance
              //       .collection('Trip')
              //       .doc(widget.trip.idTrip)
              //       .update({'status': 'completed'});
              // });
              // Logger().v(listJoin);
              Navigator.pop(context, true);
            },
            child: Text('Ok'))
      ],
    );
  }
}

class ItemCheckList extends StatefulWidget {
  const ItemCheckList({super.key, required this.member, required this.onPress});

  final Member member;
  final VoidCallback onPress;

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
                widget.onPress();
                setState(() {
                  selected = value!;
                });
              })
        ],
      ),
    );
  }
}
