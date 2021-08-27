import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeta_hackathon/dependency_injector.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';
import 'package:zeta_hackathon/widgets/custom_scaffold.dart';

class DebugPopUp extends StatelessWidget {
  DebugPopUp({Key? key}) : super(key: key);
  final IdentityService identityService = sl<IdentityService>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'DEBUG DETAILS',
      body: Column(
        children: [
          Row(
            children: [
              Text('Account Holder ID: '),
              GestureDetector(
                child: Text('${identityService.getAccountHolderId()}'),
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: identityService.getAccountHolderId()));
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Account ID'),
              GestureDetector(
                child: Text('${identityService.getAccountId()}'),
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: identityService.getAccountId()));
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Pool Account ID'),
              GestureDetector(
                child: Text('${identityService.getPoolAccountId()}'),
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: identityService.getPoolAccountId()));
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Resource ID'),
              GestureDetector(
                child: Text('${identityService.getResourceId()}'),
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: identityService.getResourceId()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
