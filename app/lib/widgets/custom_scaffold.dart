import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget? leadingWidget;
  final Widget? floatingActionButton;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final GlobalKey<ScaffoldState>? sKey;

  const CustomScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.leadingWidget,
      this.actions,
      this.floatingActionButton,
      this.sKey,
      this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey ?? key,
      appBar: AppBar(
        actions: actions,
        leading: showBackButton
            ? IconButton(
                color: Colors.black,
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.of(context).pop(),
              )
            : leadingWidget ?? Container(),
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
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: body,
          ),
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
