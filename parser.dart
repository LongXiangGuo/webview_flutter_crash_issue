import 'dart:convert';
import 'dart:io';

void main() async {
  final str =
      '''simple_gesture_detector                  ✗0.1.6              ✗0.1.6              -           ✓0.2.0              
vehicle_repository                       ✗0.0.1 (path)       ✗0.0.1 (path)       -           ✗0.0.1 (path)       

transitive dev_dependencies:            
build_daemon                             ✗2.1.10             ✗2.1.10             -           ✓3.0.1 ''';

  const checkList = [
    'common_api',
    'plugins/omc_api_client',
    'repositories',
    'platform_sdk',
    'platform_sdk_test',
    'localizations_sdk',
    'feature_module_components',
    'shell',
  ];
  final soureReg = r'(git|path)';
  final versionReg = r'(✓|✗)\d\.\d.\d';
  final startReg = r'^[a-z]{1}';
  final spiltReg = r'\s{2}';
  final directDep = 'direct dependencies';
  final transitiveDep = 'transitive dependencies';
  final devDependencies = 'dev_dependencies';

  final resovledGitPackages = <ResolvedPackage>{};
  final resovledPathPackages = <ResolvedPackage>{};
  final resovledPubPackages = <ResolvedPackage>{};

  final rootDir = Directory.current.path;

  final packagesToCheck = checkList.map((e) => rootDir + '/$e');

  void appendToResovledPackageIfNeeded(String str) {
    print('======resovle $str======');
    if (str.startsWith(startReg)) {
      return;
    }
    if (!RegExp(versionReg).hasMatch(str)) {
      return;
    }
    if (!RegExp(soureReg).hasMatch(str)) {
      return;
    }
    final packageInfo = str.split(spiltReg);
    if (str.contains('git')) {
      resovledGitPackages.add(ResolvedPackage(
        name: packageInfo[0],
        current_version: packageInfo[1],
        upgradable_version: packageInfo[2],
        resolvable_version: packageInfo[3],
        latest_version: packageInfo[4],
      ));
    } else if (str.contains('path')) {
      resovledPathPackages.add(ResolvedPackage(
        name: packageInfo[0],
        current_version: packageInfo[1],
        upgradable_version: packageInfo[2],
        resolvable_version: packageInfo[3],
        latest_version: packageInfo[4],
      ));
    } else {
      resovledPubPackages.add(ResolvedPackage(
        name: packageInfo[0],
        current_version: packageInfo[1],
        upgradable_version: packageInfo[2],
        resolvable_version: packageInfo[3],
        latest_version: packageInfo[4],
      ));
    }
  }

  print('======= start check null-safety ====');
  await Future.wait(packagesToCheck.map(
    (packageDir) => pubOudated(
      processor: (str) {
        print('----- $str -----');
      },
      packageDir: packageDir,
    ),
  ));

  print('======= done =======');
  resovledGitPackages.forEach(print);
  resovledPathPackages.forEach(print);
  resovledPathPackages.forEach(print);
  print('======= print result =======');
}

typedef LineProcessor = Function(String);

Future<void> pubOudated({
  required LineProcessor processor,
  required String packageDir,
}) async {
  print('pubOudated start $packageDir');
  final process = await Process.start('dart', [
    'pub',
    'outdated',
    '--mode',
    'null-safety',
    '--directory',
    packageDir,
  ]);
  final outputlines = process.stdout.transform(utf8.decoder).transform(const LineSplitter());
  final errorLines = process.stderr.transform(utf8.decoder);
  await for (var line in outputlines) {
    processor(line);
  }
  await for (var errorLine in errorLines) {
    print('====== error $errorLine ======');
  }
  print('pubOudated end $packageDir ${process.exitCode}');
}

//dart pub outdated   --mode=null-safety --directory=mobile-connected --json  >null-safety.txt
class ResolvedPackage {
  final String name;
  final String current_version;
  final String upgradable_version;
  final String resolvable_version;
  final String latest_version;
  const ResolvedPackage({
    required this.name,
    required this.current_version,
    required this.upgradable_version,
    required this.resolvable_version,
    required this.latest_version,
  });

  @override
  bool operator ==(Object other) {
    if (other is! ResolvedPackage) {
      return false;
    }
    return super.hashCode == other.hashCode || (name == name && current_version == other.current_version);
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
