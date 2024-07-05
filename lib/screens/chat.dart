import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:gchat/provider/provider.dart';

class Chat extends StatefulWidget {
  final String userId;
  static const String id = "chat_screen";

  const Chat({super.key, required this.userId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  String name = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    var info = await authProvider.getUserInfo(widget.userId);
    if (info != null) {
      setState(() {
        name = info['userName'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('chats').add({
      'text': _messageController.text,
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.userId,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(
                          name.isNotEmpty
                              ? name.substring(0, 2).toUpperCase()
                              : '',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(name, style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .where('senderId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('receiverId', isEqualTo: widget.userId)
                        .snapshots(),
                    builder: (context, sentSnapshot) {
                      if (!sentSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final sentMessages = sentSnapshot.data!.docs;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where('senderId', isEqualTo: widget.userId)
                            .where('receiverId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, receivedSnapshot) {
                          if (!receivedSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final receivedMessages = receivedSnapshot.data!.docs;

                          final allMessages = [
                            ...sentMessages,
                            ...receivedMessages,
                          ];

                          return ListView.builder(
                            itemCount: allMessages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final message = allMessages[index];
                              bool isMe = message['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid;
                              return Row(
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? Colors.white
                                          : const Color(0xFFDEA531),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      message['text'],
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.black : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your message...',
                          ),
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
