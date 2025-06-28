import 'package:alerta_lima/features/chat/view/chat_page.dart';
import 'package:alerta_lima/features/chat/view/chat_user_tile.dart';
import 'package:flutter/material.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../../../app/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatViewmodel _chatViewmodel = ChatViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contactos'),
        centerTitle: true,
        // // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.grey,
        // elevation: 0,
      ),
      body: _builUserList(),
    );
  }

  Widget _builUserList() {
    return StreamBuilder(
      stream: _chatViewmodel.getAutorithies(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Ocurrió un Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData) {
    if ((userData['Email'] ?? "Usuario sin correo") !=
        ChatViewmodel().getCurrentUser()!.email) {
      return UserTile(
        text: userData['Email'] ?? "Usuario sin correo",
        onTap: () async {
          String receiverID1 = await obtenerID(userData['Email']);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['Email'] ?? "Usuario sin correo",
                receiverID: receiverID1,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Future<String> obtenerID(String email) async {
    QuerySnapshot querySnapshot = await _firestore.collection('Usuario').get();

    for (var doc in querySnapshot.docs) {
      if (doc['Email'] == email) {
        return doc.id;
      }
    }
    return 'AjBEShVMNBR0ckJRt8A1HPiL2zn1';
  }
}
