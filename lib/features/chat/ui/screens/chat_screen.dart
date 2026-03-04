
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key , required this.personName});

  final String personName ;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.personName,
          showCartIcon: false ,
          onCartTap: (){},
          leading: true,
      ),
      body: Center(
        child: Text("chat"),
      ),
    );
  }
}
