import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.actions,
      this.floatingActionButton,
      this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actions,
        leading: showBackButton
            ? IconButton(
                color: Colors.black,
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
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
      floatingActionButton: floatingActionButton,
    );
  }
}
