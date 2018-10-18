class AssetId {
  final String package;
  final String path;

  AssetId(this.package, this.path);

  @override
  bool operator ==(Object other) =>
      other is AssetId && other.package == package && other.path == path;

  @override
  int get hashCode => package.hashCode * 31 + path.hashCode;
}
