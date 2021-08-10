import 'package:flutter/material.dart';
import 'package:zeta_hackathon/models/user/child.dart';

import '../routes.dart';

class ChildWidget extends StatelessWidget {
  const ChildWidget({Key? key, required this.child}) : super(key: key);
  final Child child;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () =>
          Navigator.of(context).pushNamed(Routes.modifyChild, arguments: child),
      title: Text(child.username),
    );
  }
}
