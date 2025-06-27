import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final viewModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      body: Center(
        child: Row(          
          children: [
            Icon(Icons.engineering),
            Text("Hombres trabajando", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
