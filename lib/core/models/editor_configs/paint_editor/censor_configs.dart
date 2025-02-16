/// A configuration class for defining blur settings for censoring content.
class CensorConfigs {
  /// Creates a new instance of [CensorConfigs].
  ///
  /// - [blurSigmaX]: The standard deviation for the Gaussian blur in the
  ///   horizontal direction.
  /// - [blurSigmaY]: The standard deviation for the Gaussian blur in the
  ///   vertical direction.
  ///
  /// Both values default to `14.0`.
  const CensorConfigs({
    this.blurSigmaX = 14,
    this.blurSigmaY = 14,
  });

  /// The standard deviation for the Gaussian blur in the horizontal direction.
  final double blurSigmaX;

  /// The standard deviation for the Gaussian blur in the vertical direction.
  final double blurSigmaY;

  /// Returns a new [CensorConfigs] instance with updated values.
  ///
  /// If a parameter is not provided, the existing value is retained.
  ///
  /// - [blurSigmaX]: New value for the horizontal blur, if provided.
  /// - [blurSigmaY]: New value for the vertical blur, if provided.
  CensorConfigs copyWith({
    double? blurSigmaX,
    double? blurSigmaY,
  }) {
    return CensorConfigs(
      blurSigmaX: blurSigmaX ?? this.blurSigmaX,
      blurSigmaY: blurSigmaY ?? this.blurSigmaY,
    );
  }
}
