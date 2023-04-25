import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
class ChatUtil{
  static final user=Auth.FirebaseAuth.instance.currentUser!;
  static final client = StreamChatClient(
    'd5k87ckf34wh',
    logLevel: Level.INFO,
  );
  static final channel = client.channel('messaging', id: user.uid);
  static void initChat()async{
   await client.connectUser(
    User(id: user.uid,role: "user", image: user.photoURL, name: user.displayName),
    await client.devToken(user.uid).rawValue,);
    
  }
}