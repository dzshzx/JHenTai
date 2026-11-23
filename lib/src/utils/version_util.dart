/// v7.7.7
int compareVersion(String a, String b) {
  List<String> numberA = a.replaceFirst('v', '').split('.');
  List<String> numberB = b.replaceFirst('v', '').split('.');

  if (numberA.length != numberB.length) {
    return 0;
  }

  for (int i = 0; i < numberA.length; i++) {
    int a = int.parse(numberA[i]);
    int b = int.parse(numberB[i]);
    if (a > b) {
      return 1;
    } else if (a < b) {
      return -1;
    }
  }

  return 0;
}

/// fork 的 release tag 形如 v8.0.18+2618，+ 后面是构建号（CI 取 master 的提交数，只增不减）。
/// 只比构建号：版本名相同、但 fork 有了新构建时也要提示。读不出构建号时不提示。
bool isNewerForkBuild(String latestTag, String currentBuildNumber) {
  int? latest = latestTag.contains('+') ? int.tryParse(latestTag.split('+').last) : null;
  int? current = int.tryParse(currentBuildNumber);
  if (latest == null || current == null) {
    return false;
  }
  return latest > current;
}
