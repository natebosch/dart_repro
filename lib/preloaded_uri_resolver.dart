import 'package:analyzer/src/generated/engine.dart' show TimestampedData;
import 'package:analyzer/src/generated/source.dart';
import 'package:path/path.dart' as p;

import 'asset_id.dart';

class PreloadedUriResolver implements UriResolver {
  final _knownAssets = <Uri, Source>{};

  /// Read all [assets] with the extension '.dart' using the [read] function up
  /// front and cache them as a [Source].
  void addAssets(Iterable<AssetId> assets, String Function(AssetId) read) {
    for (var asset in assets.where((asset) => asset.path.endsWith('.dart'))) {
      var uri = assetUri(asset);
      if (!_knownAssets.containsKey(uri)) {
        _knownAssets[uri] = AssetSource(asset, read(asset));
      }
    }
  }

  @override
  Source resolveAbsolute(Uri uri, [Uri actualUri]) {
    return _knownAssets[uri];
  }

  @override
  Uri restoreAbsolute(Source source) {
    throw UnimplementedError();
  }
}

class AssetSource implements Source {
  final AssetId _assetId;
  final String _content;

  AssetSource(this._assetId, this._content);

  @override
  TimestampedData<String> get contents => TimestampedData(0, _content);

  @override
  String get encoding => '${assetUri(_assetId)}';

  @override
  String get fullName => '${assetUri(_assetId)}';

  @override
  int get hashCode => _assetId.hashCode;

  @override
  bool get isInSystemLibrary => false;

  @override
  Source get librarySource => null;

  @override
  int get modificationStamp => 0;

  @override
  String get shortName => p.basename(_assetId.path);

  @override
  Source get source => this;

  @override
  Uri get uri => assetUri(_assetId);

  @override
  UriKind get uriKind {
    if (_assetId.path.startsWith('lib/')) return UriKind.PACKAGE_URI;
    return UriKind.FILE_URI;
  }

  @override
  bool operator ==(Object other) =>
      other is AssetSource && other._assetId == _assetId;

  @override
  bool exists() => true;

  @override
  String toString() => 'AssetSource[${assetUri(_assetId)}]';
}

Uri assetUri(AssetId assetId) => assetId.path.startsWith('lib/')
    ? Uri(
        scheme: 'package',
        path: '${assetId.package}/${assetId.path.replaceFirst('lib/', '')}')
    : Uri(scheme: 'asset', path: '${assetId.package}/${assetId.path}');
