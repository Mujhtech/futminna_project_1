import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:futminna_project_1/providers/firebase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pendingLinkDataProvider = Provider<PendingDynamicLinkData?>((ref) {
  throw UnimplementedError();
});

final dynamicLinkProvider =
    ChangeNotifierProvider<DynamicLinkController>((ref) {
  final data = ref.watch(pendingLinkDataProvider);
  return DynamicLinkController(ref, data);
});

class DynamicLinkController extends ChangeNotifier {
  final Ref _ref;
  bool loading = false;
  PendingDynamicLinkData? pendingData;
  DynamicLinkController(this._ref, this.pendingData) {
    _ref.read(dynamicLinks).onLink.listen(_onLinkStateChanged);
  }

  // @override
  // void dispose() {
  //   //_read(dynamicLinks).onLink.(_onLinkStateChanged);
  //   super.dispose();
  // }

  Future<void> _onLinkStateChanged(PendingDynamicLinkData data) async {
    pendingData = data;
    notifyListeners();
  }

  void resetPendingData() {
    pendingData = null;
    notifyListeners();
  }

  bool isPasswordReset() {
    return pendingData?.link.query.contains("passwordReset") ?? false;
  }

  bool isReferral() {
    return pendingData?.link.query.contains("referral") ?? false;
  }

  String extractOobcode() {
    final ar = pendingData?.link.query.split('&') ?? [];
    String code = '';
    for (final a in ar) {
      if (a.contains('oobCode')) {
        code = a.split('=')[1];
      }
    }
    return code;
  }

  String extractReferralCode() {
    return pendingData?.link.query.split('=')[1] ?? '';
  }

  // Future<Uri> createLink({String? query, bool isShort = false}) async {
  //   try {
  //     final dynamicLinkParams = DynamicLinkParameters(
  //       link: Uri.parse("https://swyft.ng?${query ?? ''}"),
  //       uriPrefix: "https://abubakradisa.page.link",
  //       androidParameters:
  //           const AndroidParameters(packageName: "app.swyft.swyft_prod"),
  //       iosParameters: const IOSParameters(bundleId: "app.swyft.prod"),
  //     );
  //     Uri? dynamicLink;
  //     ShortDynamicLink? shortLink;
  //     if (isShort) {
  //       shortLink = await _read(dynamicLinks).buildShortLink(dynamicLinkParams);
  //       return shortLink.shortUrl;
  //     } else {
  //       dynamicLink = await _read(dynamicLinks).buildLink(dynamicLinkParams);
  //       return dynamicLink;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
