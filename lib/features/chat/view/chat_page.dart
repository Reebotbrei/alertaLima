import 'package:alerta_lima/app/theme/app_colors.dart';
import 'package:alerta_lima/app/widgets/app_text_field.dart';
import 'package:alerta_lima/app/widgets/chat_bubble.dart';
import 'package:alerta_lima/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatViewmodel _authService = ChatViewmodel();
  final ChatViewmodel _chatService = ChatViewmodel();


  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 700), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.extentTotal,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
        widget.receiverID,
        _messageController.text,
      );
      _messageController.clear();
    }

    scrollDown();
  }

  Future<String> obtenerNombre(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Usuario').get();
    for (var doc in querySnapshot.docs) {
      if (doc['Email'] == email) {
        return doc["Nombre"]; 
      }
    }
    return 'Anónimo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: obtenerNombre(widget.receiverEmail),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Text(snapshot.data ?? 'Anónimo');
            }
          },
        ),
        centerTitle: true,
      ),
      body: Column(        
        children: [
          SizedBox(height: 5),
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Ocurrió un Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser
        ? Alignment.bottomRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: AppTextField(
                controller: _messageController,
                hintText: "Escribe un mensaje",
                obscureText: false,
                focusNode: myFocusNode,
              ),
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,             
            ),
            height: 49.5,
            width: 49.5,
            margin: const EdgeInsets.only(right: 3),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
