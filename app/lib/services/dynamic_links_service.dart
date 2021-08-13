import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/helpers/ui_helper.dart';
import 'package:zeta_hackathon/routes.dart';
import 'package:zeta_hackathon/services/authentication_service.dart';
import 'package:zeta_hackathon/services/identitiy_service.dart';

import '../dependency_injector.dart';

class DynamicLinks {
  static handleDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.getInitialLink().then(
        (data) => data != null ? _parseDynamicLinkData(context, data) : null);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? data) async {
      if (data != null) _parseDynamicLinkData(context, data);
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
      UIHelper.showToast(msg: e.message);
    });
  }

  static _parseDynamicLinkData(
      BuildContext context, PendingDynamicLinkData data) async {
    final Uri? deepLink = data.link;
    final Map<String, dynamic> query = {};
    final Map<String, dynamic> query2 = {};

    if (deepLink != null) {
      deepLink.queryParameters.forEach((k, v) {
        query[k] = v;
      });
      Uri.parse(query['continueUrl']).queryParameters.forEach((k, v) {
        query2[k] = v;
      });

      if (query.length > 0 && query2.length > 0) {
        AuthenticationService authenticationService =
            sl<AuthenticationService>();
        AppResponse<bool> response = await authenticationService.loginAsChild(
            query2['email'], deepLink.toString());
        if (!response.isSuccess()) {
          debugPrint(response.error);
          UIHelper.showToast(msg: response.error);
          return;
        }
        IdentityService identityService = sl<IdentityService>();
        await identityService.setParentId(query2['parent_id']);
        await identityService.setUserId(query2['child_id']);
        await identityService.refreshUser();
        UIHelper.showToast(msg: 'Log In Success');
        await Navigator.of(context).pushNamed(Routes.homepageChild);
        return;
      }
    }
  }
}
