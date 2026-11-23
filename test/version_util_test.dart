import 'package:flutter_test/flutter_test.dart';
import 'package:jhentai/src/utils/version_util.dart';

void main() {
  group('isNewerForkBuild', () {
    test('prompts when the fork build number is higher, even with the same version name', () {
      expect(isNewerForkBuild('v8.0.18+2700', '2618'), isTrue);
    });

    test('does not prompt for the same or an older build', () {
      expect(isNewerForkBuild('v8.0.18+2618', '2618'), isFalse);
      expect(isNewerForkBuild('v8.0.19+2600', '2618'), isFalse);
    });

    test('does not prompt when the build number cannot be read', () {
      expect(isNewerForkBuild('v8.0.18', '2618'), isFalse);
      expect(isNewerForkBuild('v8.0.18+abc', '2618'), isFalse);
      expect(isNewerForkBuild('v8.0.18+2700', ''), isFalse);
    });
  });
}
