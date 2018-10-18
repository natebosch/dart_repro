import 'package:analyzer/src/context/context.dart' show AnalysisContextImpl;
import 'package:analyzer/src/generated/engine.dart'
    show AnalysisContext, AnalysisEngine, InternalAnalysisContext;
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/summary/package_bundle_reader.dart'
    show InSummaryUriResolver, InputPackagesResultProvider, SummaryDataStore;
import 'package:analyzer/file_system/physical_file_system.dart'
    show PhysicalResourceProvider;
import 'package:analyzer/src/summary/summary_sdk.dart' show SummaryBasedDartSdk;

import 'preloaded_uri_resolver.dart';

/// Builds an [AnalysisContext] backed by a summary SDK and package summary
/// files.
///
/// Any code which is not covered by the summaries must be resolvable through
/// [preloadedUriResolver].
AnalysisContext buildAnalyzer(String sdkSummary, List<String> summaryPaths,
    PreloadedUriResolver preloadedUriResolver) {
  AnalysisEngine.instance.processRequiredPlugins();
  var sdk = SummaryBasedDartSdk(sdkSummary, true);
  var sdkResolver = DartUriResolver(sdk);

  var summaryData = SummaryDataStore(summaryPaths)..addBundle(null, sdk.bundle);
  var summaryResolver =
      InSummaryUriResolver(PhysicalResourceProvider.INSTANCE, summaryData);

  var resolvers = [preloadedUriResolver, sdkResolver, summaryResolver];
  var sourceFactory = SourceFactory(resolvers);

  var context = AnalysisEngine.instance.createAnalysisContext()
    ..sourceFactory = sourceFactory;
  (context as AnalysisContextImpl).resultProvider = InputPackagesResultProvider(
      context as InternalAnalysisContext, summaryData);

  return context;
}
