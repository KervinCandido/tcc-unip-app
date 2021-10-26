class Setting {
  final String key;
  final String value;

  Setting(this.key, this.value);

  Map<String, Object?> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }
}
