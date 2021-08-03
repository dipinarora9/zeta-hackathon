import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;

  const CustomScaffold(
      {Key? key, required this.title, required this.body, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actions,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Container(
          child: body,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            maxWidth: 500,
          ),
        ),
      ),
    );
  }
}
