import 'package:go_together/repository/notification_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
class ChatUtil{
  static final user=Auth.FirebaseAuth.instance.currentUser!;
  static final client = StreamChatClient(
    'd5k87ckf34wh',
    logLevel: Level.INFO,
  );
  static final channel = client.channel('messaging', id: user.uid);
  static bool onBackground=false;
  static void listenForNewMessages(StreamChatClient client) {
  client.on(EventType.messageNew,
  EventType.notificationMessageNew,).listen((event) {
    if (event.message?.user?.id == client.state.currentUser?.id) {
    return;
  }
    final message = event.message;
    final sender = message!.user;
    if(!onBackground)
    NotificationRepository().createNotification(sender!.name, message.text!);
  });
  }
  static void initChat()async{
   await client.connectUser(
    User(id: user.uid,role: "user", image: user.photoURL, name: user.displayName),
    await client.devToken(user.uid).rawValue,);
    listenForNewMessages(client);
    print("connect");
  } 
}