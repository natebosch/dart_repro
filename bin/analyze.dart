import 'dart:io';

import 'package:dart_repro/analysis.dart';
import 'package:dart_repro/asset_id.dart';
import 'package:dart_repro/preloaded_uri_resolver.dart';
import 'package:path/path.dart' as p;

void main() async {
  var summaryPath = createSummary();
  var sdkSummary = findSdkSummary();
  var preloadedUriResolver = PreloadedUriResolver();
  preloadedUriResolver.addAssets(
      _inMemoryAssets.keys, (id) => _inMemoryAssets[id]);

  var analyzer = buildAnalyzer(sdkSummary, [summaryPath], preloadedUriResolver);

  var library =
      await analyzer.getLibraryByUri('package:some_package/some_path.dart');
  print(library.source.fullName);
  print(library.units.first.unit.declaredElement.name);
}

String createSummary() {
  var library = p.absolute(p.join('lib', 'some_summarized_library'));
  var snapshot =
      p.join(sdkDir, 'bin', 'snapshots', 'dartanalyzer.dart.snapshot');
  var args = [
    snapshot,
    '--build-mode',
    '--build-summary-output-semantic=$library.sum',
    '--build-summary-only',
    'package:dart_repro/some_summarized_library.dart|$library.dart',
  ];
  var result = Process.runSync(Platform.resolvedExecutable, args);
  if (result.exitCode != 0) {
    print(result.stderr);
    throw 'Failed to create summary';
  }
  return '$library.sum';
}

String get sdkDir => p.dirname(p.dirname(Platform.resolvedExecutable));

String findSdkSummary() => p.join(sdkDir, 'lib', '_internal', 'strong.sum');

final _inMemoryAssets = {
  AssetId('some_package', 'lib/some_path.dart'):
      'import \'package:dart_repro/some_summarized_library.dart\';\n\n'
      'void main() {\n'
      'print(helloWorld() + 1);\n'
      '}\n'
};
