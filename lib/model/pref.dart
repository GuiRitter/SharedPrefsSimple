class Pref {
  final String key;
  final String value;

  const Pref({
    required this.key,
    required this.value,
  });

  Pref.fromJson(
    Map<String, dynamic> json,
  )   : key = json['key'] as String,
        value = json['value'] as String;

  toJson() => {
        'key': key,
        'value': value,
      };
}
