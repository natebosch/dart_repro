import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/dart/analysis/file_state.dart';
import 'package:analyzer/src/generated/engine.dart'
    show AnalysisEngine, AnalysisOptionsImpl;
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/summary/package_bundle_reader.dart'
    show InSummaryUriResolver, SummaryDataStore;
import 'package:analyzer/file_system/physical_file_system.dart'
    show PhysicalResourceProvider;
import 'package:analyzer/src/dart/analysis/byte_store.dart'
    show MemoryByteStore;
import 'package:analyzer/src/dart/analysis/performance_logger.dart'
    show PerformanceLog;
import 'package:analyzer/src/summary/summary_sdk.dart' show SummaryBasedDartSdk;

import 'preloaded_uri_resolver.dart';

/// Builds an [AnalysisContext] backed by a summary SDK and package summary
/// files.
///
/// Any code which is not covered by the summaries must be resolvable through
/// [preloadedUriResolver].
AnalysisDriver buildAnalyzer(String sdkSummary, List<String> summaryPaths,
    PreloadedUriResolver preloadedUriResolver) {
  AnalysisEngine.instance.processRequiredPlugins();
  var sdk = SummaryBasedDartSdk(sdkSummary, true);
  var sdkResolver = DartUriResolver(sdk);

  var summaryData = SummaryDataStore(summaryPaths)..addBundle(null, sdk.bundle);
  var summaryResolver =
      InSummaryUriResolver(PhysicalResourceProvider.INSTANCE, summaryData);

  var resolvers = [preloadedUriResolver, sdkResolver, summaryResolver];
  var sourceFactory = SourceFactory(resolvers);

  var logger = PerformanceLog(null);
  var scheduler = AnalysisDriverScheduler(logger);
  var driver = AnalysisDriver(
      scheduler,
      logger,
      preloadedUriResolver.resourceProvider,
      MemoryByteStore(),
      FileContentOverlay(),
      null,
      sourceFactory,
      AnalysisOptionsImpl(),
      externalSummaries: summaryData);

  scheduler.start();
  return driver;
}
