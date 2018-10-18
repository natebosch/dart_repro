import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:path/path.dart' as p;

import 'asset_id.dart';

class PreloadedUriResolver implements UriResolver {
  final _cachedAssets = Set<AssetId>();
  final resourceProvider = MemoryResourceProvider();

  /// Read all [assets] with the extension '.dart' using the [read] function up
  /// front and cache them as a [Source].
  void addAssets(Iterable<AssetId> assets, String Function(AssetId) read) {
    for (var asset in assets
        .where((asset) => asset.path.endsWith('.dart'))
        .where(_cachedAssets.add)) {
      resourceProvider.newFile(assetPath(asset), read(asset));
    }
  }

  @override
  Source resolveAbsolute(Uri uri, [Uri actualUri]) {
    if (uri.isScheme('dart')) return null;
    final id = uri.isScheme('package')
        ? AssetId(uri.pathSegments.first,
            p.url.join('lib', p.url.joinAll(uri.pathSegments.skip(1))))
        : uri.isScheme('asset')
            ? AssetId(
                uri.pathSegments.first, p.url.joinAll(uri.pathSegments.skip(1)))
            : AssetId(p.split(uri.path).elementAt(1),
                p.joinAll(p.split(uri.path).skip(2)));
    if (!_cachedAssets.contains(id)) return null;
    return resourceProvider.getFile(assetPath(id)).createSource();
  }

  @override
  Uri restoreAbsolute(Source source) => p.toUri(source.fullName);
}

Uri assetUri(AssetId assetId) =>
    p.toUri(p.url.join('/${assetId.package}', assetId.path));

String assetPath(AssetId assetId) =>
    p.url.join('/${assetId.package}', assetId.path);
