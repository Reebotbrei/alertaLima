import 'package:alerta_lima/features/chat/view/chat_page.dart';
import 'package:alerta_lima/features/chat/view/chat_user_tile.dart';
import 'package:flutter/material.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../../../app/theme/app_colors.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatViewmodel _chatViewmodel = ChatViewmodel();

  @override
  Widget build(BuildContext context) {
    //final viewModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contactos'), centerTitle: true),
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
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    return UserTile(
      text: userData['Email'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(
            receiverEmail: userData['Email'],
          )),
        );
      },
    );
  }
}
