import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/services/cloud_error_messages.dart';
import 'package:lokalnie_widzew/services/push_navigation.dart';

void main() {
  test('reads announcementId and route from FCM data', () {
    expect(
      PushNavigation.announcementId({'announcementId': 'abc-1'}),
      'abc-1',
    );
    expect(
      PushNavigation.announcementId({'route': 'announcement:post-9'}),
      'post-9',
    );
    expect(PushNavigation.tabIndex({'route': 'saved'}), 1);
    expect(PushNavigation.tabIndex({'route': 'wiadomości'}), 2);
    expect(PushNavigation.tabIndex({'route': 'profil'}), 3);
    expect(PushNavigation.tabIndex({'route': 'home'}), 0);
  });

  test('parses local notification payload query and json', () {
    expect(
      PushNavigation.dataFromPayload('announcementId=xyz&route=home'),
      {'announcementId': 'xyz', 'route': 'home'},
    );
    expect(
      PushNavigation.dataFromPayload('{"route":"saved","announcementId":""}'),
      {'route': 'saved', 'announcementId': ''},
    );
    expect(PushNavigation.dataFromPayload('plain-id'), {
      'announcementId': 'plain-id',
    });
  });

  test('maps cloud exceptions to Polish copy', () {
    expect(
      CloudErrorMessages.from('PERMISSION_DENIED: missing or insufficient'),
      CloudErrorMessages.permissionDenied,
    );
    expect(
      CloudErrorMessages.from(
        'SocketException: Failed host lookup firestore.googleapis.com',
      ),
      CloudErrorMessages.offline,
    );
    expect(CloudErrorMessages.from(StateError('boom')), CloudErrorMessages.dataFailed);
  });
}
