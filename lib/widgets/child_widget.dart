import 'package:flutter/material.dart';

import '../routes.dart';

class ChildWidget extends StatelessWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(Routes.modifyChild),
      title: Text('Child A'),
    );
  }
}
