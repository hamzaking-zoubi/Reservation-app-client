import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhrs_app/constants.dart';
import '../components/time_ago.dart';
import '../models/chats_model.dart';
import 'chat_room.dart';

class AllChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AllChat>(context).fetchAllChatList(),
      builder: ((context, AsyncSnapshot<List<Chat>> snapshot) =>
          snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: ((context, index) => Column(
                        children: [
                          ItemChat(
                            avatar: snapshot.data[index].avatar,
                            countNotRead: snapshot.data[index].countNotRead,
                            lastMessage: snapshot.data[index].lastMessage,
                            name: snapshot.data[index].name,
                            time: snapshot.data[index].time,
                            id: snapshot.data[index].id,
                            status: snapshot.data[index].status,
                          ),
                          Divider(
                            height: 3,
                          )
                        ],
                      )),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

class ItemChat extends StatelessWidget {
  final String lastMessage;
  final String name;
  final int countNotRead;
  final String avatar;
  final String time;
  final String id;
  final bool status;

  ItemChat(
      {this.lastMessage,
      this.name,
      this.countNotRead,
      this.avatar,
      this.time,
      this.id,
      this.status});

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    return Container(
        width: wd,
        // height:75 ,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(localApi + avatar),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return ChatRoom(
                    countNotRead: countNotRead,
                    id: id,
                    name: name,
                    id_recipient: id,
                    statuse: status,
                    avatar: avatar,
                  );
                }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: wd / 1.9,
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: 16,
                          ),
                      softWrap: false,
                    ),
                  ),
                  Container(
                    width: wd / 1.9,
                    child: Text(
                      lastMessage,
                      style: Theme.of(context).textTheme.bodyText1,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                countNotRead == 0
                    ? Icon(
                        Icons.done,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      )
                    : CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          countNotRead.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
//                TimeAgo.isSameDay(time)
//                    ? Container()
//                    :
                Container(
                  width: wd / 6,
                  child: Text(
                    "${TimeAgo.timeAgoSinceDate(time)}",
                    style: Theme.of(context).textTheme.bodyText1,
                    softWrap: false,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
